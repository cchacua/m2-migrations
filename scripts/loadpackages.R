
library(devtools)
library(RMySQL)
library(dplyr)
#library(Hmisc)
library(xtable)
source("../sources/c.R")

library(ggplot2)
library(scales)
library(stringr)
library(data.table)
library(sp)
#library(sf)
library(mapview)
library(stringi)
library(igraph)
source("scripts/functions.R")
library(foreign)
library(cem)
library(geosphere)
library(stargazer)
library(miceadds)
library(multiwayvcov)
library(foreign)
#library(sandwich)
#library(lmtest)
library(rms)
library(DescTools)
#library(rcompanion)
library(psych)
library(ggsci)
library(tikzDevice)
library(car)
library(tibble)
library(margins)
library(aod)

####################################################################
# Function to compute clusterized SE
# https://economictheoryblog.com/2016/12/13/clustered-standard-errors-in-r/
# https://stackoverflow.com/questions/44027482/cluster-robust-standard-errors-in-stargazer
# load necessary packages for importing the function
# library(RCurl)
# # import the function from repository
# url_robust <- "https://raw.githubusercontent.com/IsidoreBeautrelet/economictheoryblog/master/robust_summary.R"
# eval(parse(text = getURL(url_robust, ssl.verifypeer = FALSE)),
#      envir=.GlobalEnv)

####################################################################