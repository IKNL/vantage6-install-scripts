# Open file connection
file_name <- "R-installation-report.txt"
sink(file_name, append = TRUE)

# R version
r_vers <- version$version.string
cat(r_vers, file = file_name, sep = "", append = TRUE)
cat("\n", file = file_name, sep = "\n", append = TRUE)

# packages version
pkgs <- c("remotes", "REDCapR", "plyr", "dplyr", "openxlsx", "properties", "prodlim", "data.table", "formattable", "gtools", "rjson", "readtext")

for (i in pkgs) {
 if (i %in% rownames(installed.packages())){
   pkg_vers <- installed.packages()[i,"Version"]
   cat(paste0(i, " - Version ", pkg_vers), file = file_name, sep = "\n", append = TRUE)
 } else {
   cat(paste0(i, " not installed"), file = file_name, sep = "\n", append = TRUE)
 }
}

sink()
