if(!"covsel" %in% installed.packages()) devtools::install_github("N-SDM/covsel")
library(covsel)

###################################################
# COVSEL ON ACP DATA
###################################################

# all-19
predictors

# a-priori
a_priori_preds

###################################################
# first let's get the presence points
###################################################

##############
# all_19
##############
speciesEnv_all_19 <- base::data.frame(
  raster::extract(predictors, cbind(species_native$lon, species_native$lat) )
)

speciesWd_all_19 = cbind(species_native, speciesEnv_all_19)

# Process data 
speciesWd_all_19 <- as.data.frame(speciesWd_all_19) %>%
  # Keep only the lat/lon columns and key environmental variables
  dplyr::select(
    decimalLatitude = lat,
    decimalLongitude = lon,
    predictor_sets$all_19_all
  ) %>%
  dplyr::mutate(species = "Diaphorina_citri") %>%
  dplyr::select(
    species,
    everything()
  ) %>%
  # Drop rows with NA 
  tidyr::drop_na()

# Reproject CRS 
coordinates(speciesWd_all_19) <-  ~ decimalLongitude + decimalLatitude
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(speciesWd_all_19, "proj4string") <- crs_wgs84

presence_points_all_19 = as.data.frame(speciesWd_all_19)

##############
# a_priori
##############
speciesEnv_a_priori <- base::data.frame(
  raster::extract(a_priori_preds, cbind(species_native$lon, species_native$lat) )
)

speciesWd_a_priori = cbind(species_native, speciesEnv_a_priori)

# Process data 
speciesWd_a_priori <- as.data.frame(speciesWd_a_priori) %>%
  # Keep only the lat/lon columns and key environmental variables
  dplyr::select(
    decimalLatitude = lat,
    decimalLongitude = lon,
    predictor_sets$a_priori_all
  ) %>%
  dplyr::mutate(species = "Diaphorina_citri") %>%
  dplyr::select(
    species,
    everything()
  ) %>%
  # Drop rows with NA 
  tidyr::drop_na()

# Reproject CRS 
coordinates(speciesWd_a_priori) <-  ~ decimalLongitude + decimalLatitude
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(speciesWd_a_priori, "proj4string") <- crs_wgs84

presence_points_a_priori = as.data.frame(speciesWd_a_priori)

###################################################
# now let's get the background points
###################################################

##############
# all_19
##############

bg_all_19 = as.data.frame(bg_points) %>%
  # Keep only the lat/lon columns and key environmental variables
  dplyr::select(
    decimalLatitude = lat,
    decimalLongitude = lon,
    predictor_sets$all_19_all
  ) %>%
  dplyr::mutate(species = "Diaphorina_citri") %>%
  dplyr::select(
    species,
    everything()
  ) %>%
  # Drop rows with NA 
  tidyr::drop_na()

# Reproject CRS 
coordinates(bg_all_19) <-  ~ decimalLongitude + decimalLatitude
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(bg_all_19, "proj4string") <- crs_wgs84

background_points_all_19 = as.data.frame(bg_all_19)

##############
# a_priori
##############

bg_a_priori = as.data.frame(bg_points) %>%
  # Keep only the lat/lon columns and key environmental variables
  dplyr::select(
    decimalLatitude = lat,
    decimalLongitude = lon,
    predictor_sets$a_priori_all
  ) %>%
  dplyr::mutate(species = "Diaphorina_citri") %>%
  dplyr::select(
    species,
    everything()
  ) %>%
  # Drop rows with NA 
  tidyr::drop_na()

# Reproject CRS 
coordinates(bg_a_priori) <-  ~ decimalLongitude + decimalLatitude
crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
slot(bg_a_priori, "proj4string") <- crs_wgs84

background_points_a_priori = as.data.frame(bg_a_priori)

###################################################
# RUN COVSEL
###################################################

###################################################
# USING ALL 19 PREDICTORS TO START WITH
###################################################

presence_points_all_19$presence = 1
background_points_all_19$presence = 0

acp_data = rbind(presence_points_all_19, background_points_all_19)
acp_data = janitor::clean_names(acp_data)
acp_pa = acp_data$presence
acp_data_new = acp_data %>% dplyr::select(-species, -decimal_latitude, -decimal_longitude, -presence) 

acp_filtered = covsel.filteralgo(covdata=acp_data_new,
                                 pa=acp_pa,
                                 corcut=0.7) # default value

covdata_embed<-covsel::covsel.embed(covdata=acp_filtered,
                                    pa=acp_pa,
                                    algorithms=c('glm','gam','rf'), # default value
                                    ncov=ceiling(log2(length(which(acp_pa==1)))), # default value
                                    maxncov=12, # default value
                                    nthreads=detectCores()/2 # default value
                                    )  

covdata_embed$ranks_2
covdata_embed$ranks_1

###################################################
# USING A-PRIORI PREDICTORS TO START WITH
###################################################

###################################################
# USING ALL 19 PREDICTORS TO START WITH
###################################################

presence_points_a_priori$presence = 1
background_points_a_priori$presence = 0

acp_data = rbind(presence_points_a_priori, background_points_a_priori)
acp_data = janitor::clean_names(acp_data)
acp_pa = acp_data$presence
acp_data_new = acp_data %>% dplyr::select(-species, -decimal_latitude, -decimal_longitude, -presence) 

acp_filtered = covsel.filteralgo(covdata=acp_data_new,
                                 pa=acp_pa,
                                 corcut=0.7) # default value

covdata_embed<-covsel::covsel.embed(covdata=acp_filtered,
                                    pa=acp_pa,
                                    algorithms=c('glm','gam','rf'), # default value
                                    ncov=ceiling(log2(length(which(acp_pa==1)))), # default value
                                    maxncov=12, # default value
                                    nthreads=detectCores()/2 # default value
)  

covdata_embed$ranks_2
covdata_embed$ranks_1

