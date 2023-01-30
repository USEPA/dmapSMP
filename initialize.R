library(sf)
library(sp)
library(terra)
library(tidyverse)
library(readxl)


check_install_status <- require(nhdplusTools)


if (check_install_status == FALSE){
  install.packages("nhdplusTools")
  library(nhdplusTools)
}

check_install_status <- require(reticulate)

if (check_install_status == FALSE){
  install.packages("reticulate")
  library(reticulate)
}

remove(check_install_status)

options(timeout = 300)
options(warn = -1)


system("chmod a+x ./get_data.sh")
system("chmod a+x ./get_ha.sh")
system("chmod a+x ./get_dem.sh")

system("./get_data.sh")


ifelse(personal_veg_cover == FALSE, veg_cover <- rast("data/Vegetation/LC22_ECH_220_reclass.tif"), veg_cover <- rast(personal_veg_cover))
ifelse(personal_veg_height == FALSE, veg_height <- rast("data/Vegetation/LC22_EVH_220_reclass.tif"), veg_height <- rast(personal_veg_height))

rpu_boundaries <- st_read("data/RPU/RPU_Boundary.shp", quiet = TRUE) %>%
  st_transform(5070)

huc4_boundaries <- st_read("data/HUC4/HUC4_Boundary.shp", quiet = TRUE)

hlr <- st_read("data/HLR/HLR.shp", quiet = TRUE) %>%
  st_transform(5070)