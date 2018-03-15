########################################
# Load data
########################################

# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')


###################
# Part 1
###################
part1.df<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID",
                        filename = "part1.csv")
print(part1.df[grepl(")",part1.df$full),])
part1.df$full[part1.df$full=="Lihua(Lily) ZHANG"]<-"Lihua ZHANG"
part1.df$full[part1.df$full=="Chiakeng(jack) WU"]<-"Chiakeng WU"
write.csv(part1.df, paste0("../output/nationality/", "part1.csv"))
part1.df<-read.csv("../output/nationality/part1.csv")
dbWriteTable(christian, "idnames_part01", data.frame(finalID=part1.df$finalID), field.types=list(finalID="VARCHAR(15)"), row.names=FALSE)
"
DROP TABLE IF EXISTS christian.idnames_part01;
"

# Run on MySQL 
"
DROP TABLE IF EXISTS christian.idnames_part01;
CREATE TABLE christian.idnames_part01 AS
SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID;
/*
Query OK, 187031 rows affected (25,35 sec)
Records: 187031  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.idnames_part01; 
ALTER TABLE christian.idnames_part01 ADD INDEX(finalID);

SHOW INDEX FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility; 
ALTER TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a01;
CREATE TABLE christian.idnames_a01 AS
SELECT a.*, b.finalID AS bfid
FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a
LEFT JOIN christian.idnames_part01 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*
Query OK, 1163727 rows affected (21,56 sec)
Records: 1163727  Duplicates: 0  Warnings: 0
1350758-1163727=187031 IT'S OK
*/

SHOW INDEX FROM christian.idnames_a01; 
ALTER TABLE christian.idnames_a01 ADD INDEX(finalID);
"

###################
# Part 2
###################
part2.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots!='0'
                        ORDER BY a.finalID",
                         filename = "part2.csv")
part2_c<-as.data.frame(part2.list[1])
part2_nc<-as.data.frame(part2.list[2])

"
DROP TABLE IF EXISTS christian.idnames_part02;
CREATE TABLE christian.idnames_part02 AS
SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots!='0'
                        ORDER BY a.finalID;

SHOW INDEX FROM christian.idnames_part02; 
ALTER TABLE christian.idnames_part02 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a02;
CREATE TABLE christian.idnames_a02 AS
SELECT a.*
FROM christian.idnames_a01 a
LEFT JOIN christian.idnames_part02 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*
Query OK, 1163512 rows affected (19,71 sec)
Records: 1163512  Duplicates: 0  Warnings: 0

1163727-1163512=215 IT'S OK
*/

SHOW INDEX FROM christian.idnames_a02; 
ALTER TABLE christian.idnames_a02 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a01;
"

###################
# Part 3
###################

part3.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM christian.idnames_a02 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1'
ORDER BY a.finalID",
                           filename = "part3.csv")
part3_c<-as.data.frame(part3.list[1])
part3_nc<-as.data.frame(part3.list[2])

"
DROP TABLE IF EXISTS christian.idnames_part03;
CREATE TABLE christian.idnames_part03 AS
SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots!='0'
ORDER BY a.finalID;

SHOW INDEX FROM christian.idnames_part03; 
ALTER TABLE christian.idnames_part03 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a03;
CREATE TABLE christian.idnames_a03 AS
SELECT a.*
FROM christian.idnames_a02 a
LEFT JOIN christian.idnames_part03 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*
Query OK, 1163512 rows affected (19,71 sec)
Records: 1163512  Duplicates: 0  Warnings: 0

1163727-1163512=215 IT'S OK
*/

SHOW INDEX FROM christian.idnames_a03; 
ALTER TABLE christian.idnames_a03 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a02;
"


################

tt<-read.csv("../output/nationality/part1.csv")


namesone.df<-dbGetQuery(patstat, 
                         "SELECT DISTINCT a.name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0'
                        ORDER BY a.finalID")


namesone.df<-dbGetQuery(patstat, 
                        "SELECT MAX(a.name) AS name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0'
                        GROUP BY a.finalID 
                        HAVING COUNT(a.finalID)=1 
                        ORDER BY a.finalID")





















