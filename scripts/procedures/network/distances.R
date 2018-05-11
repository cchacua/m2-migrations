
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# ynumbers<-seq(1975, 2013, 1)
# lapply(ynumbers, ugraphinv_dis)

ynumbers<-seq(1975, 2012, 1)
lapply(ynumbers, ugraphinv_dis_bulk, sector="ctt")
lapply(ynumbers, ugraphinv_dis_bulk, sector="pboc")

ugraphinv_dis_bulk(1986, sector="ctt") 


socialdis_ctt<-merge.csv("../output/graphs/distance_list/ctt/")
socialdis_ctt$undid_<-paste0(socialdis_ctt$lyear,socialdis_ctt$finalID__,socialdis_ctt$finalID_)
socialdis_ctt<-socialdis_ctt[,c(1,8,4:7)]
colnames(socialdis_ctt)<-c("undid","undid_", "socialdist", "finalID_", "finalID__", "lyear" )
fwrite(socialdis_ctt, "../output/graphs/distance_list/socialdis_ctt.csv")

socialdis_pboc<-merge.csv("../output/graphs/distance_list/pboc/")
socialdis_pboc$undid_<-paste0(socialdis_pboc$lyear,socialdis_pboc$finalID__,socialdis_pboc$finalID_)
socialdis_pboc<-socialdis_pboc[,c(1,8,4:7)]
colnames(socialdis_pboc)<-c("undid","undid_", "socialdist", "finalID_", "finalID__", "lyear" )
fwrite(socialdis_pboc, "../output/graphs/distance_list/socialdis_pboc.csv")

# demo<-ugraphinv_dis_bulk(1999, sector="ctt") 
# ynumbersl<-c(1999)
# lapply(ynumbersl, ugraphinv_dis_line)
# ugraphinv_dis_bulk(2010)
# time<-Sys.time()
# gsub("(\\:|\\s+|-)","",Sys.time())
