initHEG <- function(hegHome) {
  if (!file.exists(hegHome)) stop(paste(hegHome, "not found!"))
  SYS <- get("SYS", envir=.HEG_CACHE)
  if (SYS == "windows") {

  } else if (SYS == "unix") {
    ePATH <- Sys.getenv("PATH")
    ePATH <- paste0(ePATH, ":", hegHome, "/bin")
    Sys.setenv(PATH=ePATH)
  }
}

get.ignore.stderrOption <- function() {
  get("ignore.stderr", envir = .HEG_CACHE)
}

get.useInternOption <- function() {
  get("useIntern", envir = .HEG_CACHE)
}

createPrm <- function(fname) {

  if (!file.exists(fname)) {
    warning("Parameter file not created!")
    return(NA_character_)
  }
  fname
}
