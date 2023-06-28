#######################################################
# SELECT BACKGROUND POINTS IN THE NATIVE RANGE
#######################################################

# Import and crop KG shapefile 
kg_layer <- rgdal::readOGR(here::here("./data/shapefiles/koppen_geiger"), 
                           "WC05_1975H_Koppen", 
                           verbose = FALSE)


# Reproject KG-layer
geo_proj <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
kg_layer <- sp::spTransform(kg_layer, geo_proj)

# Plot to make sure KG layer imported correctly 
# sp::plot(kg_layer)

# Coerce focal taxon GPS records into SpatialPointsDataFrame (SPDF)
records_spatial <- sp::SpatialPointsDataFrame(
  coords = cbind(species_native$lon, species_native$lat),
  data = species_native,
  proj4string = CRS(
    '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'
  )
)

# Plot to check we can overlay points on KG map
# sp::plot(kg_layer)
# points(species_native$lon,
#        species_native$lat,
#        pch = 21,
#        bg = 'mediumseagreen')

# Select KG ecoregions in which there is at least one GPS record
kg_contain <- kg_layer[records_spatial, ]

# Plot regions containing at least one record
# sp::plot(kg_contain)
# 
# sp::plot(
#   kg_layer,
#   add = TRUE,
#   col = 'gray70'
# )

# Fill the KG zones with a khaki colour if they contain at least 1 GPS point
# sp::plot(
#   kg_contain,
#   add = TRUE,
#   col = 'khaki')

# Overlay GPS points 
# points(species_native$lon, 
#        species_native$lat, 
#        pch = 21, 
#        bg = 'red', 
#        cex = 1)

# Define background area by masking WORLDCLIM layers to just the KG zones with at 
# least 1 GPS record
# - First, we have to convert the KG zones containing GPS records back into an 'sf' object

kg_contain <- sf::st_as_sf(kg_contain)

############################################################################
# Loop through all the predictor sets, and store background points for each
############################################################################

names(predictor_spatrasters)

for(p in 1:length(predictor_spatrasters) ){
  
bg_area <- terra::mask(predictor_spatrasters[[p]], kg_contain)  

# Plot to check the mask worked
# terra::plot(bg_area)

# Sample random points from the background area defined by the KG zones occupied
# - We use these background points as 'pseudo-absences' to test how well our climate
#   model can distinguish between GPS points occupied by our focal species and these 
#   'pseudo-absence' points 

set.seed(2023)

print(paste("Processing run", p, "of", length(predictor_spatrasters)))

bg_points <- terra::spatSample(
  x = bg_area,        # Raster of background area to sample points from 
  size = 1000,        # How many background points do we want?
  method = "random",  # Random points
  replace = FALSE,    # Sample without replacement
  na.rm = TRUE,       # Remove background points that have NA climate data
  as.df = TRUE,       # Return background points as data.frame object
  xy = TRUE           # Return lat/lon values for each background point
  #cells = TRUE       # Return the cell numbers in which the background points fall
) %>%
  # Rename lon and lat columns to be consistent with GPS data for focal species 
  dplyr::rename(
    lon = x,
    lat = y
  )

bg_points = as.data.frame(bg_points) %>%
  # Keep only the lat/lon columns and key environmental variables
  dplyr::select(
    decimalLatitude = lat,
    decimalLongitude = lon,
    predictor_sets[[p]]
  ) %>%
  dplyr::mutate(species = "Diaphorina_citri") %>%
  dplyr::select(
    species,
    everything()
  ) %>%
  # Drop rows with NA 
  tidyr::drop_na()

# Reproject CRS 
coordinates(bg_points) <-  ~ decimalLongitude + decimalLatitude
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(bg_points, "proj4string") <- crs_wgs84

output_name = paste("background_points_", names(predictor_spatrasters[p]), sep = "") 
assign(output_name, as.data.frame(bg_points) )

# Check background points have been drawn from the correct geographic mask
# terra::plot(kg_layer)
# points(bg_points$lon,
#        bg_points$lat,
#        pch = 21,
#        bg = 'red',
#        cex = 1)

} # for

# outputs:

background_points <- list(
  background_points_wang_preds = background_points_wang_preds,
  background_points_aidoo_preds = background_points_aidoo_preds,
  background_points_naroui_khandan_preds = background_points_naroui_khandan_preds,
  background_points_fordjour_preds = background_points_fordjour_preds,
  background_points_all_19_all_preds = background_points_all_19_all_preds,
  background_points_all_19_reduced_r2_preds = background_points_all_19_reduced_r2_preds,
  background_points_all_19_reduced_VIF_preds = background_points_all_19_reduced_VIF_preds,
  background_points_all_19_reduced_r2_VIF_preds = background_points_all_19_reduced_r2_VIF_preds,
  background_points_all_19_reduced_pcmv_r2_preds = background_points_all_19_reduced_pcmv_r2_preds,
  background_points_a_priori_all_preds = background_points_a_priori_all_preds,
  background_points_a_priori_reduced_r2_preds = background_points_a_priori_reduced_r2_preds,
  background_points_a_priori_reduced_VIF_preds = background_points_a_priori_reduced_VIF_preds,
  background_points_a_priori_reduced_pcmv_r2_preds = background_points_a_priori_reduced_pcmv_r2_preds,
  background_points_covsel_glm_preds = background_points_covsel_glm_preds,
  background_points_covsel_combined_preds = background_points_covsel_combined_preds,
  background_points_covsel_glm_apriori_preds = background_points_covsel_glm_apriori_preds,
  background_points_covsel_combined_apriori_preds = background_points_covsel_combined_apriori_preds
)
