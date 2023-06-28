##################
# PRESENCE POINTS
##################

names(predictor_spatrasters)

for(p in 1:length(predictor_spatrasters) ){
  
  speciesEnv <- base::data.frame(
    raster::extract(predictor_spatrasters[[p]], cbind(species_native$lon, species_native$lat) )
  )
  
  speciesWd = cbind(species_native, speciesEnv)
  
  # Process data 
  speciesWd <- as.data.frame(speciesWd) %>%
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
  coordinates(speciesWd) <-  ~ decimalLongitude + decimalLatitude
  crs_wgs84 <- CRS(SRS_string = "EPSG:4326")
  slot(speciesWd, "proj4string") <- crs_wgs84
  
  output_name = paste("presence_points_", names(predictor_spatrasters[p]), sep = "") 
  assign(output_name, as.data.frame(speciesWd))
  
}#for

# outputs:

presence_points <- list(
  presence_points_wang_preds = presence_points_wang_preds,
  presence_points_aidoo_preds = presence_points_aidoo_preds,
  presence_points_naroui_khandan_preds = presence_points_naroui_khandan_preds,
  presence_points_fordjour_preds = presence_points_fordjour_preds,
  presence_points_all_19_all_preds = presence_points_all_19_all_preds,
  presence_points_all_19_reduced_r2_preds = presence_points_all_19_reduced_r2_preds,
  presence_points_all_19_reduced_VIF_preds = presence_points_all_19_reduced_VIF_preds,
  presence_points_all_19_reduced_r2_VIF_preds = presence_points_all_19_reduced_r2_VIF_preds,
  presence_points_all_19_reduced_pcmv_r2_preds = presence_points_all_19_reduced_pcmv_r2_preds,
  presence_points_a_priori_all_preds = presence_points_a_priori_all_preds,
  presence_points_a_priori_reduced_r2_preds = presence_points_a_priori_reduced_r2_preds,
  presence_points_a_priori_reduced_VIF_preds = presence_points_a_priori_reduced_VIF_preds,
  presence_points_a_priori_reduced_pcmv_r2_preds = presence_points_a_priori_reduced_pcmv_r2_preds,
  presence_points_covsel_glm_preds = presence_points_covsel_glm_preds,
  presence_points_covsel_combined_preds = presence_points_covsel_combined_preds,
  presence_points_covsel_glm_apriori_preds = presence_points_covsel_glm_apriori_preds,
  presence_points_covsel_combined_apriori_preds = presence_points_covsel_combined_apriori_preds
)