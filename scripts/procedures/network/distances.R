
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# ynumbers<-seq(1975, 2013, 1)
# lapply(ynumbers, ugraphinv_dis)

ynumbers<-seq(2000, 2009, 1)
lapply(ynumbers, ugraphinv_dis_bulk)

ugraphinv_dis_bulk(1999)


ynumbersl<-c(1999)
lapply(ynumbersl, ugraphinv_dis_line)



ugraphinv_dis_bulk(2010)
time<-Sys.time()
gsub("(\\:|\\s+|-)","",Sys.time())
