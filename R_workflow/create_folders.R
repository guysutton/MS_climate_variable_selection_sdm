####################################################################################
# RUN THIS ONLY THE FIRST TIME TO CREATE ALL THE RELEVANT FOLDERS AND SUBFOLDERS
####################################################################################

main_folders = c("A_PRIORI", "ALL_19", "COVSEL", "LITERATURE")

a_priori_folder_names = c("a_priori_all_predictors", "a_priori_covsel_combined",
                          "a_priori_covsel_glm", "a_priori_reduced_PCMV_R2",
                          "a_priori_reduced_R2", "a_priori_reduced_VIF")

all_19_folder_names = c("all_19_covsel_combined", "all_19_covsel_glm", "all_19_predictors", "all_19_reduced_PCMV_R2",
                        "all_19_reduced_R2", "all_19_reduced_R2_VIF", "all_19_reduced_VIF")
covsel_folder_names = c("a_priori_covsel", "all_19_covsel")

literature_folder_names = c("aidoo_set", "fordjour_set", "naroui_khandan_set", "wang_set")

subfolder_names = c("africa_env_layers", "Africa_results", "background", "brazil_env_layers", "Brazil_results",
                    "default_maxent_model", "gps", "tuned_maxent_model", "usa_env_layers", "USA_results")

###########
# A_PRIORI
###########

  dir.create(main_folders[1])

  # Create a_priori subfolders within each main folder
  for (a_priori_folder in a_priori_folder_names) {
    dir.create(file.path(main_folders[1], a_priori_folder))

    # Create subfolders within each a_priori subfolder
    for (subfolder in subfolder_names) {
      dir.create(file.path(main_folders[1], a_priori_folder, subfolder))
    }
  }


###########
# ALL_19
###########

  dir.create(main_folders[2])

  for (all_19_folder in all_19_folder_names) {
    dir.create(file.path(main_folders[2], all_19_folder))

    for (subfolder in subfolder_names) {
      dir.create(file.path(main_folders[2], all_19_folder, subfolder))
    }
  }

###########
# COVSEL
###########

dir.create(main_folders[3])

for (covsel_folder in covsel_folder_names) {
  dir.create(file.path(main_folders[3], covsel_folder))

  for (subfolder in subfolder_names) {
    dir.create(file.path(main_folders[3], covsel_folder, subfolder))
  }
}

##############
# LITERATURE
##############

dir.create(main_folders[4])

for (literature_folder in literature_folder_names) {
  dir.create(file.path(main_folders[4], literature_folder))

  for (subfolder in subfolder_names) {
    dir.create(file.path(main_folders[4], literature_folder, subfolder))
  }
}




# A_PRIORI
dir_path <- main_folders[1]
if (!file.exists(dir_path)) {
  dir.create(dir_path)
}

# Create a_priori subfolders within A_PRIORI
for (a_priori_folder in a_priori_folder_names) {
  folder_path <- file.path(dir_path, a_priori_folder)
  if (!file.exists(folder_path)) {
    dir.create(folder_path)
  }
  
  # Create subfolders within each a_priori subfolder
  for (subfolder in subfolder_names) {
    subfolder_path <- file.path(dir_path, a_priori_folder, subfolder)
    if (!file.exists(subfolder_path)) {
      dir.create(subfolder_path)
    }
  }
}

# ALL_19
dir_path <- main_folders[2]
if (!file.exists(dir_path)) {
  dir.create(dir_path)
}

# Create all_19 subfolders within ALL_19
for (all_19_folder in all_19_folder_names) {
  folder_path <- file.path(dir_path, all_19_folder)
  if (!file.exists(folder_path)) {
    dir.create(folder_path)
  }
  
  # Create subfolders within each all_19 subfolder
  for (subfolder in subfolder_names) {
    subfolder_path <- file.path(dir_path, all_19_folder, subfolder)
    if (!file.exists(subfolder_path)) {
      dir.create(subfolder_path)
    }
  }
}

# COVSEL
dir_path <- main_folders[3]
if (!file.exists(dir_path)) {
  dir.create(dir_path)
}

# Create covsel subfolders within COVSEL
for (covsel_folder in covsel_folder_names) {
  folder_path <- file.path(dir_path, covsel_folder)
  if (!file.exists(folder_path)) {
    dir.create(folder_path)
  }
  
  # Create subfolders within each covsel subfolder
  for (subfolder in subfolder_names) {
    subfolder_path <- file.path(dir_path, covsel_folder, subfolder)
    if (!file.exists(subfolder_path)) {
      dir.create(subfolder_path)
    }
  }
}

# LITERATURE
dir_path <- main_folders[4]
if (!file.exists(dir_path)) {
  dir.create(dir_path)
}

# Create literature subfolders within LITERATURE
for (literature_folder in literature_folder_names) {
  folder_path <- file.path(dir_path, literature_folder)
  if (!file.exists(folder_path)) {
    dir.create(folder_path)
  }
  
  # Create subfolders within each literature subfolder
  for (subfolder in subfolder_names) {
    subfolder_path <- file.path(dir_path, literature_folder, subfolder)
    if (!file.exists(subfolder_path)) {
      dir.create(subfolder_path)
    }
  }
}