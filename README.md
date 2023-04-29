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

# Default Horizon Angle Grids

To reduce the time and computing power needed to calculate the horizon angle of each sample point, horizon angle grids were calculated for the contiguous United States using NHDPlusV2 NED Snapshot elevation grids. The tool used to calculate the horizon angle was created by Whitebox tools (https://cran.r-project.org/web/packages/whitebox/index.html). The following processing steps were used to calculate the horizon angle:
- Multiply raster values by 100 to convert unit of measurement from  centimeters to meters.
- Using the wbt_horizon_angle() function, calculate the horizon angle out to 100 km. This process is done for each elevation grid at angles of 0.1, 90, 135, 180, 225, 270, & 315 degrees. 
- For the resulting grids, set all values below 0 to 0. All values were then rounded to the nearest whole number. 
