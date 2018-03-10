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

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone AS
SELECT DISTINCT a.ID, a.name
      FROM riccaboni.t08 a
      INNER JOIN riccaboni.t01_allclasses_as_t08_us_atleastone b
      ON a.ID=b.localInventor;
/*
Query OK, 1353539 rows affected (17 min 8,76 sec)
Records: 1353539  Duplicates: 0  Warnings: 0
*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone a;

/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               743646 |
+----------------------+
1 row in set (2,85 sec)
*/


DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility;
CREATE TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility AS
SELECT DISTINCT a.ID, c.mobileID, IFNULL(c.mobileID, a.ID) AS finalID, a.name
      FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone a
      LEFT JOIN riccaboni.t09 c
      ON a.ID=c.localID;
/*
Query OK, 1353539 rows affected (36,23 sec)
Records: 1353539  Duplicates: 0  Warnings: 0
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

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES, WITH MOBILITY LINKS
-- riccaboni.t08_names_allclasses_us_mob_atleastone
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t09;                                     
ALTER TABLE riccaboni.t09 ADD INDEX(localID);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_family;


DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob_atleastone AS
SELECT a.*, b.mobileID, d.APPLN_ID, d.DOCDB_FAMILY_ID
      FROM riccaboni.t08_names_allclasses_us_atleastone a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone c 
      ON a.pat=c.pat
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_family d
      ON c.APPLN_ID = d.APPLN_ID;
/*
Query OK, 3122408 rows affected (2 min 6,72 sec)
Records: 3122408  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(DOCDB_FAMILY_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(APPLN_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(pat);

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      WHERE a.mobileID IS NOT NULL;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               179547 |
+----------------------+
1 row in set (3,00 sec)

*/

SELECT COUNT(DISTINCT a.mobileID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
+----------------------------+
| COUNT(DISTINCT a.mobileID) |
+----------------------------+
|                     105256 |
+----------------------------+
1 row in set (3,57 sec)

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
