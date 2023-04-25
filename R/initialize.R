message("Loading Required Packages")
suppressPackageStartupMessages(library(sf, quietly = TRUE))
suppressPackageStartupMessages(library(sp, quietly = TRUE))
suppressPackageStartupMessages(library(terra, quietly = TRUE))
suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(readxl, quietly = TRUE))
suppressPackageStartupMessages(library(parallel, quietly = TRUE))

message("\nInstalling Missing Packages")

check_install_status <- require(nhdplusTools, quietly = TRUE)


if (check_install_status == FALSE){
  install.packages("nhdplusTools", quiet = TRUE)
}

suppressPackageStartupMessages(library(nhdplusTools, quietly = TRUE))

check_install_status <- require(reticulate, quietly = TRUE)

if (check_install_status == FALSE){
  install.packages("reticulate", quiet = TRUE)
}

suppressPackageStartupMessages(library(reticulate, quietly = TRUE))

remove(check_install_status)

options(timeout = 1200)
options(warn = -1)
options(scipen = 999)



system("chmod a+x ./shell/get_data.sh")
system("chmod a+x ./shell/get_ha.sh")
system("chmod a+x ./shell/get_dem.sh")


message("Downloading Required Files")
system("./shell/get_data.sh")


ifelse(external_veg_cover == FALSE, veg_cover <- rast("data/Vegetation/LC22_ECH_220_reclass.tif"), veg_cover <- rast(external_veg_cover))
ifelse(external_veg_height == FALSE, veg_height <- rast("data/Vegetation/LC22_EVH_220_reclass.tif"), veg_height <- rast(external_veg_height))

rpu_boundaries <- st_read("data/RPU/RPU_Boundary.shp", quiet = TRUE) %>%
  st_transform(5070)

huc4_boundaries <- st_read("data/HUC4/HUC4_Boundary.shp", quiet = TRUE)

hlr <- st_read("data/HLR/HLR.shp", quiet = TRUE) %>%
  st_transform(5070)

message("Initialization Complete")