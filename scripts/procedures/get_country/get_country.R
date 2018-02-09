# https://cran.r-project.org/web/views/Spatial.html

#sf::st_read
mapworld<- st_read(files.gadm[5])

tric_loc<-read.csv(files.sql[1], header = FALSE)
colnames(tric_loc)<-"loc"
tric_loc$loc<-as.character(tric_loc$loc)
tric_loc<-do.call("rbind", strsplit(tric_loc$loc, ","))
tric_loc<-data.frame(apply(tric_loc, 2, as.numeric))
colnames(tric_loc)<-c("lat","long")


tric_loc_points<- st_as_sf(SpatialPoints(tric_loc[,c("long", "lat")]))

st_crs(tric_loc_points) <- st_crs(mapworld)
mapview(tric_loc_points[1:10,])

country<- st_within(tric_loc_points[1:10,], mapworld)

iso<-sapply(country, function(x) as.character(mapworld$ISO[x]))


# my.sf.point <- st_as_sf(x = tric_loc, 
#                         coords = c("long", "lat"),
#                         crs = "+proj=longlat +datum=WGS84 +init=epsg:3857")
# #EPSG:3857
# 
# my.sf.point <- st_as_sf(x = tric_loc, 
#                         coords = c("long", "lat"),
#                         crs = "+proj=longlat +datum=WGS84")
# 
# plot(my.sf.point[1:100,])






