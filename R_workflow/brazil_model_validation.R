#######################################################
# BRAZIL MODEL VALIDATION
#######################################################

head(species_braz)
pts = terra::vect(species_braz[,2:3])
crs(pts) = "EPSG:4326"

values_at_points <- terra::extract(x = brazil_binary_2010_raster, 
                                   y = pts, 
                                   xy = TRUE,
                                   na.rm = TRUE)

values_at_points = na.omit(values_at_points)

brazil_binary_2010 +
  geom_point(data = values_at_points, aes(x = x, y = y, colour = mean), size = 1, shape = 19 ) +
  scale_color_gradient(low = "red", high = "black") 

brazil_ensembled_2010 +
  geom_point(data = values_at_points, aes(x = x, y = y, colour = mean), size = 1, shape = 19 ) +
  scale_color_gradient(low = "red", high = "black") +
  guides(color = "none")


# Extract MaxEnt suitability scores at each GPS point
brazil_clim_pred_gps <- 
  terra::extract(
    x = brazil_ensembled_2010_raster,
    y = pts,
    xy = TRUE,
    na.rm = TRUE
  ) %>%
  # Clean df
  dplyr::select(
    lat = y,
    lon = x,
    suit_score = 2 # assign the name of the second column ("median") to "suit_score"
  ) %>%
  tidyr::drop_na(suit_score) %>%
  dplyr::mutate(pres = 1)
head(brazil_clim_pred_gps)

##############################################################
# Extract MaxEnt scores at background points in Brazil range
##############################################################

# Coerce GPS records into SPDF
brazil_recordsSpatialInv <- sp::SpatialPointsDataFrame(
  coords = cbind(species_braz$lon, species_braz$lat),
  data = species_braz,
  proj4string = CRS(
    '+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0'
  )
)

crs(pts) == crs(brazil_ensembled_2010_raster)

# Select KG ecoregions in which there is at least one GPS record
brazil_ecoContainInv <- kg_layer[brazil_recordsSpatialInv, ]

# Plot regions containing at least one record
#sp::plot(brazil_ecoContainInv)
# sp::plot(kg_layer, 
#          add = TRUE, 
#          col = 'gray70')
# Fill the ecoregions with a khaki colour if they contain at least 1 GPS point
# sp::plot(brazil_ecoContainInv, 
#          add = TRUE, 
#          col = 'khaki')
# Overlay GPS points 
# points(species_braz$lon, 
#        species_braz$lat, 
#        pch = 21, 
#        bg = 'mediumseagreen', 
#        cex = 1)

brazil_ecoContainInv <- sf::st_as_sf(brazil_ecoContainInv)

crs(selected_predictors) = "EPSG:4326"
brazil_ecoContainInv = sf::st_set_crs(brazil_ecoContainInv, "EPSG:4326")
crs(selected_predictors) ==  crs(brazil_ecoContainInv)


brazil_bg_area_inv <- terra::mask(selected_predictors, brazil_ecoContainInv) 

set.seed(2023)

brazil_bg_points_inv <- terra::spatSample(
  x = brazil_bg_area_inv,        # Raster of background area to sample points from 
  size = 1000,        # How many background points do we want?
  method = "random",  # Random points
  replace = FALSE,    # Sample without replacement
  na.rm = TRUE,       # Remove background points that have NA climate data
  as.df = TRUE,       # Return background points as data.frame object
  xy = TRUE           # Return lat/lon values for each background point
  #cells = TRUE       # Return the cell numbers in which the background points fall
) %>%
  # Rename lon and lat columns to be consistent with GPS data for focal species 
  dplyr::rename(
    lon = x,
    lat = y
  )

# Convert GPS coords to a 'terra' SpatialVector 
brazil_bgptsInv <- terra::vect(brazil_bg_points_inv)

# Set CRS for GPS coords 
crs(brazil_bgptsInv) <- "EPSG:4326"

# Extract MaxEnt suitability scores at each background GPS point
brazil_bg_clim_predInv <- 
  terra::extract(
    x = brazil_ensembled_2010_raster,
    y = brazil_bgptsInv,
    xy = TRUE,
    na.rm = TRUE
  ) %>%
  # Clean df
  dplyr::select(
    lat = y,
    lon = x,
    suit_score = 2
  ) %>%
  tidyr::drop_na(suit_score) %>%
  dplyr::mutate(pres = 0)
head(brazil_bg_clim_predInv)

##############################################################
# Combine background and GPS points for occurrences  
##############################################################

# Combine dataframes 
brazil_clim_data <- 
  dplyr::bind_rows(
    brazil_clim_pred_gps,
    brazil_bg_clim_predInv
  )

##############################################################
# Fit statistical model  
##############################################################

# Run a simple binomial GLM
# Does the MaxEnt suitability score significantly affect the presence of the psyllid?
# This compares the suitability scores at the locations where the psyillid was recorded, to
# background points where it shouldn't occur

brazil_mod1 <- glm(
  # Response variable
  pres ~ 
    # Fixed effects 
    suit_score, 
  data = brazil_clim_data,
  family = binomial(link = "logit")
)
summary(brazil_mod1)

# Check model diagnostics 
DHARMa::simulateResiduals(fittedModel = brazil_mod1, plot = TRUE)

# Test parameter significance 
car::Anova(
  brazil_mod1, 
  test = "LR",
  type = "II"
)


##############################################################
# Plot statistical model  
##############################################################

# Extract model predictions 
brazil_preds <- ggeffects::ggpredict(
  brazil_mod1, 
  terms = c("suit_score [0:1 by = 0.01]")) %>%
  as.data.frame() %>%
  dplyr::rename(
    suit_score = x
  )
head(brazil_preds)

clim_data_presences = dplyr::filter(brazil_clim_data, pres == 1)
clim_data_absences = dplyr::filter(brazil_clim_data, pres == 0)

# Plot model predictions 
brazil_preds %>%
  ggplot2::ggplot(data = ., 
                  aes(x = suit_score,
                      y = predicted)) +
  geom_rug(data = clim_data_presences, aes(x= suit_score, y = pres), sides = "t") + 
  geom_rug(data = clim_data_absences, aes(x= suit_score, y = pres), sides = "b") +
  geom_line() +
  geom_ribbon(aes(ymin = conf.low,
                  ymax = conf.high),
              alpha = 0.1) +
  labs(
    x = "MaxEnt suitability score",
    y = "Probability of establishment"
  )

##############################################################
# Calculate model accuracy metrics 
##############################################################

# Use model to predict probability of default
predicted <- predict(
  brazil_mod1, 
  brazil_clim_data, 
  type = "response"
) 
head(predicted)

# Find optimal cutoff probability to use to maximize accuracy
optimal <- InformationValue::optimalCutoff(
  brazil_clim_data$pres, 
  #optimiseFor = "Ones",
  predicted)[1]
optimal

# Create confusion matrix
caret::confusionMatrix(
  data = as.factor(as.numeric(predicted>0.5)),
  reference = as.factor(brazil_clim_data$pres),
  positive = "1"
)

# Calculate sensitivity
# - Percentage of true positives 
InformationValue::sensitivity(
  actuals = as.factor(brazil_clim_data$pres),
  predicted = predicted, 
  threshold = optimal
)

# Calculate specificity
# - Percentage of true negatives
InformationValue::specificity(
  actuals = as.factor(brazil_clim_data$pres),
  predicted = predicted, 
  threshold = optimal
)

# Calculate total misclassification error rate
InformationValue::misClassError(
  actuals = as.factor(brazil_clim_data$pres),
  predicted = predicted, 
  threshold = optimal
)
