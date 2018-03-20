########################################
# Load data
########################################

# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
rs <- dbSendQuery(patstat, 'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci')
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
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
ORDER BY a.finalID",
                           filename = "part3.csv")
part3_c<-as.data.frame(part3.list[1])
View(part3_c[part3_c$full=="Joost J.J HEGMANS",])
write.csv(unique(part3_c$full), paste0("../output/nationality/", "part3_onlynames.csv"))
# length(unique(part3_c$full))
# [1] 100919
# 107881-100919: 6962
part3_nc<-as.data.frame(part3.list[2])




"
DROP TABLE IF EXISTS christian.idnames_part03;
CREATE TABLE christian.idnames_part03 AS
SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM christian.idnames_a02 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
ORDER BY a.finalID;
/*
Query OK, 107894 rows affected (18,63 sec)
Records: 107894  Duplicates: 0  Warnings: 0
*/


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
Query OK, 1055618 rows affected (21,68 sec)
Records:   Duplicates: 0  Warnings: 0


1163512-1055618=107894 IT'S OK
*/

SHOW INDEX FROM christian.idnames_a03; 
ALTER TABLE christian.idnames_a03 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a02;
"


################

###################
# Part 4
###################

part4.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM christian.idnames_a03 a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID",
                           filename = "part4.csv")
# Attention to companies
part4_c<-as.data.frame(part4.list[1])
#part4_c_unique<-part4_c[!duplicated(part4_c$finalID),]
#part4_c_dupl<-part4_c[duplicated(part4_c$finalID),]



part4_c_res<-reshape(transform(part4_c, time=ave(full, finalID, FUN=seq_along)), idvar="finalID", direction="wide")
part4_c_unique<-part4_c_res[is.na(part4_c_res$full.2),]
length(unique(part4_c_unique$finalID))
#123482
length(unique(part4_c_unique$full.1))
# 119411
write.csv(unique(part4_c_unique$full.1), paste0("../output/nationality/", "part4_onlynames_unique.csv"))

part4_c_dupl<-part4_c_res[!is.na(part4_c_res$full.2),]
# part4_c_dupl[part4_c_dupl$firstname.1=="Henrik",]
# View(part4_c_dupl[part4_c_dupl$finalID=="HI218193",])
# part4_c_dupl[part4_c_dupl$finalID=="HI218193","name.1"]
# iconv(part4_c_dupl[part4_c_dupl$finalID=="HI218193","name.1"], "LATIN2", "UTF-8")
# SELECT * FROM riccaboni.t08 WHERE ID='HI218193';
write.csv(part4_c_dupl, paste0("../output/nationality/", "part4_onlynames_duplicates.csv"))
part4_c_dupl2<-read.csv("../output/nationality/part4/part4_onlynames_duplicates-open.csv", header = FALSE)
part4_c_dupl2<-data.frame(V1=unique(part4_c_dupl2$V2))
write.csv(part4_c_dupl2, paste0("../output/nationality/", "part4_onlynames_duplicates_4b.csv"))

part4_c<-part4_c[order(nchar(part4_c$full), decreasing = TRUE),]

write.csv(unique(part4_c$full), paste0("../output/nationality/", "part4_onlynames.csv"))
# length(unique(part3_c$full))
# [1] 100919
# 107881-100919: 6962
part4_nc<-as.data.frame(part4.list[2])




"
SELECT COUNT(DISTINCT a.finalID)       
FROM christian.idnames_a03 a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    374195 |
+---------------------------+
1 row in set (2,14 sec)
*/


DROP TABLE IF EXISTS christian.idnames_part04;
CREATE TABLE christian.idnames_part04 AS
SELECT DISTINCT a.name, a.finalID 
                        FROM christian.idnames_a03 a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID;
/*
Query OK, 147507 rows affected (9,27 sec)
Records: 147507  Duplicates: 0  Warnings: 0
*/


SHOW INDEX FROM christian.idnames_part04; 
ALTER TABLE christian.idnames_part04 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a04;
CREATE TABLE christian.idnames_a04 AS
SELECT a.*
FROM christian.idnames_a03 a
LEFT JOIN christian.idnames_part04 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*
Query OK, 553983 rows affected (19,62 sec)
Records: 553983  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM christian.idnames_a04; 
ALTER TABLE christian.idnames_a04 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a03;
"


###################
# Part 5
###################

part5.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM christian.idnames_a04 a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
                        ORDER BY a.finalID",
                           filename = "part5.csv")
# Attention to companies
part5_nc<-as.data.frame(part5.list[2])
part5_c<-as.data.frame(part5.list[1])

part5_c_res<-reshape(transform(part5_c, time=ave(full, finalID, FUN=seq_along)), idvar="finalID", direction="wide")
part5_c_unique<-part5_c_res[is.na(part5_c_res$full.2),]
# ATTENTION: TO CHANGE IN FUNCTION: CHANGE BLANKS BY -, BY FIRST AND LAST NAME, SO AS TO BETTER DEAL WITH MULTIPLE FIRST/LAST NAMES, AND THEN CREATE THE FULL NAME STRING
length(unique(part5_c_unique$finalID))
#68221
length(unique(part5_c_unique$full.1))
#65302
write.csv(unique(part5_c_unique$full.1), paste0("../output/nationality/", "part5_onlynames_unique.csv"))

part5_c_dupl<-part5_c_res[!is.na(part5_c_res$full.2),]
write.csv(part5_c_dupl, paste0("../output/nationality/", "part5_onlynames_duplicates.csv"))






"
SELECT COUNT(DISTINCT a.finalID)       
FROM christian.idnames_a04 a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    239305 |
+---------------------------+
1 row in set (0,35 sec)

*/

DROP TABLE IF EXISTS christian.idnames_part05;
CREATE TABLE christian.idnames_part05 AS
SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots 
FROM christian.idnames_a04 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
ORDER BY a.finalID;
/*

*/


SHOW INDEX FROM christian.idnames_part05; 
ALTER TABLE christian.idnames_part05 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a05;
CREATE TABLE christian.idnames_a05 AS
SELECT a.*
FROM christian.idnames_a04 a
LEFT JOIN christian.idnames_part05 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*


*/

SHOW INDEX FROM christian.idnames_a05; 
ALTER TABLE christian.idnames_a05 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a04;
"


###################
# Part 6
###################

part6.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                           FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots 
                           FROM christian.idnames_a03 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                           WHERE a.ncommas='1' AND a.ncommasblanksright='1'
                           ORDER BY a.finalID",
                           filename = "part6.csv")
# Attention to companies
part6_c<-as.data.frame(part6.list[1])
part6_c<-part6_c[order(nchar(part6_c$full), decreasing = TRUE),]

write.csv(unique(part6_c$full), paste0("../output/nationality/", "part6_onlynames.csv"))

part6_nc<-as.data.frame(part6.list[2])




"
SELECT COUNT(DISTINCT a.finalID)       
FROM christian.idnames_a05 a;
/*


*/

DROP TABLE IF EXISTS christian.idnames_part06;
CREATE TABLE christian.idnames_part06 AS
SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots 
FROM christian.idnames_a05 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
ORDER BY a.finalID;
/*

*/


SHOW INDEX FROM christian.idnames_part06; 
ALTER TABLE christian.idnames_part06 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a06;
CREATE TABLE christian.idnames_a06 AS
SELECT a.*
FROM christian.idnames_a05 a
LEFT JOIN christian.idnames_part06 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*


*/

SHOW INDEX FROM christian.idnames_a06; 
ALTER TABLE christian.idnames_a06 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a05;
"


################


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





















