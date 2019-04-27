HEGHOME <- "/Users/wei/Tools/heg"
ePATH <- Sys.getenv("PATH")
ePATH <- paste0(ePATH, ":", HEGHOME, "/bin")
Sys.setenv(PATH=ePATH)
Sys.setenv(HEGHOME=HEGHOME)
Sys.setenv(LD_LIBRARY_PATH=paste0(HEGHOME, "/bin"))
Sys.setenv(MRTDATADIR=paste0(HEGHOME, "/data"))
Sys.setenv(PGSHOME=paste0(HEGHOME, "/TOOLKIT_MTD"))
Sys.setenv(HEGUSER="Sharon")
Sys.setenv(OMP_NUM_THREADS="1")



Infiles <- paste0("data/", list.files("data/"))
prmTemplatefile <- "prmtemplate"

prm_tmp <- "tmp.prm"
prm_tmp_1 <- "tmp.prm_1"
file.copy(prmTemplatefile, prm_tmp, overwrite = TRUE)
ifile <- Infiles[1]
sed.args <- paste(paste0("sed 's^infile^", ifile, "^g'"), prm_tmp, ">", prm_tmp_1)
sed.args1 <- paste(paste0("sed 's^outfile^", paste0(ifile,"_HEGOUT"), "^g'"), prm_tmp_1, ">", prm_tmp)
system(sed.args, wait = TRUE)
system(sed.args1, wait = TRUE)

cmd = "resample"
syscmd <- paste(cmd, "-p", prm_tmp)
res <- system(syscmd, wait = TRUE)

for (ifile in Infiles) {
  prm_tmp <- file.copy(prmTemplatefile, "tmp.prm", overwrite = TRUE)
  sed.args <- paste(paste0("'s^infile^", ifile, "^g'"), "tmp.prm")
  sed.args1 <- paste(paste0("'s^outfile^", paste0(ifile,"_HEGOUT"), "^g'"), "tmp.prm")
  system2("sed", args = sed.args, wait = TRUE, stdout = "tmp.log")
  system2("sed", args = sed.args1, wait = TRUE, stdout = "tmp.log")
  
  syscmd <- paste(cmd, "-p", prm_tmp)
  res <- system(syscmd, intern=intern, ignore.stderr=ignore.stderr,
                ignore.stdout=Sys_ignore.stdout, wait=Sys_wait, input=Sys_input)
  
}
