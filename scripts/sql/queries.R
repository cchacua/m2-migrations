# To see secure folder:
# SHOW VARIABLES LIKE "secure_file_priv";

# rs<-dbGetQuery(db, "SELECT APPLN_ID FROM TLS201_APPLN  LIMIT 0, 10;")
# rs<-as.data.frame(rs)
# rs$APPLN_ID<-as.numeric(rs$APPLN_ID)

q1<- dbSendQuery(db, "SELECT APPLN_ID FROM TLS201_APPLN  LIMIT 1000, 1100;")
apn<-dbFetch(q1)
dbClearResult(q1)