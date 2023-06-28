#######################################################
# SPATIAL AUTOCORRELATION
#######################################################

# Setup data to run spatial autocorrelation analysis 

# Extract climate data at focal taxon study points 
# All 19 predictors

gps_climate <- terra::extract(
  x = predictors,          # SpatRast containing reduced WORLDCLIM layers
  y = sp_gps,                # SpatVect or data.frame containing GPS of study taxon (lon, lat) -> native range
  xy = TRUE                  # Return lon and lat columns for each GPS point 
)

head(gps_climate)

# Run spatial autocorrelation analysis 

# At what distance does spatial autocorrelation occur?
# - The x-axis represents meters 
# - The citation for this method:
#   - Legendre, P. and M.J. Fortin. 1989. Spatial pattern and ecological analysis. 
#     Vegetation, 80, 107-138.

# Replace gps_climate with the other predictor sets, and repeat

spatial_corr <- ecospat::ecospat.mantel.correlogram(
  dfvar = gps_climate,       # Data frame with environmental variables
  colxy = 7:8,               # Columns containing lat/long
  n = 500,                   # Number of random occurrences
  colvar = 1:6,              # Columns containing climate variables
  max = 3000,               # Computes autocorrelation up to 30km (30000m)
  nclass = 10,               # How many points to compute correlation at 
  nperm = 100
)