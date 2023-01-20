library(sf)
library(sp)
library(terra)
library(tidyverse)


check_install_status <- require(nhdplusTools)


if (check_install_status == FALSE){
  install.packages("nhdplusTools")
  library(nhdplusTools)
}

check_install_status <- require(archive)

if (check_install_status == FALSE){
  install.packages("archive")
  library(archive)
}

remove(check_install_status)

options(timeout=180)

system("chmod a+x ./s3.sh")
system("chmod a+x ./get_data.sh")
system("chmod a+x ./get_ha.sh")
system("./s3.sh")
system("./get_data.sh")

veg_cover <- rast("data/Vegetation/LC22_ECH_220_reclass.tif")
veg_height <- rast("data/Vegetation/LC22_EVH_220_reclass.tif")

rpu_boundaries <- st_read("data/RPU/RPU_Boundary.shp") %>%
  st_transform(5070)

huc4_boundaries <- st_read("data/HUC4/HUC4_Boundary.shp")