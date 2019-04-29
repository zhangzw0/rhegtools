#' call the command of the HEG TOOL
#'
#' @param type a character of "GRID" or "SWATH", specifying the object type of HEG-EOS files
#' @param infiles a character vector of HEG-EOS files
#' @param objectname character, the SWATH name or GRID name
#' @param fieldname character, one filed in the SWATH object
#' @param subset.up numeric, the up latitude of the subsetting extent
#' @param resample character, the resampling method
#' @return a status code (0 success, -1 failed)
#'
#' @details see the HEG website \url{https://newsroom.gsfc.nasa.gov/sdptoolkit/HEG/HEGHome.html}
#' @note set the subsetting extent to the whole geographic region (-180, 180 and -90, 90) when the subsetting operation should not be done
#'
#' @examples
#' HEGHOME <- "usr/local/heg"
#' initHEG(HEGHOME)
#' objname <- "mod04"
#' fieldname <- "Optical_Depth_Land_And_Ocean"
#' infiles = paste0("data_swath/",list.files("data_swath/"))
#' execHEG(type = "SWATH", infiles = infiles,
#'        objectname = objname, fieldname = fieldname, Sys_ignore.stdout = FALSE)
#'
#' @export
execHEG <- function(type = "GRID", infiles,
                    objectname = NULL, fieldname = NULL,
                    subset.up = 90.0, subset.left = -180.0,
                    subset.down = -90.0, subset.right = 180.0,
                    resample = "NN",
                    ignore.stderr = NULL, Sys_ignore.stdout=FALSE,
                    Sys_wait=TRUE, Sys_input=NULL, intern=NULL) {
  if (is.null(objectname)) stop("objectname must be provided")
  if (is.null(fieldname)) stop("fieldname must be provided")
  if (is.null(ignore.stderr))
    ignore.stderr <- get.ignore.stderrOption()
  stopifnot(is.logical(ignore.stderr))
  if (is.null(intern))
    intern <- get.useInternOption()
  stopifnot(is.logical(intern))

  if (type == "GRID") {
    cmd <- "resample"
  } else if (type == "SWATH") {
    cmd <- "swtif"
  } else if (type == "MISRGRID") {
    cmd <- "gdtif"
  } else {
    warning("Nothing has been done")
    return(-1)
  }

  loc <- c(subset.up, subset.down, subset.left, subset.right)
  loc <- format(loc, nsmall = 2)
  prm <- createPRM(type = type)
  pats <- c("objname", "fieldname", "up", "down", "left", "right", "resample")
  reps <- c(objectname, fieldname, as.character(loc), resample)
  for (i in 1:length(pats)) {
    prm <- sub(pattern = pats[i], replacement = reps[i], x = prm)
  }

  for (ifile in infiles) {
    prm_i <- sub("infile", replacement = ifile, x = prm)
    prm_i <- sub("outfile", replacement = paste0(ifile,"_HEGOUT.tif"), x = prm_i)

    prmfile <- tempfile(tmpdir = ".")
    writeLines(prm_i, con = prmfile)
    syscmd <- paste(cmd, "-p", prmfile)
    if (get("SYS", envir=.HEG_CACHE) == "unix") {
      res <- system(syscmd, intern=intern, ignore.stderr=ignore.stderr,
                    ignore.stdout=Sys_ignore.stdout, wait=Sys_wait, input=Sys_input)
    } else {
      print("Non unix system: nothing been done")
    }
    file.remove(prmfile)
  }

  return(0)
}
