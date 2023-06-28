#################################
# RUN USA PREDICTIONS
#################################

time_periods <- c(2010, 2050, 2070)
scenarios <- c("RCP4.5", "RCP8.5")

user_model_choice =  choose.dir(caption = "SELECT directory with MaxEnt model (e.g. LITERATURE/wang_set/default_maxent_model)")
#user_model_choice = readline("Directory with MaxEnt model (e.g. LITERATURE/wang_set/default_maxent_model): ")
#user_model_choice = user_model_choice

if(grepl("default", user_model_choice)) user_model_type = "default_maxent"
if(grepl("tuned", user_model_choice)) user_model_type = "tuned_maxent"

message(c("You chose the ", user_model_type, " model" ))

results_output = choose.dir(caption = "SELECT directory to save results (e.g. LITERATURE/wang_set/USA_results)")
#results_output = readline("Directory to save results (e.g. LITERATURE/wang_set/Brazil_results): ")
#results_output = results_output

results_output_path = paste(results_output, "/", user_model_type, "/", sep="")
results_output_path = gsub("\\\\", "/", results_output_path)

if(!dir.exists(results_output_path)){
  dir.create(results_output_path)
}

# Define a list of directories where the future climate layers are currently stored 
# save as a list

predictdir <- list(
  c(
    here::here(user_dir_2050_RCP4.5),
    here::here(user_dir_2070_RCP4.5)
  ),
  c(
    here::here(user_dir_2050_RCP8.5),
    here::here(user_dir_2070_RCP8.5)
  )
) 

##############################################
# Run the MaxEnt projections
##############################################

message("Running the MaxEnt projection....")

megaSDM::MaxEntProj(
  # Directory containing output from megaSDM::MaxEntModel
  input = here::here(user_model_choice),
  output = here::here(results_output_path), # create this folder manually
  time_periods = time_periods,
  scenarios = scenarios,
  # Directory containing all the current time period environmental layers 
  # - Requires .grd and .gri files
  study_dir = here::here(user_dir_2010),
  predict_dirs = predictdir,
  aucval = NA, 
  ncores = 2
)

##############################################
# Create time maps 
##############################################

message("Creating time maps....")

megaSDM::createTimeMaps(
  result_dir = results_output_path,
  time_periods = time_periods,
  scenarios = scenarios,
  dispersal = FALSE,
  ncores = 2
)

##############################################
# Additional statistics 
##############################################

message("Writing additional statistics...")

# The `additionalStats` function generates statistics on species range sizes 
# and changes through the multiple time steps and different scenarios. 
# - It also creates several graphs to visualize these changes.
megaSDM::additionalStats(
  result_dir = results_output_path,
  time_periods = time_periods,
  scenarios = scenarios,
  dispersal = FALSE,
  ncores = 2
)

##############################################
# Plotting maps
##############################################

usa_ext <- rnaturalearth::ne_countries(scale = "medium",
                                          returnclass = "sf") %>%
  dplyr::filter(continent == "North America")

usa_ext <- st_set_crs(usa_ext, 4326)


#######################################################
# ENSEMBLED MAP
#######################################################

message("Select the ensembled .grd file to plot in the popup window")
usa_ensembled_2010_raster_path = file.choose()

usa_ensembled_2010_raster  = terra::rast(usa_ensembled_2010_raster_path )
usa_ensembled_2010_raster  = raster::mask(usa_ensembled_2010_raster, usa_ext )

crs(usa_ensembled_2010_raster ) = "EPSG:4326"
crs(usa_ensembled_2010_raster ) == crs(usa_ext)

usa_ensembled_2010 = ggplot() +
  tidyterra::geom_spatraster(data = usa_ensembled_2010_raster) +
  scale_fill_whitebox_c(
    palette = "muted",
    breaks = seq(0, 1, 0.2),
    limits = c(0, 1)
  ) +
  
  # Add country borders
  geom_sf(data = usa_ext, fill = NA, color = "black", size = 0.2) +
  
  coord_sf(
    xlim = c(-127, -65),
    ylim = c(10, 50),
    crs = 4326,
    expand = FALSE
  ) +
  
  # Control axis and legend labels 
  labs(
    x = "Longitude",
    y = "Latitude",
    fill = "P(suitability)"
  ) +
  # Create title for the legend
  theme(legend.position = "right") +
  # Add scale bar to bottom-right of map
  ggspatial::annotation_scale(
    location = "bl",          # 'bl' = bottom left
    style = "ticks",
    width_hint = 0.2
  ) +
  # Add north arrow
  ggspatial::annotation_north_arrow(
    location = "bl",
    which_north = "true",
    pad_x = unit(0.175, "in"),
    pad_y = unit(0.3, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  # Change appearance of the legend
  guides(
    fill = guide_colorbar(ticks = FALSE)
  ) 

ggsave(filename = paste(dirname(usa_ensembled_2010_raster_path), "/", "2010_ensembled.svg", sep = ""), 
       usa_ensembled_2010, dpi = 400, height = 8, width = 8)
ggsave(filename = paste(dirname(usa_ensembled_2010_raster_path), "/", "2010_ensembled.png", sep = ""), 
       usa_ensembled_2010, dpi = 400, height = 8, width = 8)

############################################
# BINARY MAP
############################################

message("Select the binary .grd file to plot in the popup window")
usa_binary_2010_raster_path = file.choose()

usa_binary_2010_raster  = terra::rast(usa_binary_2010_raster_path )
usa_binary_2010_raster  = raster::mask(usa_binary_2010_raster, usa_ext )

crs(usa_binary_2010_raster ) = "EPSG:4326"

usa_binary_2010 = ggplot() +
  tidyterra::geom_spatraster(data = usa_binary_2010_raster, aes(fill = mean)) +
  
  scale_fill_whitebox_b(
    palette = "gn_yl",
    direction = -1,
    limits = c(0, 1),
    alpha = 0.5,
    #breaks = seq(0, 1, 0.5)
  ) +
  # Add country borders
  geom_sf(data = usa_ext, fill = NA, color = "black", size = 0.2) +
  
  coord_sf(
    xlim = c(-127, -65),
    ylim = c(10, 50),
    crs = 4326,
    expand = FALSE
  ) +
  # Control axis and legend labels 
  labs(
    x = "Longitude",
    y = "Latitude",
    fill = "P(suitability)"
  ) +
  # Create title for the legend
  theme(legend.position = "none") +
  # Add scale bar to bottom-right of map
  ggspatial::annotation_scale(
    location = "bl",          # 'bl' = bottom left
    style = "ticks",
    width_hint = 0.2
  ) +
  # Add north arrow
  ggspatial::annotation_north_arrow(
    location = "bl",
    which_north = "true",
    pad_x = unit(0.175, "in"),
    pad_y = unit(0.3, "in"),
    style = north_arrow_fancy_orienteering
  ) +
  # Change appearance of the legend
  guides(
    fill = guide_colorbar(ticks = FALSE)
  ) 

ggsave(filename = paste(dirname(usa_binary_2010_raster_path), "/", "2010_binary.svg", sep = ""), 
       usa_binary_2010, dpi = 400, height = 8, width = 8)
ggsave(filename = paste(dirname(usa_binary_2010_raster_path), "/", "2010_binary.png", sep = ""), 
       usa_binary_2010, dpi = 400, height = 8, width = 8)
