#######################################################
# DOWNLOAD CURRENT CLIMATE RASTER LAYERS
#######################################################

# Download the WORLDCLIM raster layers for current time period to your PC
# - This will download and store all 19 WORLDCLIM layers to a folder
#   of your choice (given using 'path = ...' below)
# - Raster layers are stored as 'SpatRaster' so they are compatible with the 
#   'terra' R package 

# create this folder, and then manually add the subfolders: environmental_layers/current
#dir.create("data/")

#Uncomment this code to download WORLDCLIM layers
# wc_current <- geodata::worldclim_global(
#   var = "bio",
#   res = 2.5,      # Minute degree resolution of raster layers
#   path = here::here("./data/environmental_layers/current/"),
#   version = "2.1"
#   )

# Load the WORLDCLIM rasters layers we already have downloaded 
# - We don't need to run the download code above each new R session 

predictors <- terra::rast( list.files(
  here::here("./data/environmental_layers/current/wc2.1_2.5m/") ,
  full.names = TRUE,
  pattern = '.tif'
))

#terra::plot(predictors)

#head(predictors)

# Plot each of the 19 WORLDCLIM layers to check they imported correctly 
# terra::plot(predictors)

# Set the CRS (coordinate reference system) projection for the current climate layers 
# - Use the correct wkt CRS format - no more PROJ4 strings! 
terra::crs(predictors) <- "epsg:4326"
# terra::crs(predictors, describe = T)

#######################################################
# DOWNLOAD SPECIES GPS DATA FROM GBIF 
#######################################################

# Below, we will download GPS data from GBIF for Diaphorina citri,
# - We can download records from GBIF, or import GPS records from a .csv 
#   file that we have stored on our PC somewhere 
# - Pick the option that works for you 

# Option #1: Download species occurrences (GPS) from GBIF
# set.seed(2012)
# sp_gps <- geodata::sp_occurrence(
#   genus = "Diaphorina",
#   species = "citri",
#   download = TRUE,
#   geo = TRUE,
#   removeZeros = TRUE,
#   nrecs = 2000    # Only download 2000 GPS - remove this for a proper analysis
# )
# head(sp_gps)

# Option #2: Alternatively, we could import a csv file containing GPS data 
sp_gps <- readr::read_csv("./data/gps/Diaphorina_citri.csv") %>%
  dplyr::select(
    species,
    lat = decimalLatitude,
    lon = decimalLongitude
  )

head(sp_gps)
print("Successfully read in the GPS data file")

# Let's just keep the columns of data that we will use going forward 
sp_data <- sp_gps %>%
  dplyr::select(
    species,
    lon,
    lat
  )

#################################
# Remove duplicate GPS data 
#################################

sp_data <- sp_data %>%
  dplyr::distinct(lon, lat, .keep_all= TRUE)

#################################
# Get world map 
#################################

world_map <- rnaturalearth::ne_countries(
  scale = "medium", 
  returnclass = "sf"
) 

# Plot GPS points on world map to check our locality data is correct 
global_distr = ggplot() +
  # Add raster layer of world map 
  geom_sf(data = world_map, alpha = 0.5) +
  # Add GPS points 
  geom_point(
    data = sp_data, 
    size = 0.5,
    aes(
      x = lon, 
      y = lat,
      color = ifelse(lon > 60, "forestgreen", "red")
    )
  )  +
  scale_colour_manual(values = c("forestgreen", "red")) +
  # Set world map CRS 
  coord_sf(
    crs = 4326,
    expand = FALSE
  ) + 
  xlab("Longitude") + 
  ylab("Latitude")

ggsave("global_distribution_map.png", global_distr, dpi = 450)

# Let's just keep the GPS records from the native range to build our climate model 
# i.e. everything right of 60 degrees E
# we'll later train the model on all the occurrence data, and compare them
species_native <- sp_data %>%
  dplyr::filter(lon > 60)

print(paste("There are", nrow(species_native), "GPS points in the native range.") )

#################################
# How many points in the USA?
#################################

species_usa <- sp_data %>%
  dplyr::filter(lon > -127, lon< -65, lat > 10, lat < 50)

print(paste("There are", nrow(species_usa), "GPS points in the USA.") )

#################################
# How many points in Brazil?
#################################

species_braz <- sp_data %>%
  dplyr::filter(lon > -73.99, lon < -34.80, lat > -33.75, lat < 5.27)

print(paste("There are", nrow(species_braz), "GPS points in Brazil.") )

#################################
# How many points in Africa?
#################################

species_afr <- sp_data %>%
  dplyr::filter(lon > -26, lon < 55, lat > -48, lat < 40)

print(paste("There are", nrow(species_afr), "GPS points in Africa.") )

#################################
# Replot the GPS points on world map to see that we kept the right GPS data 
#################################

ggplot() +
  # Add raster layer of world map 
  geom_sf(data = world_map) +
  # Add GPS points 
  geom_point(
    data = species_native, 
    col = "forestgreen",
    size = 0.8,
    aes(
      x = lon, 
      y = lat
    )
  )  +
  # Set world map CRS 
  coord_sf(
    crs = 4326,
    expand = FALSE
  )
