-- This script extracts all the PCT applications from Morrison et al database

SHOW INDEX FROM riccaboni.t01;  
SHOW INDEX FROM riccaboni.t08; 
SHOW INDEX FROM riccaboni.t09; 
SHOW INDEX FROM oecd_citations.WO_CITATIONS; 

DROP TABLE IF EXISTS oecd_citations.WO_CITATIONS_pnum; 
CREATE TABLE oecd_citations.WO_CITATIONS_pnum AS
SELECT DISTINCT b.Citing_pub_nbr AS pat, b.Citing_appln_id AS APPLN_ID
FROM oecd_citations.WO_CITATIONS b;

/*
Query OK, 2998017 rows affected (1 min 24,15 sec)
Records: 2998017  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM oecd_citations.WO_CITATIONS_pnum;                                      
ALTER TABLE oecd_citations.WO_CITATIONS_pnum ADD INDEX(pat);

SELECT COUNT(a.pat)
    FROM riccaboni.t01 a
    INNER JOIN oecd_citations.WO_CITATIONS_pnum c 
    ON  a.pat=c.pat;
/*
+--------------+
| COUNT(c.pat) |
+--------------+
|      2361517 |
+--------------+
1 row in set (50,25 sec)

2361517 Matched T01 and OECD AND 2361535 IN Morrison T01
*/



SELECT a.pat, c.pat
    FROM riccaboni.t01 a
    LEFT JOIN oecd_citations.WO_CITATIONS_pnum c 
    ON  a.pat=c.pat
    WHERE LEFT(a.pat,2)='WO' AND c.pat IS NULL;
/*
+--------------+------+
| pat          | pat  |
+--------------+------+
| WO1980020067 | NULL |
| WO1986009146 | NULL |
| WO1986092232 | NULL |
| WO1989007063 | NULL |
| WO1991007436 | NULL |
| WO1992096729 | NULL |
| WO1994027872 | NULL |
| WO1994027873 | NULL |
| WO1996040129 | NULL |
| WO1997013491 | NULL |
| WO1997040926 | NULL |
| WO2000308114 | NULL |
| WO2002200081 | NULL |
| WO2002250103 | NULL |
| WO2005041197 | NULL |
| WO2005110003 | NULL |
| WO2005123531 | NULL |
| WO2008204036 | NULL |
+--------------+------+
18 rows in set (25,77 sec)

*/


------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t08_wo; 
CREATE TABLE christian.t08_wo AS
SELECT DISTINCT b.APPLN_ID, IFNULL(c.mobileID, a.ID) AS finalID, a.*
FROM riccaboni.t08 a
INNER JOIN oecd_citations.WO_CITATIONS_pnum b
ON a.pat = b.pat
LEFT JOIN riccaboni.t09 c
ON a.ID=c.localID;
/*
Query OK, 6701281 rows affected (6 min 32,16 sec)
Records: 6701281  Duplicates: 0  Warnings: 0

The finalID is the Morrison et al ID after including the mobility links
*/

SELECT * FROM christian.t08_wo
INTO OUTFILE '/var/lib/mysql-files/T08_PCT_APPLN_ID.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n';
/*
Query OK, 6701281 rows affected (13,41 sec)

*/

SELECT * FROM christian.t08_wo LIMIT 0,10;

-- NOT ALL THE PATENTS IN THE MAIN TABLE OF Morrison et al (T01) are included in the table of inventors (T08)

SELECT COUNT(DISTINCT a.pat)
    FROM christian.t08_wo a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2336425 |
+-----------------------+
1 row in set (19,70 sec)

2.336.425 Morrison T08, 2.361.535 Morrison T01, 2361517 Matched with OECD
*/

SELECT COUNT(DISTINCT a.APPLN_ID)
    FROM christian.t08_wo a;
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    2336425 |
+----------------------------+
1 row in set (16,00 sec)
*/

SELECT COUNT(DISTINCT a.pat)
    FROM riccaboni.t08 a
    WHERE LEFT(a.pat,2)='WO';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2336442 |
+-----------------------+
1 row in set (17,39 sec)
*/

SELECT COUNT(*)
    FROM riccaboni.t08
    WHERE LEFT(pat,2)='WO';
/*
+----------+
| COUNT(*) |
+----------+
|  6701321 |
+----------+
1 row in set (13,40 sec)
*/

-- Missing patents and rows (T08 VS OECD)
SHOW INDEX FROM christian.t08_wo;                                      
ALTER TABLE christian.t08_wo ADD INDEX(pat);

DROP TABLE IF EXISTS christian.t08_wo_missing; 
CREATE TABLE christian.t08_wo_missing AS
SELECT DISTINCT a.pat
FROM riccaboni.t08 a
LEFT JOIN (SELECT DISTINCT c.pat FROM christian.t08_wo c) b
ON a.pat = b.pat
WHERE LEFT(a.pat,2)='WO' AND b.pat IS NULL;

SHOW INDEX FROM christian.t08_wo_missing;                                      
ALTER TABLE christian.t08_wo_missing ADD INDEX(pat);

SELECT NULL AS APPLN_ID, a.* FROM riccaboni.t08 a INNER JOIN christian.t08_wo_missing b ON a.pat = b.pat
INTO OUTFILE '/var/lib/mysql-files/T08_PCT_APPLN_ID_MISSING.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n';
/*
Query OK, 29 rows affected (0,01 sec)
*/


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- CREATE TABLE SIMILAR TO T08 FROM T01, using the localInvs information
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

-- 01 Distribution of of local inventors (number of commas +1)
SELECT DISTINCT CHAR_LENGTH(a.localInvs) - CHAR_LENGTH(REPLACE(a.localInvs, ',', '')) AS localInvscomas, COUNT(a.pat) 
FROM riccaboni.t01 a 
WHERE LEFT(a.pat,2)='WO'
GROUP BY localInvscomas
ORDER BY localInvscomas DESC;

/*
+----------------+--------------+
| localInvscomas | COUNT(a.pat) |
+----------------+--------------+
|             98 |            1 |
|             61 |            1 |
|             59 |            1 |
|             53 |            2 |
|             52 |            2 |
|             49 |            2 |
|             48 |            3 |
|             47 |            1 |
|             46 |            2 |
|             45 |            2 |
|             43 |            1 |
|             42 |            5 |
|             41 |            4 |
|             40 |            3 |
|             39 |            7 |
|             38 |            6 |
|             37 |            3 |
|             36 |            6 |
|             35 |            6 |
|             34 |            9 |
|             33 |           12 |
|             32 |           16 |
|             31 |            8 |
|             30 |           13 |
|             29 |           18 |
|             28 |           43 |
|             27 |           34 |
|             26 |           37 |
|             25 |           42 |
|             24 |           44 |
|             23 |           52 |
|             22 |           73 |
|             21 |          106 |
|             20 |          132 |
|             19 |          154 |
|             18 |          266 |
|             17 |          304 |
|             16 |          415 |
|             15 |          595 |
|             14 |          910 |
|             13 |         1257 |
|             12 |         1912 |
|             11 |         3007 |
|             10 |         4640 |
|              9 |         7705 |
|              8 |        12851 |
|              7 |        22437 |
|              6 |        39811 |
|              5 |        73800 |
|              4 |       135236 |
|              3 |       252367 |
|              2 |       414113 |
|              1 |       583073 |
|              0 |       805985 | there are 805985 publication numbers with 1 (0 comas + 1) local inventor
+----------------+--------------+
54 rows in set (4,32 sec)
*/

-- 02 

---------------------------------------------------------------------------------------------------
-- 2 - Create a table with the number of inventors (fields)
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.numbers_0_100;
CREATE TABLE christian.numbers_0_100 AS
SELECT (t*10+u+1) AS n, (t*10+u) AS nminusone  from
(select 0 t union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) A,
(select 0 u union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) B
order by n;

SELECT a.* FROM christian.numbers_0_100 a;

SHOW INDEX FROM christian.numbers_0_100;     
ALTER TABLE christian.numbers_0_100 ADD INDEX(n);
ALTER TABLE christian.numbers_0_100 ADD INDEX(nminusone);

---------------------------------------------------------------------------------------------------
-- 3 - Create new table with csv column as rows: christian.t01_as_t08_wo
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t01_as_t08_wo;
CREATE TABLE christian.t01_as_t08_wo AS
SELECT
  b.pat,
  SUBSTRING_INDEX(SUBSTRING_INDEX(b.localInvs, ',', a.n), ',', -1) AS localInventor, a.n, CONCAT(b.pat, '_',LPAD(a.n, 2, '0')) AS patinvid  
  FROM riccaboni.numbers_0_100 a
  INNER JOIN riccaboni.t01 b
  ON CHAR_LENGTH(b.localInvs) - CHAR_LENGTH(REPLACE(b.localInvs, ',', ''))>=a.nminusone
WHERE LEFT(b.pat,2)='WO'
ORDER BY
  patinvid;

/*
Query OK, 6185612 rows affected (3 min 49,15 sec)
Records: 6185612  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t01_as_t08_wo;     
ALTER TABLE christian.t01_as_t08_wo ADD INDEX(pat);
ALTER TABLE christian.t01_as_t08_wo ADD INDEX(localInventor(15));

SELECT a.* FROM christian.t01_as_t08_wo a LIMIT 0,10;

SELECT b.APPLN_ID, IFNULL(c.mobileID, a.localInventor) AS finalID, a.* 
FROM christian.t01_as_t08_wo a
LEFT JOIN oecd_citations.WO_CITATIONS_pnum b
ON a.pat = b.pat
LEFT JOIN riccaboni.t09 c
ON a.localInventor=c.localID
INTO OUTFILE '/var/lib/mysql-files/T01_AS_T08_PCT.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n';


SELECT a.* FROM riccaboni.t08 a WHERE a.pat='WO1978000009';

SELECT a.* FROM riccaboni.t08 a 
INNER JOIN riccaboni.t09 b
ON a.ID=b.localID
WHERE b.mobileID='LM172625';

DROP TABLE IF EXISTS christian.t08_wo_pat;
CREATE TABLE christian.t08_wo_pat AS
SELECT DISTINCT pat FROM riccaboni.t08
WHERE LEFT(pat,2)='WO';
/*
Query OK, 2336442 rows affected (29,76 sec)
Records: 2336442  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_wo_pat;                                      
ALTER TABLE christian.t08_wo_pat ADD INDEX(pat(15));

SELECT * FROM christian.t08_wo_pat LIMIT 0,10;


-- T01 AS T08, only the patents that do not appear in T08
DROP TABLE IF EXISTS christian.t01_as_t08_wo_mi;
CREATE TABLE christian.t01_as_t08_wo_mi AS
SELECT c.APPLN_ID, IFNULL(d.mobileID, a.localInventor) AS finalID, a.* 
FROM christian.t01_as_t08_wo a 
LEFT JOIN christian.t08_wo_pat b ON a.pat=b.pat 
LEFT JOIN oecd_citations.WO_CITATIONS_pnum c
ON a.pat = c.pat
LEFT JOIN riccaboni.t09 d
ON a.localInventor=d.localID
WHERE b.pat IS NULL AND LEFT(a.pat,2)='WO';

/*
Query OK, 25409 rows affected (50,72 sec)
Records: 25409  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t01_as_t08_wo_mi;                                      
ALTER TABLE christian.t01_as_t08_wo_mi ADD INDEX(pat(15));
ALTER TABLE christian.t01_as_t08_wo_mi ADD INDEX(localInventor(15));

SELECT * FROM christian.t01_as_t08_wo_mi LIMIT 0,100;


SELECT COUNT(*) FROM christian.t01_as_t08_wo_mi WHERE finalID='';
/*
+----------+
| COUNT(*) |
+----------+
|    23677 |
+----------+
1 row in set (0,03 sec)
There are 23677 rows (patents) that do not have information on the inventors
and 1732 rows (patent-inventor) with information on inventors
*/

SELECT COUNT(DISTINCT pat) FROM christian.t01_as_t08_wo_mi WHERE finalID!='';
/*
+---------------------+
| COUNT(DISTINCT pat) |
+---------------------+
|                1416 |
+---------------------+
1 row in set (0,04 sec)
There are 1416 patents that have information on inventors and that do not appear in t08, but are recorded in t01
*/
SELECT * FROM christian.t01_as_t08_wo_mi WHERE finalID='';

-- Example of a patent without inventors
SELECT * FROM christian.t01_as_t08_wo_mi WHERE pat='WO2014042696';
/*
mysql> SELECT * FROM christian.t01_as_t08_wo_mi WHERE pat='WO2014042696';
+-----------+---------+--------------+---------------+---+-----------------+
| APPLN_ID  | finalID | pat          | localInventor | n | patinvid        |
+-----------+---------+--------------+---------------+---+-----------------+
| 416210987 |         | WO2014042696 |               | 1 | WO2014042696_01 |
+-----------+---------+--------------+---------------+---+-----------------+
1 row in set (0,04 sec)
*/
SELECT * FROM riccaboni.t01 WHERE pat='WO2014042696';
/*
+--------------+------+-----------+----------+------+---------+-------------+
| pat          | invs | localInvs | apps     | yr   | classes | wasComplete |
+--------------+------+-----------+----------+------+---------+-------------+
| WO2014042696 |      |           | LA355836 | 2013 | 9       | 1           |
+--------------+------+-----------+----------+------+---------+-------------+
1 row in set (0,00 sec)
*/

SELECT * FROM patstat2016b.TLS207_PERS_APPLN WHERE APPLN_ID='416210987';
/*
+-----------+-----------+--------------+-------------+
| PERSON_ID | APPLN_ID  | APPLT_SEQ_NR | INVT_SEQ_NR |
+-----------+-----------+--------------+-------------+
|  40552629 | 416210987 |            1 |           0 |
+-----------+-----------+--------------+-------------+
1 row in set (0,00 sec)
*/

-- Example of a patent without inventors in Morrison et al but with a inventor in Patstat
SELECT * FROM christian.t01_as_t08_wo_mi WHERE pat='WO2014041439';
/*
+-----------+---------+--------------+---------------+---+-----------------+
| APPLN_ID  | finalID | pat          | localInventor | n | patinvid        |
+-----------+---------+--------------+---------------+---+-----------------+
| 416208780 |         | WO2014041439 |               | 1 | WO2014041439_01 |
+-----------+---------+--------------+---------------+---+-----------------+
1 row in set (0,03 sec)
*/
SELECT * FROM patstat2016b.TLS207_PERS_APPLN WHERE APPLN_ID='416208780';
/*
+-----------+-----------+--------------+-------------+
| PERSON_ID | APPLN_ID  | APPLT_SEQ_NR | INVT_SEQ_NR |
+-----------+-----------+--------------+-------------+
|  19459807 | 416208780 |            1 |           1 |
|  47453540 | 416208780 |            3 |           0 |
|  47592920 | 416208780 |            2 |           0 |
|  47745303 | 416208780 |            4 |           0 |
+-----------+-----------+--------------+-------------+
4 rows in set (0,00 sec)
*/


SELECT COUNT(DISTINCT a.pat) FROM christian.t01_as_t08_wo_mi a 
INNER JOIN patstat2016b.TLS207_PERS_APPLN b
ON a.APPLN_ID=b.APPLN_ID
WHERE a.finalID='' AND b.INVT_SEQ_NR='1';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 23164 |
+-----------------------+
1 row in set (4,46 sec)
*/

SELECT COUNT(DISTINCT a.pat)  FROM christian.t01_as_t08_wo_mi a 
INNER JOIN patstat2016b.TLS207_PERS_APPLN b
ON a.APPLN_ID=b.APPLN_ID
WHERE a.finalID='' AND b.INVT_SEQ_NR>1;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 15798 |
+-----------------------+
1 row in set (0,51 sec)
*/

SHOW INDEX FROM riccaboni.t08;                                      

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t01_as_t08_wo_mi a
INNER JOIN riccaboni.t08 b
ON a.localInventor=b.ID
WHERE a.finalID!='';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                   902 |
+-----------------------+
1 row in set (0,11 sec)
*/

SELECT DISTINCT a.pat
FROM christian.t01_as_t08_wo_mi a
LEFT JOIN riccaboni.t08 b
ON a.localInventor=b.ID
WHERE a.finalID!='' AND b.ID IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                   554 |
+-----------------------+
1 row in set (0,09 sec)
*/

-- Example of an ID that appears in T01, but not in the other tables
select * from riccaboni.t01 where pat='WO2013007305';
/*
+--------------+-----------+-----------+----------+------+---------+-------------+
| pat          | invs      | localInvs | apps     | yr   | classes | wasComplete |
+--------------+-----------+-----------+----------+------+---------+-------------+
| WO2013007305 | HI3625859 | HI3625859 | LA767212 | 2011 | 24      | 1           |
+--------------+-----------+-----------+----------+------+---------+-------------+
1 row in set (0,00 sec)
*/
select * from riccaboni.t08 where ID='HI3625859';
select * from riccaboni.t09 where localID='HI3625859';
select * from riccaboni.t07 where ID='HI3625859';
