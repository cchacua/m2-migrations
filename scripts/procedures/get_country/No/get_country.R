require(sp)
require(rgdal)
require(maps)

# 1 - Read points with coordinates and turn it into a SpatialPointsDataFrame
tric_loc<-read.csv(files.sql[1], header = FALSE)
colnames(tric_loc)<-"loc"
tric_loc$loc<-as.character(tric_loc$loc)
tric_loc<-do.call("rbind", strsplit(tric_loc$loc, ","))
tric_loc<-data.frame(apply(tric_loc, 2, as.numeric))
colnames(tric_loc)<-c("lat","long")

#tric_loc<-tric_loc[1:10000,]
coordinates(tric_loc) <- c("long", "lat")

# 2 - Read USA polygons
mapusa<-readRDS(files.gadm[1])

# 3 - Set coordinate systems as equal
proj4string(tric_loc) <- proj4string(mapusa)

# 4 - Test
inside.usa <- !is.na(over(tric_loc, as(mapusa, "SpatialPolygons")))
inside.usa.df<-as.data.frame(inside.usa)
inside.usa.df[inside.usa.df$inside.usa==TRUE,]
mean(inside.usa)


########################################################################################



########################################################################################
# Test
########################################################################################

# 1 - Read points with coordinates and turn it into a SpatialPointsDataFrame
tric_loc<-read.csv(files.sql[3], header = FALSE)
colnames(tric_loc)<-c("ID", "pat", "name", "loc", "qual", "loctype")

tric_loc<-tric_loc[tric_loc$loc!="",]
tric_loc[6892,]
tric_loc_copy<-tric_loc
tric_loc$loc<-as.character(tric_loc$loc)
tric_loc<-do.call("rbind", strsplit(tric_loc$loc, ","))
tric_loc<-data.frame(apply(tric_loc, 2, as.numeric))
colnames(tric_loc)<-c("lat","long")
tric_loc<-tric_loc[6500:6510,]
tric_loc_copy2<-tric_loc
#tric_loc<-tric_loc[1:10000,]
coordinates(tric_loc) <- c("long", "lat")

# 2 - Read USA polygons
mapusa<-readRDS(files.gadm[1])

# 3 - Set coordinate systems as equal
proj4string(tric_loc) <- proj4string(mapusa)
#proj4string(tric_loc) <- "+proj=longlat +datum=WGS84 +init=epsg:4326"

# 4 - Test
inside.usa <- !is.na(over(tric_loc, as(mapusa, "SpatialPolygons")))
inside.usa.df<-as.data.frame(inside.usa)
inside.usa.df.c<-inside.usa.df[inside.usa.df$inside.usa==FALSE,]
#6892 false
mean(inside.usa)

# 5 - Map

plot(coordinates(tric_loc), type="n")
#map("world", region="usa")
map("world", region="usa", add=TRUE)
plot(mapusa, border="green", add=TRUE)
legend("topleft", cex=0.85,
       c("In USA", "Not in USA", "Boundary"),
       pch=c(16, 1, NA), lty=c(NA, NA, 1),
       col=c("red", "grey", "green"), bty="n")
title("Inventors in the USA")

# now plot addresses with separate colors inside and outside of the USA
points(tric_loc[!inside.usa, ], pch=1, col="gray")
points(tric_loc[inside.usa, ], pch=16, col="red")

mapview(tric_loc)

########################################################################################
