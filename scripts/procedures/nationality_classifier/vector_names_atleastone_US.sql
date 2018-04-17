---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES USING T08
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     
ALTER TABLE riccaboni.t08 ADD INDEX(pat);

---------------------------------------------------------------------------------------------------
-- Merge and new table: riccaboni.t08_names_allclasses_us_atleastone
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_us_atleastone AS
SELECT b.*
      FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone a
      INNER JOIN riccaboni.t08 b
      ON a.pat=b.pat;
/*
Query OK, 3122408 rows affected (1 min 9,74 sec)
Records: 3122408  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_atleastone;                                     
ALTER TABLE riccaboni.t08_names_allclasses_us_atleastone ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_atleastone ADD INDEX(pat);

---------------------------------------------------------------------------------------------------
-- Countings
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat)       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1064938 |
+-----------------------+
1 row in set (8,81 sec)

1064938 T08_PATSTAT VS 1067135 T01_PATSTAT: SO, THERE ARE 2.197 PATENTS THAT APPEAR ON TABLE T01 BUT THAT ARE NOT INCLUDED IN T08
*/

SELECT COUNT(DISTINCT UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;
/*
+-------------------------------+
| COUNT(DISTINCT UPPER(a.name)) |
+-------------------------------+
|                        953956 |
+-------------------------------+
1 row in set (22,42 sec)

*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               743534 |
+----------------------+
1 row in set (5,52 sec)
*/


SELECT COUNT(DISTINCT a.ID, UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;
/*
+-------------------------------------+
| COUNT(DISTINCT a.ID, UPPER(a.name)) |
+-------------------------------------+
|                             1077415 |
+-------------------------------------+
1 row in set (19,89 sec)
*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------
/*     
SELECT DISTINCT a.ID, a.name       
      FROM riccaboni.t08_names_allclasses_us_atleastone a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
*/            


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES USING T01_AS_T08
-- riccaboni.t01_allclasses_as_t08_us_atleastone
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS riccaboni.t01_allclasses_as_t08_us_atleastone;
CREATE TABLE riccaboni.t01_allclasses_as_t08_us_atleastone AS
SELECT b.*
      FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone a 
      INNER JOIN riccaboni.t01_allclasses_as_t08 b
      ON a.pat=b.pat;
/*
Query OK, 3043373 rows affected (1 min 21,14 sec)
Records: 3043373  Duplicates: 0  Warnings: 0
*/


SELECT COUNT(DISTINCT b.localInventor), CHAR_LENGTH(b.localInventor) AS Nchar
                              FROM riccaboni.t01_allclasses_as_t08_us_atleastone b
                              GROUP BY CHAR_LENGTH(b.localInventor);
/*
+---------------------------------+-------+
| COUNT(DISTINCT b.localInventor) | Nchar |
+---------------------------------+-------+
|                               1 |     0 |
|                               5 |     3 |
|                              69 |     4 |
|                             544 |     5 |
|                            4738 |     6 |
|                           36446 |     7 |
|                          225028 |     8 |
|                          477147 |     9 |
+---------------------------------+-------+
8 rows in set (1 min 43,16 sec)

*/
ALTER TABLE riccaboni.t01_allclasses_as_t08_us_atleastone MODIFY localInventor VARCHAR(10);

SHOW INDEX FROM riccaboni.t01_allclasses_as_t08_us_atleastone;                                     
ALTER TABLE riccaboni.t01_allclasses_as_t08_us_atleastone ADD INDEX(localInventor);
ALTER TABLE riccaboni.t01_allclasses_as_t08_us_atleastone ADD INDEX(pat);


SELECT *      
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a LIMIT 0,10;

SELECT COUNT(DISTINCT a.pat)       
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1067135 |
+-----------------------+
1 row in set (1,90 sec)
*/

SELECT DISTINCT a.pat       
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a
      INTO OUTFILE '/var/lib/mysql-files/patt01ast08.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';


SELECT COUNT(DISTINCT a.localInventor)       
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a;
/*
+---------------------------------+
| COUNT(DISTINCT a.localInventor) |
+---------------------------------+
|                          743978 |
+---------------------------------+
1 row in set (5,59 sec)
*/

/*
TO SUM UP:

743534 DIFFERENT LOCAL IDS T08 VS 743978 DIFFERENT LOCAL IDS IN T01_AS_T08
SO, THERE ARE 444 NEW LOCAL IDS
*/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH IDs FOR THE SELECTED CLASSES, AT LEAST ONE INVENTOR RESIDING IN THE US, COMBINING BOTH T08 AND T01_AS_T08
-- FINAL TABLE: riccaboni.t08_names_allclasses_us_mob_atleastone
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

*/

DROP TABLE IF EXISTS riccaboni.t08_extended_allclasses_us_atleastone_onlyid;
CREATE TABLE riccaboni.t08_extended_allclasses_us_atleastone_onlyid AS
SELECT DISTINCT a.localInventor, b.ID
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a 
      INNER JOIN riccaboni.t08_names_allclasses_us_atleastone b
      ON a.localInventor=b.ID;
/*Query OK, 743534 rows affected (5 min 40,05 sec)
Records: 743534  Duplicates: 0  Warnings: 0
So, all the authors in t08 are in t01_as_t08, at least in this case (for these classes and the US)
*/

DROP TABLE IF EXISTS riccaboni.t08_extended_allclasses_us_atleastone_onlyid;
CREATE TABLE riccaboni.t08_extended_allclasses_us_atleastone_onlyid AS
SELECT DISTINCT a.localInventor AS ID
      FROM riccaboni.t01_allclasses_as_t08_us_atleastone a 
UNION 
SELECT DISTINCT b.ID
      FROM riccaboni.t08_names_allclasses_us_atleastone b;
/*
Query OK, 743978 rows affected (25,03 sec)
Records: 743978  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM riccaboni.t08_extended_allclasses_us_atleastone_onlyid; 
ALTER TABLE riccaboni.t08_extended_allclasses_us_atleastone_onlyid ADD INDEX(ID);


SHOW INDEX FROM riccaboni.t08; 

SHOW INDEX FROM riccaboni.t09; 
SHOW INDEX FROM riccaboni.t01_allclasses_as_t08_us_atleastone;

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone AS
SELECT DISTINCT a.ID, a.name
      FROM riccaboni.t08 a
      INNER JOIN riccaboni.t01_allclasses_as_t08_us_atleastone b
      ON a.ID=b.localInventor;
/*

Query OK, 1350758 rows affected (18 min 47,24 sec)
Records: 1350758  Duplicates: 0  Warnings: 0

*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone a;

/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               743646 |
+----------------------+
1 row in set (3,04 sec)

*/

                    
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility;
CREATE TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility AS
SELECT DISTINCT a.ID, c.mobileID, IFNULL(c.mobileID, a.ID) AS finalID, a.name,
           CHAR_LENGTH(a.name) AS ncharac, 
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' ', ''))) / CHAR_LENGTH(' ')) AS nblanks,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, '.', ''))) / CHAR_LENGTH('.')) AS ndots,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ',', ''))) / CHAR_LENGTH(',')) AS ncommas,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' , ', ''))) / CHAR_LENGTH(' , ')) AS ncommasblanksboth,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' ,', ''))) / CHAR_LENGTH(' ,')) AS ncommasblanksleft,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ', ', ''))) / CHAR_LENGTH(', ')) AS ncommasblanksright,
           LEFT(a.ID, 2) AS qualid,
           IF(a.name REGEXP '[0-9]', '1', '0') AS hnumber
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone a
      LEFT JOIN riccaboni.t09 c
      ON a.ID=c.localID;
/*
Query OK, 1350758 rows affected (1 min 4,56 sec)
Records: 1350758  Duplicates: 0  Warnings: 0



*/

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a;

/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               743646 |
+----------------------+
1 row in set (2,85 sec)
*/

SELECT COUNT(DISTINCT a.finalID)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    669335 |
+---------------------------+
1 row in set (2,66 sec)
*/

SELECT COUNT(DISTINCT a.name)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a;
/*
+------------------------+
| COUNT(DISTINCT a.name) |
+------------------------+
|                1205003 |
+------------------------+
1 row in set (10,80 sec)
*/

SELECT a.ncharac, COUNT(a.ncharac)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a GROUP BY a.ncharac;

SELECT a.nblanks, COUNT(a.nblanks)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a GROUP BY a.nblanks;
/*
+---------+------------------+
| nblanks | COUNT(a.nblanks) |
+---------+------------------+
|       0 |              932 |
|       1 |           385311 |
|       2 |           832171 |
|       3 |            71774 |
|       4 |            23378 |
|       5 |            18033 |
|       6 |            13382 |
|       7 |             4455 |
|       8 |              938 |
|       9 |              316 |
|      10 |               39 |
|      11 |               15 |
|      12 |                6 |
|      13 |                2 |
|      14 |                3 |
|      15 |                2 |
|      22 |                1 |
+---------+------------------+
17 rows in set (1,71 sec)

*/

SELECT * FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility WHERE finalID='UM313986';
SELECT * FROM riccaboni.t08 WHERE ID='UI4804984';
SELECT * FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility WHERE finalID='UI4804984';
SELECT * FROM riccaboni.t08 WHERE ID='LS4654436';
SELECT * FROM riccaboni.t08 WHERE ID='HI2061832';

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES, WITH MOBILITY LINKS
-- riccaboni.t08_names_allclasses_us_mob_atleastone
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08_names_allclasses_us_atleastone;

SHOW INDEX FROM riccaboni.t09;                                     
ALTER TABLE riccaboni.t09 ADD INDEX(localID);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone;


DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob_atleastone_one;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob_atleastone_one AS
SELECT a.*, IFNULL(b.mobileID, a.ID) AS finalID
      FROM riccaboni.t08_names_allclasses_us_atleastone a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone c 
      ON a.pat=c.pat;
/*
Query OK, 3122408 rows affected (2 min 0,04 sec)
Records: 3122408  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone_one;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone_one ADD INDEX(finalID);

SHOW INDEX FROM christian.id_nat;
ALTER TABLE christian.id_nat ADD INDEX(finalID);

---------------------------------------------------------------------------------------------------
-- Only the IDS of the name-analysis that correspond to inventors (no firms)
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob_atleastone AS
SELECT a.*, b.nation, b.prob, b.cname
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone_one a 
      INNER JOIN christian.id_nat b
      ON a.finalID=b.finalID;
/*
Query OK, 3121763 rows affected (1 min 48,13 sec)
Records: 3121763  Duplicates: 0  Warnings: 0

3122408-3121763=645
*/


SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(pat);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(finalID);


/*
SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      WHERE a.mobileID IS NOT NULL;

+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               179547 |
+----------------------+
1 row in set (3,00 sec)

*/

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               743015 |
+----------------------+
1 row in set (7,21 sec)
*/


SELECT COUNT(DISTINCT a.finalID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    668731 |
+---------------------------+
1 row in set (4,74 sec)

OLD
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    669243 |
+---------------------------+
1 row in set (4,37 sec)

743534-669243
So, there are 74.291 less IDS, when using the mobile inventor links


SELECT COUNT(DISTINCT b.mobileID), CHAR_LENGTH(b.mobileID) AS Nchar
                              FROM riccaboni.t08_names_allclasses_us_mob_atleastone b
                              GROUP BY CHAR_LENGTH(b.mobileID);
+----------------------------+-------+
| COUNT(DISTINCT b.mobileID) | Nchar |
+----------------------------+-------+
|                          0 |  NULL |
|                          8 |     3 |
|                         67 |     4 |
|                        585 |     5 |
|                       4835 |     6 |
|                      32829 |     7 |
|                      66932 |     8 |
+----------------------------+-------+
7 rows in set (3,71 sec)

*/



---------------------------------------------------------------------------------------------------
-- Only the IDS of the name-analysis that correspond to inventors (no firms), with dates, patent family, etc
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone;
SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone;
SHOW INDEX FROM patstat2016b.TLS201_APPLN;
SHOW INDEX FROM riccaboni.t01_allclasses;

DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam;
CREATE TABLE christian.t08_class_at1us_date_fam AS
SELECT a.*, b.APPLN_ID, c.DOCDB_FAMILY_ID, c.APPLN_FILING_YEAR, c.EARLIEST_FILING_YEAR, c.EARLIEST_PUBLN_YEAR, d.yr, d.classes, d.wasComplete
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
INNER JOIN riccaboni.t01_allclasses d
      ON a.pat=d.pat;
/*
Query OK, 3121763 rows affected (2 min 41,15 sec)
Records: 3121763  Duplicates: 0  Warnings: 0

*/

SELECT * FROM christian.t08_class_at1us_date_fam LIMIT 0,10;

SHOW INDEX FROM christian.t08_class_at1us_date_fam;
ALTER TABLE christian.t08_class_at1us_date_fam ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam ADD INDEX(finalID);



---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------  

SELECT DISTINCT a.ID, a.name, a.mobileID       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Mobile_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*


*/
