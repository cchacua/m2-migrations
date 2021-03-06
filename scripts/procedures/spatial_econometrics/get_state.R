require(sp)
require(rgdal)
require(maps)

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
# Read points with coordinates and turn it into a SpatialPointsDataFrame
#file<-dbGetQuery(patstat, "SELECT DISTINCT a.loc FROM christian.t08_class_at1us_date_fam_nceltic a INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat;")
file<-dbGetQuery(patstat, "SELECT DISTINCT a.loc FROM riccaboni.t08 a INNER JOIN christian.ric_us_ao_both b ON a.pat=b.pat;")
colnames(file)<-"loc"
file$loc<-as.character(file$loc)
file.df<-do.call("rbind", strsplit(file$loc, ","))
file.df<-data.frame(apply(file.df, 2, as.numeric))
colnames(file.df)<-c("lat","long")
tric_loc<-file.df
coordinates(tric_loc) <- c("long", "lat")

# Read USA polygons
mapusa<-readRDS("../data/gadm/nuts2/USA_adm1.rds")
#as.data.frame(mapusa)
# Set coordinate systems as equal
proj4string(tric_loc) <- proj4string(mapusa)

# Check if point is in polygon and save as csv
inside.usa<- over(tric_loc, as(mapusa, "SpatialPolygons"))
inside.usa2<-sapply(inside.usa, function(x) as.character(mapusa$HASC_1[x])) 
output<-data.frame(lat=file.df$lat, long=file.df$long, OBJECTID=inside.usa, HASC_1=inside.usa2)
output<-output[complete.cases(output),]
output$loc<-paste0(output$lat,",",output$long)
output$HASC_1<-as.character(output$HASC_1)
write.csv(output, "../output/spatial_eco/us_locations_states.csv")


