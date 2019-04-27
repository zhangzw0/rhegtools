execHEG <- function(object = "GRID", prmTemplatefile, Infiles, OutDIR = "./HEG_OUT",
                    ignore.stderr = NULL, Sys_ignore.stdout=FALSE,
                    Sys_wait=TRUE, Sys_input=NULL, intern=NULL) {
  if (!file.exists(prmTemplatefile)) stop("parameter file not found")
  if (!dir.exists(OutDIR)) {
    dir.create(OutDIR)
  }
  if (is.null(ignore.stderr))
    ignore.stderr <- get.ignore.stderrOption()
  stopifnot(is.logical(ignore.stderr))
  if (is.null(intern))
    intern <- get.useInternOption()
  stopifnot(is.logical(intern))

  if (object == "GRID") {
    cmd <- "resample"
  } else if (object == "SWATH") {
    cmd <- "swtif"
  } else if (object == "MISRGRID") {
    cmd <- "gdtif"
  } else {
    warning("Nothing has been done")
    return(-1)
  }

  for (ifile in Infiles) {
    prm_tmp <- file.copy(prmTemplatefile, "tmp.prm", overwrite = TRUE)
    sed.args <- paste(paste0("'s^infile^", ifile, "^g'"), prm_tmp)
    sed.args1 <- paste(paste0("'s^outfile^", paste0(ifile,"_HEGOUT"), "^g'"), prm_tmp)
    system2("sed", args = sed.args, wait = TRUE, stdout = "tmp.log")
    system2("sed", args = sed.args1, wait = TRUE, stdout = "tmp.log")

    syscmd <- paste(cmd, "-p", prm_tmp)
    if (get("SYS", envir=.HEG_CACHE) == "unix") {
      res <- system(syscmd, intern=intern, ignore.stderr=ignore.stderr,
                    ignore.stdout=Sys_ignore.stdout, wait=Sys_wait, input=Sys_input)
    } else {
      print("Non unix system: nothing been done")
    }
  }


}
