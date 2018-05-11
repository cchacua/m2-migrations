require(sp)
require(rgdal)
require(maps)

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
file.df<-as.data.table(dbGetQuery(patstat, "SELECT DISTINCT a.yfinalID, a.loc, a.nloc  FROM christian.finalid_geo_all a;"))

file.df<-file.df[order(file.df$nloc, decreasing = TRUE),]
file.df<-reshape(transform(file.df, time=ave(loc, yfinalID,  FUN=seq_along)), idvar="yfinalID", direction="wide")
colnames(file.df)
file.df<-file.df[,1:3]
colnames(file.df)<-c("yfinalID", "loc", "nloc")
fwrite(file.df, "../output/graphs/geo_onlyone.csv")

