#' initialize the configuration of HEG
#'
#' @param HEGHOME the path to the HEG home directory
#' @note the subdirectorIES of HEGHOME must include bin, data, and TOOLKIT_MTD
#' @seealso \link{execHEG}
#' @export
initHEG <- function(HEGHOME) {
  if (!file.exists(HEGHOME)) stop(paste(HEGHOME, "not found!"))
  SYS <- get("SYS", envir=.HEG_CACHE)
  if (SYS == "windows") {

  } else if (SYS == "unix") {
    ePATH <- Sys.getenv("PATH")
    ePATH <- paste0(ePATH, ":", HEGHOME, "/bin")
    Sys.setenv(PATH=ePATH)
    Sys.setenv(HEGHOME=HEGHOME)
    Sys.setenv(LD_LIBRARY_PATH=paste0(HEGHOME, "/bin"))
    Sys.setenv(MRTDATADIR=paste0(HEGHOME, "/data"))
    Sys.setenv(PGSHOME=paste0(HEGHOME, "/TOOLKIT_MTD"))
    Sys.setenv(HEGUSER="Sharon")
    Sys.setenv(OMP_NUM_THREADS="1")
  }
}

get.ignore.stderrOption <- function() {
  get("ignore.stderr", envir = .HEG_CACHE)
}

get.useInternOption <- function() {
  get("useIntern", envir = .HEG_CACHE)
}

createPRM <- function(type = "SWATH") {
  if (type == "SWATH") {
    ans <- c("NUM_RUNS = 1",
             "BEGIN",
             "INPUT_FILENAME = infile",
             "OBJECT_NAME = objname",
             "FIELD_NAME = fieldname|",
             "BAND_NUMBER = 1",
             "OUTPUT_PIXEL_SIZE_X = 0.030392",
             "OUTPUT_PIXEL_SIZE_Y = 0.027061",
             "SPATIAL_SUBSET_UL_CORNER = ( up left )",
             "SPATIAL_SUBSET_LR_CORNER = ( down right )",
             "RESAMPLING_TYPE = resample",
             "OUTPUT_PROJECTION_TYPE = GEO",
             "ELLIPSOID_CODE = WGS84",
             "OUTPUT_PROJECTION_PARAMETERS = ( 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  )",
             "OUTPUT_FILENAME = outfile",
             "OUTPUT_TYPE = GEO",
             "END")
  } else if (type == "GRID") {
    ans <- c("NUM_RUNS = 1",
             "BEGIN",
             "INPUT_FILENAME = infile",
             "OBJECT_NAME = objname|",
             "FIELD_NAME = fieldname",
             "BAND_NUMBER = 1",
             "SPATIAL_SUBSET_UL_CORNER = ( up left )",
             "SPATIAL_SUBSET_LR_CORNER = ( down right )",
             "RESAMPLING_TYPE = resample",
             "OUTPUT_PROJECTION_TYPE = GEO",
             "ELLIPSOID_CODE = WGS84",
             "OUTPUT_PROJECTION_PARAMETERS = ( 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  )",
             "OUTPUT_PIXEL_SIZE = 180.0",
             "OUTPUT_FILENAME = outfile",
             "OUTPUT_TYPE = GEO",
             "END")
  }
}
