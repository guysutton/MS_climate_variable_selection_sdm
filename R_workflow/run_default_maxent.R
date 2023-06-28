######################################################################
# RUN DEFAULT MAXENT MODELS
######################################################################

option_indices <- seq_along(predictor_sets)

# Display the options to the user
cat("Choose a set of predictors:\n")
for (i in option_indices) {
  cat(i, "-", names(predictor_sets[i]), "\n")
}

# Prompt the user for the option number
predictor_choice <- readline("Enter the number of your choice: ")

# Retrieve the selected option from the background and presence predictor sets
presList = presence_points[[as.integer(predictor_choice)]]
backList = background_points[[as.integer(predictor_choice)]]

# Choose a directory to save these presence and background points to

presList_choice = readline("Directory to save your presence points (e.g. LITERATURE/wang_set/gps/): ")
backList_choice = readline("Directory to save your background points (e.g. LITERATURE/wang_set/background/): ")
# LITERATURE/wang_set/gps/Diaphorina_citri.csv
# LITERATURE/wang_set/background/Diaphorina_citri.csv

presList_directory = paste(presList_choice, "Diaphorina_citri.csv", sep = "")
backList_directory = paste(backList_choice, "Diaphorina_citri.csv", sep = "")

write.csv(presList, file = presList_directory, quote = FALSE, row.names = FALSE)
write.csv(backList, file = backList_directory, quote = FALSE, row.names = FALSE)

# directory to save to:
model_directory = readline("Directory to save your MaxEnt model (e.g. LITERATURE/wang_set/default_maxent_model/): ")
model_directory_input = model_directory

####################################################################
# Run model 
# - This model is using default MaxEnt settings, not tuned settings 
####################################################################

message("RUNNING DEFAULT MAXENT MODEL NOW")

megaSDM::MaxEntModel(
  occlist = presList_directory,
  bglist = backList_directory,
  model_output = here::here(model_directory_input),
  ncores = 2,
  nrep = 4,
  alloutputs = TRUE
)
