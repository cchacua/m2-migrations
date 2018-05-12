require(sp)
require(rgdal)
require(maps)

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# MYSQL 1

# R1
file.df<-as.data.table(dbGetQuery(patstat, "SELECT DISTINCT a.yfinalID, a.loc, a.nloc  FROM christian.finalid_geo_all a;"))

file.df<-file.df[order(file.df$nloc, decreasing = TRUE),]
file.df<-reshape(transform(file.df, time=ave(loc, yfinalID,  FUN=seq_along)), idvar="yfinalID", direction="wide")
colnames(file.df)
file.df<-file.df[,1:3]
colnames(file.df)<-c("yfinalID", "loc", "nloc")
fwrite(file.df, "../output/graphs/geo_onlyone.csv")

# MYSQL 2

# R2
distance_pointsclass<-function(tfield){
  file.df<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT a.locid, a.loc, a.loc_  FROM riccaboni.count_edges_",tfield,"_gs a;")))
  
  file.df$loc<-as.character(file.df$loc)
  file.df$loc_<-as.character(file.df$loc_)
  file.df1<-do.call("rbind", strsplit(file.df$loc, ","))
  file.df1<-data.frame(apply(file.df1, 2, as.numeric))
  colnames(file.df1)<-c("lat","long")
  file.df1<-as.matrix(file.df1[,c(2,1)])
    
  file.df2<-do.call("rbind", strsplit(file.df$loc_, ","))
  file.df2<-data.frame(apply(file.df2, 2, as.numeric))
  colnames(file.df2)<-c("lat","long")
  file.df2<-as.matrix(file.df2[,c(2,1)])
  
  distances<-geosphere::distGeo(file.df1, file.df2)
  distances<-as.data.table(distances)
  distances$locid<-as.vector(file.df$locid)
  # print(distances)
  fwrite(distances, paste0("../output/graphs/geodis_locid",tfield, "_list", ".csv"))
  return("Done")
  #return(distances)
}

distance_pointsclass("ctt")
d1<-as.data.frame(d1)
distance_pointsclass("pboc")
