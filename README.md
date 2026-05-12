# dmapSMP

The Shade Model Preprocessing tool is a process that prepares NHDPlus HR flowline datasets for processing in RShade. It does this by taking the spatial data, calculating new columns, and exporting to a csv that can be input directly into RShade. For instructions on how to use this process, please see the shade_model_preprocessing.Rmd included in this repository.

To Run Shade Model Preprocessing in an anote RStudio instance:
- On the menu bar, select "File" -> "New Project"
- Select the "Version Control" option
- Input the url: https://github.com/USEPA/dmapSMP.git
- Select "Create Project"
- In the "Files" window in the bottom right of the screen, open shade_model_preprocessing.Rmd
- Upload your NHDPlus HR linework dataset using the "Upload" button in the "Files" window. 
- Follow the instructions in the .Rmd file, setting your parameters and running the code chunks in order. 
- To run a code chunk, click the green play button in the upper right corner of every grey code chunk. 

- To update the code to the latest version, click the GIT icon below the menu bar (this looks like the word GIT turned 90-degrees). In the Github dropdown, select "Pull Branches. This will bring sync the most up to date version of code with your RStudio instance. 

# Variables created by dmapSMP

site_id - unique identifier for equidistant points created along flowline
NHDPlusID - NHDPlus HR identifier
TotDASqKM - upstream drainage area (km2) from NHDPlus HR VAA table 
bfwidth - bankfull width for site_id
aspect - stream aspect for site_id
topoXX - horizon angle in XX direction (NN, NE, ..., NW) for site_id
lat - latitude for site_id
lon - longitude for site_id
Elevation - elevation for site_id
XXoverhng - overhang for each XX direction. Calculated as a fraction of vegetation height
wwidth - same as bankfull width
disfromcentertolb - half of bankfull width
incision - assumed to be 0
XXhghtVZn - vegetation height on XX radial transect, buffer zone n
XXdensVZn - vegetation density on XX radial transect, buffer zone n

Vegetation parameters are derived from the latest (2016) LANDFIRE dataset available at the
time of program construction.  Users can substitute more recent data if they wish.  

# Default Horizon Angle Grids

To reduce the time and computing power needed to calculate the horizon angle of each sample 
point, horizon angle grids were calculated for the contiguous United States using NHDPlusV2 
NED Snapshot elevation grids. The NED elevation grids were used instead of DEMs associated 
with NHDPlus HR because the latter have been hydrologically altered to enforce watershed 
boundaries and stream channel locations. The tool used to calculate the horizon angle was 
created by Whitebox tools (https://cran.r-project.org/web/packages/whitebox/index.html). 

The following processing steps were used to calculate the horizon angle:
- Multiply raster values by 100 to convert unit of measurement from  centimeters to meters.
- Using the wbt_horizon_angle() function, calculate the horizon angle out to 100 km. This 
process is done for each elevation grid at angles of 0.1, 90, 135, 180, 225, 270, & 315 
degrees. 
- For the resulting grids, set all values below 0 to 0. All values were then rounded to the 
nearest whole number. 

# Vegetation Data

Derived from 2016 Landfire grids, but users can substitute more recent datasets if desired.

# dmapSMP dataset requirements

Although we provide default datasets for use in dmapSMP, in most cases, substitutions can be made
where desired.  Datasets are expected to have the following formats and variables for use in dmapSMP,
and projected in NAD Conus Albers (EPSG:5070):

Flowlines: geodatabase (pref.) or shapefile, best if preprocessed as a network (no line gaps).
The variable NHDPlusIDt (character, unique identifier for individual COMID reaches) is required.
Alternative flowline datasets other than NHDPlus HR can be used as long as they contain a unique
reach identifier that is named NHDPlusIDt (character field).  The code currently retrieves the
NHDPlus HR value-added attributes table and joins it to the data set using the COMID to pull
in upstream watershed area (TotDASqKM).  If an alternative flowline source is used, the user
could provide a table with NHDPlusIDt and TotDASqKM values and use 

NHDPlus HR geodatabase – Must contain NHDPlusID and upstream watershed area (TotDASqKM) fields
River area polygons (NHDArea feature in NHDPlus HR geodatabase).

Horizon angle grids - horizon angle grids. In this version, the raster must be organized as follows:
* Layer 1: 0-degree horizon angle
* Layer 2: 45-degree horizon angle
* Layer 3: 90-degree horizon angle
* Layer 4: 135-degree horizon angle
* Layer 5: 180-degree horizon angle
* Layer 6: 225-degree horizon angle
* Layer 7: 270-degree horizon angle
* Layer 8: 315-degree horizon angle

Vegetation height raster (meters) – see Landfire metadata for example

Vegetation density raster (percent cover) – see Landfire metadata for example

Elevation  - digital elevation model grid (meters)

Disclaimer: The United States Environmental Protection Agency (EPA) GitHub project code is 
provided on an "as is" basis and the user assumes responsibility for its use. EPA has 
relinquished control of the information and no longer has responsibility to protect the 
integrity, confidentiality, or availability of the information. Any reference to specific
commercial products, processes, or services by service mark, trademark, manufacturer, or
otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA.
The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial
product or activity by EPA or the United States Government.
