rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

ynumbers<-seq(1975, 2012, 1)
lapply(ynumbers, insdistance, sector="ctt")
lapply(ynumbers, insdistance, sector="pboc")

insdistance(1990, "ctt")


insdisctt<-merge.csv("../output/graphs/insdistance/ctt/")
insdisctt$undid<-paste0(insdisctt$year,insdisctt$finalID_,insdisctt$finalID__)
fwrite(insdisctt, "../output/graphs/insdistance/insdis_ctt.csv")


