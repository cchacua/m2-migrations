
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# ynumbers<-seq(1975, 2013, 1)
# lapply(ynumbers, ugraphinv_dis)

ynumbers<-seq(1975, 2013, 1)
lapply(ynumbers, ugraphinv_dis_bulk, sector="ctt")
lapply(ynumbers, ugraphinv_dis_bulk, sector="pboc")


# demo<-ugraphinv_dis_bulk(1999, sector="ctt") 
# ynumbersl<-c(1999)
# lapply(ynumbersl, ugraphinv_dis_line)
# ugraphinv_dis_bulk(2010)
# time<-Sys.time()
# gsub("(\\:|\\s+|-)","",Sys.time())
