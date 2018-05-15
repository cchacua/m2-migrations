########################################################################################  
# RMySQL
########################################################################################   
  # To install the CRAN's version
  # install.packages("RMySQL")
  
  # To install the latest development version
  # In ubuntu: install those packages before
  # sudo apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev
  # sudo apt-get install libmariadb-client-lgpl-dev
  #   sudo apt-get update
  #   sudo apt-get install r-cran-rmysql
  install.packages("devtools")
  devtools::install_github("rstats-db/RMySQL")
  
  # To install sf (or udunits2)
  # sudo apt-get install libudunits2-dev
  
  # To install sf (gdal)
  # sudo add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
  # sudo apt update
  # sudo apt install gdal-bin python-gdal python3-gdal libgdal1-dev
########################################################################################  
  
install.packages("dplyr")  
#install.packages("Hmisc")    
install.packages("xtable")  
install.packages("ggplot2") 
install.packages("scales")
install.packages("stringr")
install.packages("data.table")
install.packages("sp")
install.packages("maps")


install.packages("udunits2")
install.packages("sf")
install.packages("mapview")
install.packages("cem")
install.packages("stringi")
install.packages("igraph")
install.packages("geosphere")
install.packages("stargazer")
install.packages("miceadds")
install.packages("multiwayvcov")
