.HEG_CACHE <- new.env(FALSE, parent = globalenv())

.onLoad <- function(lib, pkg) {
  SYS <- ""
  if (.Platform$OS.type == "unix") SYS <- "unix"
  else if (.Platform$OS.type == "windows") SYS <- "windows"
  else SYS <- "unknown"
  assign("SYS", SYS, envir = .HEG_CACHE)
  assign("ignore.stderr", FALSE, envir=.HEG_CACHE)
  assign("useIntern", FALSE, envir=.HEG_CACHE)
  assign("echoCmd", FALSE, envir=.HEG_CACHE)
}


.onUnload <- function(lib, pkg) {
  rm(.HEG_CACHE)
}
