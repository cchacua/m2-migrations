# To see secure folder:
# SHOW VARIABLES LIKE "secure_file_priv";


# PATSTAT

dbListTables(patstat)
dbListFields(patstat, "TLS201_APPLN")
dbListFields(patstat, "TLS211_PAT_PUBLN")

# rs<-dbGetQuery(patstat, "SELECT APPLN_ID FROM TLS201_APPLN  LIMIT 0, 10;")
# rs<-as.data.frame(rs)
# rs$APPLN_ID<-as.numeric(rs$APPLN_ID)

#q1<- dbSendQuery(patstat, "SELECT APPLN_ID, DOCDB_FAMILY_ID, DOCDB_FAMILY_SIZE, INPADOC_FAMILY_ID, NB_APPLICANTS, NB_INVENTORS FROM TLS201_APPLN  LIMIT 1000, 1100;")
q1<- dbSendQuery(patstat, "SELECT TLS201_APPLN.APPLN_ID, TLS201_APPLN.DOCDB_FAMILY_ID, TLS201_APPLN.DOCDB_FAMILY_SIZE, TLS201_APPLN.INPADOC_FAMILY_ID, TLS201_APPLN.NB_APPLICANTS, TLS201_APPLN.NB_INVENTORS FROM TLS201_APPLN  LIMIT 1000, 1100;")
apn<-dbFetch(q1)
dbClearResult(q1)

q2<- dbSendQuery(patstat, "SELECT patstat2016b.TLS201_APPLN.APPLN_ID, patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID, patstat2016b.TLS201_APPLN.DOCDB_FAMILY_SIZE, patstat2016b.TLS201_APPLN.INPADOC_FAMILY_ID, patstat2016b.TLS201_APPLN.NB_APPLICANTS, patstat2016b.TLS201_APPLN.NB_INVENTORS FROM patstat2016b.TLS201_APPLN  LIMIT 1000, 1100;")
apn<-dbFetch(q2)
dbClearResult(q2)

q2<- dbSendQuery(patstat, "SELECT * FROM patstat2016b.TLS211_PAT_PUBLN
                 WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US' LIMIT 1000, 1100;")
apn<-dbFetch(q2)
dbClearResult(q2)

q2<- dbSendQuery(patstat, "SELECT CONCAT(PUBLN_AUTH,PUBLN_NR) AS pub_number FROM patstat2016b.TLS211_PAT_PUBLN   LIMIT 1000, 1100;")
apn211<-dbFetch(q2)
dbClearResult(q2)

q3<- dbSendQuery(patstat, "SELECT patstat2016b.TLS201_APPLN.APPLN_ID, 
                                  patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
                                  patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID, 
                                  patstat2016b.TLS201_APPLN.DOCDB_FAMILY_SIZE, 
                                  patstat2016b.TLS201_APPLN.INPADOC_FAMILY_ID, 
                                  patstat2016b.TLS201_APPLN.NB_APPLICANTS, 
                                  patstat2016b.TLS201_APPLN.NB_INVENTORS 
                            FROM patstat2016b.TLS201_APPLN  
                            INNER JOIN patstat2016b.TLS211_PAT_PUBLN
                            ON patstat2016b.TLS201_APPLN.APPLN_ID=patstat2016b.TLS211_PAT_PUBLN.APPLN_ID
                            LIMIT 0, 100;")
apn<-dbFetch(q3, n=100)
dbClearResult(q3)

# Riccaboni
dbListTables(riccaboni)
dbListFields(riccaboni, "t01")

q2<- dbSendQuery(riccaboni, "SELECT RIGHT(riccaboni.t01.pat, LENGTH(riccaboni.t01.pat)-2) AS pat, riccaboni.t01.invs, riccaboni.t01.localInvs, riccaboni.t01.apps, riccaboni.t01.yr, riccaboni.t01.classes, riccaboni.t01.wasComplete FROM riccaboni.t01  LIMIT 0, 100;")
apn2<-dbFetch(q2)
dbClearResult(q2)


q3<- dbSendQuery(riccaboni, "SELECT riccaboni.t01.pat FROM riccaboni.t01;")
ric.pn<-dbFetch(q3)
dbClearResult(q3)
save(ric.pn, file="../output/riccabonit01pat.RData")
ric.pn<-as.data.frame(ric.pn)
patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR 
q3<- dbSendQuery(patstat, "SELECT *
                            FROM patstat2016b.TLS211_PAT_PUBLN
                            
                            LIMIT 0, 500;")
apn<-dbFetch(q3, n=500)
dbClearResult(q3)