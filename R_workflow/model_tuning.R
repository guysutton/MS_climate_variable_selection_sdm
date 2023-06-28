#######################################################
# MODEL TUNING
#######################################################

# We need a data.frame of the lon and lat (in that order) for our background points 
# you can pick any background_points object, because they all have the exact same set of GPS coordinates,
# the only difference is the differing sets of column predictors

##########################################################
# Get the user to choose the predictor set of interest
# for model tuning. Writing a loop to go through all of these
# will take much too long
##########################################################

option_indices <- seq_along(predictor_spatrasters)

# Display the options to the user
cat("Choose an option:\n")
for (i in option_indices) {
  cat(i, "-", names(predictor_spatrasters[i]), "\n")
}

# Prompt the user for the option number
user_choice <- readline("Enter the number of your choice: ")

# Retrieve the selected option
selected_option <- predictor_spatrasters[[as.integer(user_choice)]]

##########################################################


bg_pts <- background_points_all_19 %>%
  dplyr::select(
    lon = decimalLongitude , 
    lat = decimalLatitude
  )

head(bg_pts)
head(sp_gps)

# We need a list of the feature class (fc) and regularisation multipliers (rm) to test
list_settings <- list(
  fc = c("L","Q","H","LQH"), 
  rm = c(1,2,4,6,8)
)

# Run model tuning experiments 

# Set reproducible seed
set.seed(2023)

# Start the MaxEnt java application (after pushing system memory up)
memory.limit()
memory.limit(size=20000000000)
options(java.parameters = "- Xmx2024m")

dismo::maxent()

# Run model tuning 
# this can take a long time to run!
# with 16GB RAM, all 19 predictors now take about 191 mins

print("RUNNING MODEL TUNING NOW")

tuning_results <- 
  ENMeval::ENMevaluate(
    occs = sp_gps,
    envs = selected_option, # this is what you change in each run, needs to be a spatraster
    bg = bg_pts,
    tune.args = list_settings, 
    partitions = "block",
    algorithm = "maxent.jar",
    doClamp = FALSE
  )

# Visualise results 

# Plot the model tuning results

ENMeval::evalplot.stats(
  e = tuning_results,              # Variable containing ENMevaluate results 
  stats = c(                       # Which metrics to plot?
    "auc.val",                     # - Make a plot for AUC
    "or.mtp",                      # - Make a plot for omission rate (minimum training presence)
    "or.10p"                       # - Make a plot for omission rate (10th percentile)
  ),   
  color = "fc",                    # Colours lines/bars by feature class (fc)
  x.var = "rm",                    # Variable to plot on x-axis
  error.bars = FALSE               # Don't show error bars 
)


# Select the optimal model settings 

# Extract the model tuning results to a data.frame 

res <- ENMeval::eval.results(tuning_results)
head(res)

# Select the model settings (RM and FC) that optimised AICc (delta AICc == 0)
best_model_settings <- res %>% 
  dplyr::filter(delta.AICc == 0)

# switch rows and columns around so that the results are easier to read
best_model_settings_output = t(best_model_settings)
colnames(best_model_settings_output) = "results"

best_model_settings_output 

# write the results to a text file

best_model_directory = choose.dir(caption = "Select the folder to which to save the best model as a text file")
best_model_path = paste(best_model_directory, "/best_model.txt", sep = "")

write.table(best_model_settings_output,
            best_model_path,
            quote = FALSE)

# Evaluate the best model  

# Let's evaluate the best model 
mod_best <- ENMeval::eval.models(tuning_results)[[best_model_settings$tune.args]]

# Plot the marginal response curves for the predictor variables wit non-zero 
# coefficients in our model. We define the y-axis to be the cloglog transformation, which
# is an approximation of occurrence probability (with assumptions) bounded by 0 and 1
# (Phillips et al. 2017).

par(bg = "#FFFFFF")

png(paste(best_model_directory, "/dismo_plots.png", sep = ""))
dismo_plots = dismo::response(ENMeval::eval.models(tuning_results)[[best_model_settings$tune.args]])
dev.off()

# You interpret these graphs to see if the relationship between your study species being 
# present at a site correlates with the environmental variables, and whether the shape of 
# the relationship makes sense for the species

# For example, if we consider bio12 (mean annual precipitation),
# - We can see that there is a relatively weak effect on our study species, with the species 
#   less likely to be recorded with increasing mean annual precipitation

# Another example, if we consider bio15 (coefficient of variation in seasonality precipitation),
# or how variable precipitation is between seasons,
# - We can see that the suitability for the species is very high when rainfall is not very variable 
#   between seasons (x-axis between 0 and 40), and as the variation in rainfall between seasons
#   increases (larger x-axis values), the suitability for our study species decreases.
#   - This would imply that our study species likes consistent rainfall (or a lack of rainfall) 
#     throughout the year
