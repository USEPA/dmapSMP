# can only contain the angles 0, 45, 135, 180, 225, 270, 315. Values can be
# removed, but new values cannot be added

star_sample_angles <- c(0, 45, 90, 135, 180, 225, 270, 315)

star_sample_distances <- c(3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39)

#as of this version, it is assumed your input shapefile contains a field
#containing the NHDPlus ID number. This field needs to be called NDHPlusIDt and 
#contain text, not a double. 

input_lines <- "data/TestInput.shp"

veg_cover <- NA

veg_height <- NA