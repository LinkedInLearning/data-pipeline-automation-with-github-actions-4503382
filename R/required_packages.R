p <- c("EIAapi", "dplyr", "lubridate", "plotly")

pkg <- .packages(all.available = TRUE)
for(i in p){
    if(!i %in% pkg){
      message("Package", i, "is not installed. Installing the package:")
      install.packages(i)
    }

}

