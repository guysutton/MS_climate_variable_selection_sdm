predictors <- terra::rast( list.files(
  here::here("./data/environmental_layers/current/wc2.1_2.5m/") ,
  full.names = TRUE,
  pattern = '.tif'
))

covsel_glm = c("wc2.1_2.5m_bio_1",
               "wc2.1_2.5m_bio_2",
               "wc2.1_2.5m_bio_3",
               "wc2.1_2.5m_bio_17")

covsel_combined = c("wc2.1_2.5m_bio_1",
                    "wc2.1_2.5m_bio_2",
                    "wc2.1_2.5m_bio_3",
                    "wc2.1_2.5m_bio_13",
                    "wc2.1_2.5m_bio_17",
                    "wc2.1_2.5m_bio_18")

covsel_glm_apriori = c("wc2.1_2.5m_bio_1",
                       "wc2.1_2.5m_bio_14")

covsel_combined_apriori = c("wc2.1_2.5m_bio_1",
                            "wc2.1_2.5m_bio_5",
                            "wc2.1_2.5m_bio_13",
                            "wc2.1_2.5m_bio_14",
                            "wc2.1_2.5m_bio_18")

wang = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  "wc2.1_2.5m_bio_4",
  "wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  "wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14",
  "wc2.1_2.5m_bio_15",
  "wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18"
  #"wc2.1_2.5m_bio_19"
)

aidoo = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  "wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  "wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14",
  "wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18",
  "wc2.1_2.5m_bio_19"
)

naroui_khandan = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  "wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  #"wc2.1_2.5m_bio_10",
  "wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  "wc2.1_2.5m_bio_13"
  #"wc2.1_2.5m_bio_14",
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  #"wc2.1_2.5m_bio_18",
  #"wc2.1_2.5m_bio_19"
)

fordjour = c(
  "wc2.1_2.5m_bio_1",
  "wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  "wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  #"wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  #"wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  #"wc2.1_2.5m_bio_14",
  "wc2.1_2.5m_bio_15"
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  #"wc2.1_2.5m_bio_18",
  #"wc2.1_2.5m_bio_19"
)

all_19_all = c(
  "wc2.1_2.5m_bio_1",
  "wc2.1_2.5m_bio_2",
  "wc2.1_2.5m_bio_3",
  "wc2.1_2.5m_bio_4",
  "wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  "wc2.1_2.5m_bio_7",
  "wc2.1_2.5m_bio_8",
  "wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  "wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  "wc2.1_2.5m_bio_13",
  "wc2.1_2.5m_bio_14",
  "wc2.1_2.5m_bio_15",
  "wc2.1_2.5m_bio_16",
  "wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18",
  "wc2.1_2.5m_bio_19"
)

all_19_reduced_r2 = c(
  "wc2.1_2.5m_bio_1",
  "wc2.1_2.5m_bio_2",
  "wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  #"wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14"
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  #"wc2.1_2.5m_bio_18",
  #"wc2.1_2.5m_bio_19"
)

all_19_reduced_VIF = c(
  #"wc2.1_2.5m_bio_1",
  "wc2.1_2.5m_bio_2",
  "wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  #"wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  "wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  #"wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14",
  "wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18",
  "wc2.1_2.5m_bio_19"
)

all_19_reduced_r2_VIF = c(
  #"wc2.1_2.5m_bio_1",
  "wc2.1_2.5m_bio_2",
  "wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  #"wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14"
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  #"wc2.1_2.5m_bio_18",
  #"wc2.1_2.5m_bio_19"
)

all_19_reduced_pcmv_r2 = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  "wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  #"wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14",
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18"
  #"wc2.1_2.5m_bio_19"
)

a_priori_all = c(
  "wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  "wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  "wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  "wc2.1_2.5m_bio_13",
  "wc2.1_2.5m_bio_14",
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18",
  "wc2.1_2.5m_bio_19"
)

a_priori_reduced_r2 = c(
  "wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  "wc2.1_2.5m_bio_5",
  #"wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  #"wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  "wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14"
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  #"wc2.1_2.5m_bio_18",
  #"wc2.1_2.5m_bio_19"
)

a_priori_reduced_VIF = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  "wc2.1_2.5m_bio_13",
  "wc2.1_2.5m_bio_14",
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18",
  "wc2.1_2.5m_bio_19"
)

a_priori_reduced_pcmv_r2 = c(
  #"wc2.1_2.5m_bio_1",
  #"wc2.1_2.5m_bio_2",
  #"wc2.1_2.5m_bio_3",
  #"wc2.1_2.5m_bio_4",
  #"wc2.1_2.5m_bio_5",
  "wc2.1_2.5m_bio_6",
  #"wc2.1_2.5m_bio_7",
  #"wc2.1_2.5m_bio_8",
  #"wc2.1_2.5m_bio_9",
  "wc2.1_2.5m_bio_10",
  #"wc2.1_2.5m_bio_11",
  #"wc2.1_2.5m_bio_12",
  #"wc2.1_2.5m_bio_13"
  "wc2.1_2.5m_bio_14",
  #"wc2.1_2.5m_bio_15",
  #"wc2.1_2.5m_bio_16",
  #"wc2.1_2.5m_bio_17",
  "wc2.1_2.5m_bio_18"
  #"wc2.1_2.5m_bio_19"
)

predictor_sets = list(wang = wang, 
                      aidoo = aidoo, 
                      naroui_khandan =naroui_khandan, 
                      fordjour = fordjour, 
                      all_19_all = all_19_all, 
                      all_19_reduced_r2 = all_19_reduced_r2, 
                      all_19_reduced_VIF = all_19_reduced_VIF, 
                      all_19_reduced_r2_VIF = all_19_reduced_r2_VIF, 
                      all_19_reduced_pcmv_r2 = all_19_reduced_pcmv_r2,
                      a_priori_all = a_priori_all, 
                      a_priori_reduced_r2 = a_priori_reduced_r2, 
                      a_priori_reduced_VIF = a_priori_reduced_VIF, 
                      a_priori_reduced_pcmv_r2 = a_priori_reduced_pcmv_r2,
                      covsel_glm = covsel_glm,
                      covsel_combined = covsel_combined,
                      covsel_glm_apriori = covsel_glm_apriori,
                      covsel_combined_apriori = covsel_combined_apriori)

predictor_sets

# CREATE SPATRASTERS FOR EACH OF THESE PREDICTOR SETS

# Iterate over predictor_sets list and create spatrasters
for (set_name in names(predictor_sets)) {
  subset <- terra::subset(x = predictors, subset = predictor_sets[[set_name]])
  assign(paste0(set_name, "_preds"), subset)
}

# check all the predictor sets

wang_preds
aidoo_preds
naroui_khandan_preds
fordjour_preds
all_19_all_preds
all_19_reduced_r2_preds
all_19_reduced_VIF_preds
all_19_reduced_r2_VIF_preds
all_19_reduced_pcmv_r2_preds
a_priori_all_preds
a_priori_reduced_r2_preds
a_priori_reduced_VIF_preds
a_priori_reduced_pcmv_r2_preds
covsel_glm_preds
covsel_combined_preds
covsel_glm_apriori_preds
covsel_combined_apriori_preds

# Create a list
predictor_spatrasters <- list(
  wang_preds = wang_preds,
  aidoo_preds = aidoo_preds,
  naroui_khandan_preds = naroui_khandan_preds,
  fordjour_preds = fordjour_preds,
  all_19_all_preds = all_19_all_preds,
  all_19_reduced_r2_preds = all_19_reduced_r2_preds,
  all_19_reduced_VIF_preds = all_19_reduced_VIF_preds,
  all_19_reduced_r2_VIF_preds = all_19_reduced_r2_VIF_preds,
  all_19_reduced_pcmv_r2_preds = all_19_reduced_pcmv_r2_preds,
  a_priori_all_preds = a_priori_all_preds,
  a_priori_reduced_r2_preds = a_priori_reduced_r2_preds,
  a_priori_reduced_VIF_preds = a_priori_reduced_VIF_preds,
  a_priori_reduced_pcmv_r2_preds = a_priori_reduced_pcmv_r2_preds,
  covsel_glm_preds = covsel_glm_preds,
  covsel_combined_preds = covsel_combined_preds,
  covsel_glm_apriori_preds = covsel_glm_apriori_preds,
  covsel_combined_apriori_preds = covsel_combined_apriori_preds
)
