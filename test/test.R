library(rhegtools)
HEGHOME <- "/Users/wei/Tools/heg"
initHEG(HEGHOME)

# test for GRID processing
objname <- "MODIS_Grid_16Day_VI_CMG"
fieldname <- "CMG 0.05 Deg 16 days NDVI"
infiles = paste0("data_grid/",list.files("data_grid/"))
execHEG(type = "GRID", infiles = infiles,
        subset.up = 60, subset.down = 20, subset.left = 110, subset.right = 130,
        objectname = objname, fieldname = fieldname, Sys_ignore.stdout = TRUE)


# test for SWATH processing
objname <- "mod04"
fieldname <- "Optical_Depth_Land_And_Ocean"
infiles = paste0("data_swath/",list.files("data_swath/"))
execHEG(type = "SWATH", infiles = infiles,
        objectname = objname, fieldname = fieldname, Sys_ignore.stdout = FALSE)
