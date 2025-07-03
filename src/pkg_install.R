###  Custom script for required package installation  ###

# Define the vector of CRAN packages to install
pkg2install.CRAN = c(
  "data.table","dplyr","ggplot2","devtools",
  "rmarkdown","knitr"
)  

for(pkg in pkg2install.CRAN) {
  message(paste("Checking for CRAN package:", pkg))
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  } else {
    message(paste(pkg, "is already installed.\n"))
  }
}


# Define the vector of GitHub packages to install
pkg2install.github = c(
  "DoseResponse/drc",
  "andschar/standartox"
)

for(pkg in pkg2install.github) {
  n = gsub("^.*/", "", pkg)  # Extract the package name from the GitHub URL
  message(paste("Checking for github package:", n))
  if (!requireNamespace(n, quietly = TRUE)) {
    devtools::install_github(pkg)
    message("install...")
  } else {
    message(paste(n, "is already installed.\n"))
  }
}

# Clean up 
rm(pkg, pkg2install.CRAN, pkg2install.github, n)