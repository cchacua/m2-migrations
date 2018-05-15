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

distance_pointsclass("ctt")
d1<-as.data.frame(d1)
distance_pointsclass("pboc")
