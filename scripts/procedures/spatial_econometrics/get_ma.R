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
#mapusa<-readRDS("../data/gadm/nuts2/USA_adm2.rds")
mapusa<- readOGR(dsn = "../data/OECD_MA_USA", layer = "USA_MAs_2016")

# Set coordinate systems as equal
proj4string(tric_loc) <- proj4string(mapusa)

# Create ID taking into account core here and in the stata database to merge

# Check if point is in polygon and save as csv
inside.usa<- over(tric_loc, as(mapusa, "SpatialPolygons"))
inside.usa2<-sapply(inside.usa, function(x) as.character(mapusa$METRO[x])) 
inside.usa3<-sapply(inside.usa, function(x) as.character(mapusa$NAME[x])) 
inside.usa4<-sapply(inside.usa, function(x) as.character(mapusa$CORE[x])) 
output<-data.frame(lat=file.df$lat, long=file.df$long, OBJECTID=inside.usa, METRO=inside.usa2, NAME=inside.usa3, CORE=inside.usa4)
output<-output[complete.cases(output),]
output$loc<-paste0(output$lat,",",output$long)
output$METROID<-paste0(output$METRO, output$CORE)
write.csv(output, "../output/spatial_eco/us_locations_MA_both.csv")

df<-as.data.frame(mapusa)
nrow(unique(df[,c(1,3)]))
nrow(unique(df[,c(1,2)]))

######################################

files.ma<-list.files(path="../data/oecd_ma", full.names=TRUE)
files.ma
f<-merge.csv("../data/oecd_ma")
f<-f[substr(f$METRO_ID,1,2)=="US",]
dictionary.df<-unique(f[,c(3,4,7:12,14,15)])
write.csv(dictionary.df, "../output/spatial_eco/dictionary_usma_oecd.csv")

# Create ID taking into account core here and in the stata database to merge

f<- dcast(f[,c(1:3,6,13)], METRO_ID + Metropolitan.areas + Year ~ VAR, value.var='Value')
write.csv(f, "../output/spatial_eco/data_usma_oecd.csv")
write.dta(f, "../output/spatial_eco/data_usma_oecd.dta")

f2005<-f[f$Year==2005,]
write.dta(f2005, "../output/spatial_eco/data_usma_oecd_2005.dta")

##############
# Race data
mapusa.df<-as.data.frame(mapusa)
race<-read.csv("../output/spatial_eco/race.csv")
race$nametwo<-gsub("(-|,)", " ", race$Metro)
names1<-data.frame(NAME=unique(mapusa.df$NAME))
names<-partialMatch(names1$NAME,race$nametwo,levDist=0.12)
result<-merge(names1,names,by.x="NAME",by.y='raw.x',all.x=T)
result<-merge(result,race,by.x='raw.y',by.y="nametwo",all.x=T)
write.csv(result, "../output/spatial_eco/race_toedit--.csv")
result<-read.csv("../output/spatial_eco/race_toedit.csv")
#result<-merge(mapusa.df,result, by="NAME")
result$NAME<-as.character(result$NAME)
#result$METRO<-as.character(result$METRO)
write.dta(result, "../output/spatial_eco/race_statistics.dta")
