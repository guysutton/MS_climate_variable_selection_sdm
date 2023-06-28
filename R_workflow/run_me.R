#############################################################################
# Run this script to run everything in the project
#############################################################################

# load up the climate predictor sets
source("predictor_sets.R")
# automatically create all the folders and sub-folders
source("create_folders.R")
# load all the required packages and plot settings
source("setup.R")
# acquire the necessary input data (climate layers and GPS coordinates)
source("get_data.R")
# extract presence points
source("presence_points.R")
# generate background points
source("background_points.R")
# test for multicollinearity
source("multicollinearity.R")
# run covsel to select predictors
source("covsel.R")
# test for spatial autocorrelation
source("spatial_autocorrelation.R")

# tune the MaxEnt models
source("model_tuning.R")

# edit the get_future_climate_data.R if you need to download the climate data yourself.
# otherwise, the files are provided in the data/ directory in this project
source("get_future_climate_data.R")

#############################################################################
# Re-run everything from here to change the predictor set you want to target
#############################################################################

# generate the default MaxEnt model, trained on the native range
source("run_default_maxent.R")
# generate the tuned MaxEnt model, trained on the native range
source("run_tuned_maxent.R")

# Africa
source("setup_africa_predictions.R")
source("run_africa_predictions.R")
source("africa_model_validation.R")

# Brazil
source("setup_brazil_predictions.R")
source("run_brazil_predictions.R")
source("brazil_model_validation.R")

# USA
source("setup_usa_predictions.R")
source("run_usa_predictions.R")
source("usa_model_validation.R")

