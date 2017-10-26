use patstat2016b;
SELECT TLS201_APPLN.APPLN_ID FROM TLS201_APPLN  LIMIT 0, 10 INTO OUTFILE '/var/lib/mysql-files/result-test.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

USE riccaboni patstat2016b;
SELECT        riccaboni.t01.pat
              FROM riccaboni.t01
INTO OUTFILE '/var/lib/mysql-files/riccaboni-pubnumber.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';




-- Query three tables
USE riccaboni patstat2016b
SELECT patstat2016b.TLS201_APPLN.APPLN_ID, 
                                  patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
                                  RIGHT(riccaboni.t01.pat, LENGTH(riccaboni.t01.pat)-2) AS pat,
                                  patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID, 
                                  patstat2016b.TLS201_APPLN.DOCDB_FAMILY_SIZE, 
                                  patstat2016b.TLS201_APPLN.INPADOC_FAMILY_ID, 
                                  patstat2016b.TLS201_APPLN.NB_APPLICANTS, 
                                  patstat2016b.TLS201_APPLN.NB_INVENTORS 
                                  riccaboni.t01.invs, 
                                  riccaboni.t01.localInvs, 
                                  riccaboni.t01.apps, 
                                  riccaboni.t01.yr, 
                                  riccaboni.t01.classes, 
                                  riccaboni.t01.wasComplete 
                                  
                            FROM riccaboni.t01  
                            INNER JOIN patstat2016b.TLS211_PAT_PUBLN ON pat=patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR
                            INNER JOIN patstat2016b.TLS201_APPLN
                                ON patstat2016b.TLS201_APPLN.APPLN_ID=patstat2016b.TLS211_PAT_PUBLN.APPLN_ID
                            LIMIT 0, 100
INTO OUTFILE '/var/lib/mysql-files/three-joins.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


--
USE riccaboni;
    SELECT    RIGHT(riccaboni.t01.pat, LENGTH(riccaboni.t01.pat)-2) AS pat,
              riccaboni.t01.invs, 
              riccaboni.t01.localInvs, 
              riccaboni.t01.apps, 
              riccaboni.t01.yr, 
              riccaboni.t01.classes, 
              riccaboni.t01.wasComplete FROM riccaboni.t01
INTO OUTFILE '/var/lib/mysql-files/only-riccaboni.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

--

USE riccaboni patstat2016b
SELECT RIGHT( riccaboni.t01.pat, LENGTH(riccaboni.t01.pat)-2) AS pat,
              patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
              riccaboni.t01.invs, 
              riccaboni.t01.localInvs, 
              riccaboni.t01.apps, 
              riccaboni.t01.yr, 
              riccaboni.t01.classes, 
              riccaboni.t01.wasComplete 
              FROM patstat2016b.TLS211_PAT_PUBLN 
              INNER JOIN riccaboni.t01 ON patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR=pat
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
-- ONLY 26865

SELECT riccaboni.t01.pat AS pat,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
       patstat2016b.TLS211_PAT_PUBLN.PAT_PUBLN_ID
       FROM patstat2016b.TLS211_PAT_PUBLN 
       RIGHT JOIN riccaboni.t01 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t01.pat
       LIMIT 0, 100;"
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-pat-pub-num-including all.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


USE riccaboni patstat2016b;
SELECT riccaboni.t01.pat,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
       patstat2016b.TLS211_PAT_PUBLN.PAT_PUBLN_ID
       FROM riccaboni.t01
       LEFT JOIN patstat2016b.TLS211_PAT_PUBLN ON riccaboni.t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)
       LIMIT 0, 100
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-pubnum.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
-- TOTAL- 7.146.247 vs 9.290.268 patents in Riccaboni
-- Add 0 if 7 digits
-- Number of strings
-- Country

-- Send samples 
-- Statistics about the missings
-- Suggestions

SELECT riccaboni.t01.pat AS pat,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
       patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
       patstat2016b.TLS211_PAT_PUBLN.PAT_PUBLN_ID
       FROM patstat2016b.TLS211_PAT_PUBLN 
       RIGHT JOIN riccaboni.t01 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t01.pat
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-pat-pub-num-including-all.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';




SELECT riccaboni.t01.pat AS pat
       FROM patstat2016b.TLS211_PAT_PUBLN 
       RIGHT JOIN riccaboni.t01 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t01.pat
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-pat-pub-sample.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Description, sent a sample of missing
-- Extract only those rows from the three patent office
-- Cases with 7 number
-- Extract patents with 
-- Send a sample


-- CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR) AS pnumber,
--              riccaboni.t01.invs, 
--              riccaboni.t01.localInvs, 
--              riccaboni.t01.apps, 
--              riccaboni.t01.yr, 
--              riccaboni.t01.classes, 
--              riccaboni.t01.wasComplete 


SELECT patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR
              FROM patstat2016b.TLS211_PAT_PUBLN 
INTO OUTFILE '/var/lib/mysql-files/pat_pub_number211.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Query three tables
USE riccaboni patstat2016b;
SELECT        riccaboni.t01.pat,
              patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,
              patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
              patstat2016b.TLS201_APPLN.APPLN_ID, 
              patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID, 
              patstat2016b.TLS201_APPLN.DOCDB_FAMILY_SIZE, 
              patstat2016b.TLS201_APPLN.INPADOC_FAMILY_ID, 
              patstat2016b.TLS201_APPLN.NB_APPLICANTS, 
              patstat2016b.TLS201_APPLN.NB_INVENTORS, 
              riccaboni.t01.invs, 
              riccaboni.t01.localInvs, 
              riccaboni.t01.apps, 
              riccaboni.t01.yr, 
              riccaboni.t01.classes, 
              riccaboni.t01.wasComplete 
              FROM patstat2016b.TLS211_PAT_PUBLN 
              INNER JOIN riccaboni.t01 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t01.pat
              INNER JOIN patstat2016b.TLS201_APPLN ON patstat2016b.TLS211_PAT_PUBLN.APPLN_ID=patstat2016b.TLS201_APPLN.APPLN_ID
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-merge.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
-- 7.146.247
-- 




SELECT DISTINCT patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID
              FROM patstat2016b.TLS211_PAT_PUBLN 
              INNER JOIN riccaboni.t01 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t01.pat
              INNER JOIN patstat2016b.TLS201_APPLN ON patstat2016b.TLS211_PAT_PUBLN.APPLN_ID=patstat2016b.TLS201_APPLN.APPLN_ID
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-docfamily-pat.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
-- 3.364.255


-- Citations: aggregate information
-- Docdb family aggregate number
-- Nodes: docdb -> inventor

-- Send e-mail on Monday
-- Thursday 2 afternon : 2 PM

SELECT DISTINCT patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID
              FROM patstat2016b.TLS211_PAT_PUBLN 
              RIGHT JOIN riccaboni.t08 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t08.pat
              INNER JOIN patstat2016b.TLS201_APPLN ON patstat2016b.TLS211_PAT_PUBLN.APPLN_ID=patstat2016b.TLS201_APPLN.APPLN_ID
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-docfamily.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT patstat2016b.TLS201_APPLN.DOCDB_FAMILY_ID
              FROM patstat2016b.TLS211_PAT_PUBLN 
              RIGHT JOIN riccaboni.t08 ON CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)=riccaboni.t08.pat
              INNER JOIN patstat2016b.TLS201_APPLN ON patstat2016b.TLS211_PAT_PUBLN.APPLN_ID=patstat2016b.TLS201_APPLN.APPLN_ID
INTO OUTFILE '/var/lib/mysql-files/riccaboni-211-docfamily-inventors-all.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';