#######################################################
# FUTURE CLIMATE DATA -> DOWNLOAD
#######################################################

crs_wgs84 <- sp::CRS(SRS_string = "EPSG:4326")

# DOWNLOAD FUTURE CLIMATE DATA FOR 2050 and 2070 -> both the RCP4.5 and RCP8.5 PROJECTIONS

# RCP4.5 - 2050

# Download the RCP4.5 layers for 2050 to PC, or read them in from a folder
# Env2050_4.5 <- raster::getData(
#   name = 'CMIP5', 
#   # Which raster layers should be downloaded? bio = all 19 WORLDCLIM layers
#   var = 'bio', 
#   # Resolution of the raster layers (2.5 arc minutes)
#   res = 2.5, 
#   # Which RCP model? (here we are downloading the ssp245 or rcp4.5 scenario)
#   rcp = 45, 
#   # Which climate model do we want?
#   model = 'MR', 
#   # Specify the year? (here we download the 2050 data)
#   year = 50,
#   # If the files are not locally available, it will download them for us
#   # Set to download = TRUE, the first time you run the code to download the 
#   # files to your PC
#   download = TRUE,
#   # Set the file path to the folder where the raster layers should be 
#   # stored and/or loaded from if already downloaded 
#   path = here::here("data/environmental_layers/2050/RCP4.5/") # create these folders manually in Documents first
# )

# if already downloaded, read in here:
Env2050_4.5 <- terra::rast( list.files(
  here::here("data/environmental_layers/2050/RCP4.5/cmip5/2_5m") ,
  full.names = TRUE,
  pattern = '.tif'
))
Env2050_4.5 = raster::brick(Env2050_4.5)

# don't run this if the rasters have already been downloaded
# reorder the bio names, as they're ordered 1, 10, 11, 12, 13 instead of 1,2,3 etc.
# numerical_part = as.numeric(gsub('.*_', '', names(predictors)))
# predictor_names_ordered = names(predictors)[order(numerical_part)] ;predictor_names_ordered

# BE SUPER CAREFUL ABOUT ASSIGNING THE NEW NAMES, AS THEY CAN BE IN THE WRONG ORDER!!
# Make the names of the layers consistent with the current climate layers
# names(predictors)
# names(Env2050_4.5)
# names(Env2050_4.5) <- predictor_names_ordered
# names(Env2050_4.5)

# Set the CRS projection for the future climate layers 
# - Use the correct wkt CRS format - no more PROJ4
crs(Env2050_4.5) <- crs_wgs84

# note that the downloaded file names are "mr45bi501" to "mr45bi519". We want these to be the
# same as the names "wc2.1_2.5m_bio_1". Here's a function to change the names of the files
# in the folder

# folder <- "data/environmental_layers/2050/RCP4.5/cmip5/2_5m"
# files <- list.files(folder); files
# start at position 2, because the first file is a zip folder
# for (i in 2:length(files)) {
#   old_file <- file.path(folder, files[i])
#   new_file <- file.path(folder, paste0(names(predictors)[i-1], ".tif"))
#   file.rename(old_file, new_file)
# }


# RCP4.5 - 2070

# Download the RCP4.5 layers for 2070 to PC
# Env2070_4.5 <- raster::getData(
#   name = 'CMIP5', 
#   # Which raster layers should be downloaded? bio = all 19 WORLDCLIM layers
#   var = 'bio', 
#   # Resolution of the raster layers (2.5 arc minutes)
#   res = 2.5, 
#   # Which RCP model? (here we are downloading the ssp245 or rcp4.5 scenario)
#   rcp = 45, 
#   # Which climate model do we want?
#   model = 'MR', 
#   # Specify the year? (here we download the 2070 data)
#   year = 70,
#   # If the files are not locally available, it will download them for us
#   # Set to download = TRUE, the first time you run the code to download the 
#   # files to your PC
#   download = TRUE,
#   # Set the file path to the folder where the raster layers should be 
#   # stored and/or loaded from if already downloaded 
#   path = here::here("data/environmental_layers/2070/RCP4.5/")
# )

# if already downloaded, read in here:
Env2070_4.5 <- terra::rast( list.files(
  here::here("data/environmental_layers/2070/RCP4.5/cmip5/2_5m") ,
  full.names = TRUE,
  pattern = '.tif'
))

Env2070_4.5 = raster::brick(Env2070_4.5)

# Make the names of the layers consistent with the current climate layers
# names(predictors)
# names(Env2070_4.5)
# names(Env2070_4.5) <- predictor_names_ordered
# names(Env2070_4.5)

# Set the CRS projection for the future climate layers 
# - Use the correct wkt CRS format - no more PROJ4
crs(Env2070_4.5) <- crs_wgs84

Env4.5 <- list(Env2050_4.5, Env2070_4.5); Env4.5

# note that the downloaded file names are "mr45bi501" to "mr45bi519". We want these to be the
# same as the names "wc2.1_2.5m_bio_1". Here's a function to change the names of the files
# in the folder

# folder <- "data/environmental_layers/2070/RCP4.5/cmip5/2_5m"
# files <- list.files(folder); files

# start at position 2, because the first file is a zip folder
# for (i in 2:length(files)) {
#   old_file <- file.path(folder, files[i])
#   new_file <- file.path(folder, paste0(names(predictors)[i-1], ".tif"))
#   file.rename(old_file, new_file)
# }


# RCP8.5 - 2050

# Download the RCP4.5 layers for 2050 to PC
# Env2050_8.5 <- raster::getData(
#   name = 'CMIP5', 
#   # Which raster layers should be downloaded? bio = all 19 WORLDCLIM layers
#   var = 'bio', 
#   # Resolution of the raster layers (2.5 arc minutes)
#   res = 2.5, 
#   # Which RCP model? (here we are downloading the ssp245 or rcp4.5 scenario)
#   rcp = 85, 
#   # Which climate model do we want?
#   model = 'MR', 
#   # Specify the year? (here we download the 2050 data)
#   year = 50,
#   # If the files are not locally available, it will download them for us
#   # Set to download = TRUE, the first time you run the code to download the 
#   # files to your PC
#   download = TRUE,
#   # Set the file path to the folder where the raster layers should be 
#   # stored and/or loaded from if already downloaded 
#   path = here::here("data/environmental_layers/2050/RCP8.5/")
# )

# if already downloaded, read in here:
Env2050_8.5 <- terra::rast( list.files(
  here::here("data/environmental_layers/2050/RCP8.5/cmip5/2_5m") ,
  full.names = TRUE,
  pattern = '.tif'
))

Env2050_8.5 = raster::brick(Env2050_8.5)

# Make the names of the layers consistent with the current climate layers
# names(predictors)
# names(Env2050_8.5)
# names(Env2050_8.5) <- predictor_names_ordered
# names(Env2050_8.5)

# Set the CRS projection for the future climate layers 
# - Use the correct wkt CRS format - no more PROJ4
crs(Env2050_8.5) <- crs_wgs84

# note that the downloaded file names are "mr45bi501" to "mr45bi519". We want these to be the
# same as the names "wc2.1_2.5m_bio_1". Here's a function to change the names of the files
# in the folder

# folder <- "data/environmental_layers/2050/RCP8.5/cmip5/2_5m"
# files <- list.files(folder); files
# # start at position 2, because the first file is a zip folder
# for (i in 2:length(files)) {
#   old_file <- file.path(folder, files[i])
#   new_file <- file.path(folder, paste0(names(predictors)[i-1], ".tif"))
#   file.rename(old_file, new_file)
# }


# RCP8.5 - 2070

# Download the RCP4.5 layers for 2050 to PC
# Env2070_8.5 <- raster::getData(
#   name = 'CMIP5', 
#   # Which raster layers should be downloaded? bio = all 19 WORLDCLIM layers
#   var = 'bio', 
#   # Resolution of the raster layers (2.5 arc minutes)
#   res = 2.5, 
#   # Which RCP model? (here we are downloading the ssp245 or rcp4.5 scenario)
#   rcp = 85, 
#   # Which climate model do we want?
#   model = 'MR', 
#   # Specify the year? (here we download the 2050 data)
#   year = 70,
#   # If the files are not locally available, it will download them for us
#   # Set to download = TRUE, the first time you run the code to download the 
#   # files to your PC
#   download = TRUE,
#   # Set the file path to the folder where the raster layers should be 
#   # stored and/or loaded from if already downloaded 
#   path = here::here("data/environmental_layers/2070/RCP8.5/")
# )

# if already downloaded, read in here:
Env2070_8.5 <- terra::rast( list.files(
  here::here("data/environmental_layers/2070/RCP8.5/cmip5/2_5m") ,
  full.names = TRUE,
  pattern = '.tif'
))

Env2070_8.5 = raster::brick(Env2070_8.5)

# Make the names of the layers consistent with the current climate layers
# names(predictors)
# names(Env2070_8.5)
# names(Env2070_8.5) <- predictor_names_ordered
# names(Env2070_8.5)

# Set the CRS projection for the future climate layers 
# - Use the correct wkt CRS format - no more PROJ4
crs(Env2070_8.5) <- crs_wgs84

Env8.5 <- list(Env2050_8.5, Env2070_8.5) ;Env8.5

# note that the downloaded file names are "mr45bi501" to "mr45bi519". We want these to be the
# same as the names "wc2.1_2.5m_bio_1". Here's a function to change the names of the files
# in the folder

# folder <- "data/environmental_layers/2070/RCP8.5/cmip5/2_5m"
# files <- list.files(folder); files
# # start at position 2, because the first file is a zip folder
# for (i in 2:length(files)) {
#   old_file <- file.path(folder, files[i])
#   new_file <- file.path(folder, paste0(names(predictors)[i-1], ".tif"))
#   file.rename(old_file, new_file)
# }