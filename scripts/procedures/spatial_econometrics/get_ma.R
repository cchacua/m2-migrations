require(sp)
require(rgdal)
require(maps)

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
# Read points with coordinates and turn it into a SpatialPointsDataFrame
file<-dbGetQuery(patstat, "SELECT DISTINCT a.loc FROM christian.t08_class_at1us_date_fam_nceltic a INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat;")
colnames(file)<-"loc"
file$loc<-as.character(file$loc)
file.df<-do.call("rbind", strsplit(file$loc, ","))
file.df<-data.frame(apply(file.df, 2, as.numeric))
colnames(file.df)<-c("lat","long")
tric_loc<-file.df
coordinates(tric_loc) <- c("long", "lat")

# Read USA polygons
#mapusa<-readRDS("../data/gadm/nuts2/USA_adm2.rds")
mapusa<- readOGR(dsn = "../data/OECD_MA_USA", layer = "USA_MAs_2016")

# Set coordinate systems as equal
proj4string(tric_loc) <- proj4string(mapusa)

# Check if point is in polygon and save as csv
inside.usa<- over(tric_loc, as(mapusa, "SpatialPolygons"))
inside.usa2<-sapply(inside.usa, function(x) as.character(mapusa$METRO[x])) 
inside.usa3<-sapply(inside.usa, function(x) as.character(mapusa$NAME[x])) 
output<-data.frame(lat=file.df$lat, long=file.df$long, OBJECTID=inside.usa, METRO=inside.usa2, NAME=inside.usa3)
output<-output[complete.cases(output),]
output$loc<-paste0(output$lat,",",output$long)
write.csv(output, "../output/spatial_eco/us_locations_MA.csv")



######################################

files.ma<-list.files(path="../data/oecd_ma", full.names=TRUE)
files.ma
f<-merge.csv("../data/oecd_ma")
f<-f[substr(f$METRO_ID,1,2)=="US",]
dictionary.df<-unique(f[,c(3,4,7:12,14,15)])
write.csv(dictionary.df, "../output/spatial_eco/dictionary_usma_oecd.csv")

f<- dcast(f[,c(1:3,6,13)], METRO_ID + Metropolitan.areas + Year ~ VAR, value.var='Value')
write.csv(f, "../output/spatial_eco/data_usma_oecd.csv")
library(foreign)
write.dta(f, "../output/spatial_eco/data_usma_oecd.dta")


##############


