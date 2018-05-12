
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')


#################################################################
# SOCIAL DISTANCE AND DEGREE CENTRALITY

# ynumbers<-seq(1975, 2013, 1)
# lapply(ynumbers, ugraphinv_dis)

ynumbers<-seq(1975, 2012, 1)
lapply(ynumbers, ugraphinv_dis_bulk, sector="ctt")
lapply(ynumbers, ugraphinv_dis_bulk, sector="pboc")
ynumbers<-seq(2006, 2012, 1)
ugraphinv_dis_bulk(2005, sector="ctt") 


socialdis_ctt<-merge.csv("../output/graphs/distance_list/ctt/")
fwrite(socialdis_ctt, "../output/graphs/distance_list/socialdis_ctt.csv")

socialdis_pboc<-merge.csv("../output/graphs/distance_list/pboc/")
fwrite(socialdis_pboc, "../output/graphs/distance_list/socialdis_pboc.csv")

# demo<-ugraphinv_dis_bulk(1999, sector="ctt") 
# ynumbersl<-c(1999)
# lapply(ynumbersl, ugraphinv_dis_line)
# ugraphinv_dis_bulk(2010)
# time<-Sys.time()
# gsub("(\\:|\\s+|-)","",Sys.time())


#################################################################
# DEGREE CENTRALITY

degree_ctt<-merge.csv("../output/graphs/degree/ctt/")
fwrite(degree_ctt, "../output/graphs/degree/degree_ctt.csv")

degree_pboc<-merge.csv("../output/graphs/degree/pboc/")
fwrite(degree_pboc, "../output/graphs/degree/degree_pboc.csv")
