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

########################################################################################  
  
install.packages("dplyr")  
#install.packages("Hmisc")    
install.packages("xtable")  
install.packages("ggplot2") 
install.packages("scales")
