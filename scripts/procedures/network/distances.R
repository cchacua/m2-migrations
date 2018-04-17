
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

ynumbers<-seq(1975, 2013, 1)
lapply(ynumbers, ugraphinv_dis)






