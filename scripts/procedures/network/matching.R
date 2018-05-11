rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

ynumbers<-seq(1976, 2011, 1)
lapply(ynumbers, controls_bulk, numbercontrols=1, sector="ctt")
lapply(ynumbers, controls_bulk, numbercontrols=1, sector="pboc")
controls_bulk(2012, numbercontrols=1, sector="pboc")
#controls_bulk(2012, numbercontrols=1, sector="ctt")


#View(rr[rr$class=='NA',])
# essai<-dbGetQuery(patstat, paste0("SELECT *
#                                      FROM christian.t08_class_at1us_date_fam 
#                                     WHERE EARLIEST_FILING_YEAR=",linkyear," AND finalID='HI3477'"))
# patipc6e<-dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
#                                      FROM christian.t08_class_at1us_date_fam_for a 
#                                      INNER JOIN riccaboni.t01_", sector, "_class b 
#                                      ON a.pat=b.pat 
#                                      INNER JOIN christian.pat_6ipc c
#                                      ON a.pat=c.pat 
#                                      WHERE finalID='HI3477'"))


counterctt<-merge.csv("../output/graphs/counterfactual/ctt/")
fwrite(counterctt, "../output/graphs/counterfactual/counterctt.csv")

counterpboc<-merge.csv("../output/graphs/counterfactual/pboc/")
fwrite(counterpboc, "../output/graphs/counterfactual/counterpboc.csv")
