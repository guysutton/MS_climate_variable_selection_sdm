#######################################################
# MULTICOLLINEARITY
#######################################################

# We start with two sets of predictors: 
# (1) All 19
# (2) A-priori predictors: 1, 5, 6, 10, 11, 12, 13, 14, 18, and 19

# Extract climate values at focal taxon GPS points
# Focal taxon points are stored in `species_native`
head(species_native)

# Let's store just the lon and lat columns from our GPS dataset
sp_gps <- species_native %>%
  dplyr::select(lon, lat)

head(sp_gps)

###############################################################
# Start with all 19 predictors
###############################################################

# Extract climate data at these points 
clim_sp <- terra::extract(
  x = predictors,          # SpatRast containing all 19 WORLDCLIM layers
  y = sp_gps               # SpatVect or data.frame containing GPS of study taxon (lon, lat)
)

clim_sp = dplyr::select(clim_sp, !ID)
head(clim_sp)

######################################################
# All 19 reduced by R-squared
# Using the correlation wheel approach
######################################################

source("correlation_wheel.R")

corrWheel(clim_sp, 0.7)# Specify the R2 value we want as our lowest limit here

print("Reduced predictors from all 19 are 1, 2, 3, 10, 12, and 14")


######################################################
# All 19 reduced by VIF
######################################################

# Identify collinear variables that should be excluded (VIF > 5)
# VIF of 5 might be best
usdm::vifstep(clim_sp, th = 5)

######################################################
# All 19 reduced by R-squared, then VIF
######################################################

reduced_preds_all19r2 = terra::subset(x = predictors, 
                                      subset = predictor_sets$all_19_reduced_r2 )

clim_sp_reduced <- terra::extract(
  x = reduced_preds_all19r2,         
  y = sp_gps              
)

clim_sp_reduced = dplyr::select(clim_sp_reduced, !ID)

#############
# Run VIF
#############

usdm::vifstep(clim_sp_reduced, th = 5)

########################################################################################
# All 19 reduced by PCMV, then R-squared:
########################################################################################
# Use Wang et al's predictors after reducing by PCMV (percentage contribution to model
# variance). These were: 4 5 6 10 11 14 15 16 18
# Now we use the correlation wheel method with R-squared at 0.7 to reduce these
########################################################################################

reduced_preds_all19pcmv = terra::subset(x = predictors, 
                                      subset = predictor_sets$wang )

clim_sp_reduced_wang <- terra::extract(
  x = reduced_preds_all19pcmv,         
  y = sp_gps              
)

clim_sp_reduced_wang = dplyr::select(clim_sp_reduced_wang, !ID)

###############################
# Run correlation wheel
###############################

corrWheel(clim_sp_reduced_wang, 0.7)

print("Reduced predictors from all-19 reduced by PCMV then R-squared are 5, 6, 14, and 18")


###############################################################
# Now let's do the a-priori predictors
###############################################################

a_priori_preds = terra::subset(x = predictors, 
                               subset = predictor_sets$a_priori_all )

clim_sp_a_priori <- terra::extract(
  x = a_priori_preds,         
  y = sp_gps              
)

clim_sp_a_priori = dplyr::select(clim_sp_a_priori, !ID)

###############################################
# R-squared method, using the correlation wheel
################################################

corrWheel(clim_sp_a_priori, 0.7)

print("Reduced predictors from the a-priori set are 1, 5, 12, and 14")

###############################################
# VIF method
################################################

usdm::vifstep(clim_sp_a_priori, th = 5)

###############################################
# PCMV > 1%, then R-squared > 0.7
################################################

a_priori_preds_pcmv = terra::subset(x = predictors, 
                               subset = c(#"wc2.1_2.5m_bio_5",
                                          "wc2.1_2.5m_bio_6",
                                          "wc2.1_2.5m_bio_10",
                                          "wc2.1_2.5m_bio_11",
                                          "wc2.1_2.5m_bio_14",
                                          "wc2.1_2.5m_bio_18",
                                          "wc2.1_2.5m_bio_19"
                                          ) )

clim_sp_a_priori_pcmv <- terra::extract(
  x = a_priori_preds_pcmv,         
  y = sp_gps              
)

clim_sp_a_priori_pcmv = dplyr::select(clim_sp_a_priori_pcmv, !ID)

corrWheel(clim_sp_a_priori_pcmv, 0.7)

print("Reduced predictors from the a-priori set after PCMV and then R-squared are 6, 10, 14, and 18")

