
###################
# Part 7
###################

part7.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                           FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots 
                           FROM christian.idnames_a03 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                           WHERE a.ncommas='1' AND a.ncommasblanksright='1'
                           ORDER BY a.finalID",
                           filename = "part7.csv")
# Attention to companies
part7_c<-as.data.frame(part7.list[1])
part7_c<-part7_c[order(nchar(part7_c$full), decreasing = TRUE),]

write.csv(unique(part7_c$full), paste0("../output/nationality/", "part7_onlynames.csv"))

part7_nc<-as.data.frame(part7.list[2])




"
SELECT COUNT(DISTINCT a.finalID)       
FROM christian.idnames_a06 a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                     51474 |
+---------------------------+
1 row in set (0,06 sec)

*/

DROP TABLE IF EXISTS christian.idnames_part07;
CREATE TABLE christian.idnames_part07 AS
SELECT DISTINCT a.name, a.finalID 
FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots 
FROM christian.idnames_a06 b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
WHERE a.ncommas='1' AND a.ncharac<='20' AND a.ncommasblanksright='1' AND a.hnumber='0' 
ORDER BY a.finalID;
/*

*/


SHOW INDEX FROM christian.idnames_part07; 
ALTER TABLE christian.idnames_part07 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a07;
CREATE TABLE christian.idnames_a07 AS
SELECT a.*
FROM christian.idnames_a06 a
LEFT JOIN christian.idnames_part07 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
/*


*/

SHOW INDEX FROM christian.idnames_a07; 
ALTER TABLE christian.idnames_a07 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a06;
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


