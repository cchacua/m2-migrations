rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

ynumbers<-seq(1975, 2012, 1)
ynumbers<-seq(2000, 2012, 1)
lapply(ynumbers, cognidistance, sector="ctt")
lapply(ynumbers, cognidistance, sector="pboc")

cognidistance(1990, "ctt")


techctt<-merge.csv("../output/graphs/techproxi/ctt/")
techctt$undid<-paste0(techctt$year,techctt$finalID_,techctt$finalID__)
fwrite(techctt, "../output/graphs/techproxi/tech_ctt.csv")

techpboc<-merge.csv("../output/graphs/techproxi/pboc/")
techpboc$undid<-paste0(techpboc$year,techpboc$finalID_,techpboc$finalID__)
fwrite(techpboc, "../output/graphs/techproxi/tech_pboc.csv")


