---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     
ALTER TABLE riccaboni.t08 ADD INDEX(pat);


---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us;
CREATE TABLE riccaboni.t08_names_allclasses_us AS
SELECT a.*
      FROM riccaboni.t01_allclasses_appid_patstat_us b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat;
/*
Query OK, 3.530.520 rows affected (1 min 33,98 sec)
Records: 3.530.520  Duplicates: 0  Warnings: 0

*/



---------------------------------------------------------------------------------------------------
-- Countings
---------------------------------------------------------------------------------------------------


SELECT COUNT(DISTINCT UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us a;
/*
+-------------------------------+
| COUNT(DISTINCT UPPER(a.name)) |
+-------------------------------+
|                       1037431 |
+-------------------------------+
1 row in set (27,24 sec)
*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               815539 |
+----------------------+
1 row in set (8,72 sec)

*/


SELECT COUNT(DISTINCT a.ID, UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us a;
/*


*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------
/*     
SELECT DISTINCT a.ID, a.name       
      FROM riccaboni.t08_names_allclasses_us a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';

Query OK, 1177432 rows affected (25,01 sec)
*/            

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES, WITH MOBILITY LINKS
-- FINAL TABLE: riccaboni.t08_names_allclasses_us_mob
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t09;                                     
ALTER TABLE riccaboni.t09 ADD INDEX(localID);

SHOW INDEX FROM riccaboni.t08_names_allclasses_us;                                     
ALTER TABLE riccaboni.t08_names_allclasses_us ADD INDEX(ID);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us;                                     
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us ADD INDEX(pat);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_family;


DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob AS
SELECT a.*, b.mobileID, d.APPLN_ID, d.DOCDB_FAMILY_ID
      FROM riccaboni.t08_names_allclasses_us a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us c 
      ON a.pat=c.pat
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_family d
      ON c.APPLN_ID = d.APPLN_ID;
/*
Query OK, 3530520 rows affected (2 min 25,70 sec)
Records: 3530520  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob ADD INDEX(DOCDB_FAMILY_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob ADD INDEX(APPLN_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob ADD INDEX(pat);

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob a
      WHERE a.mobileID IS NOT NULL;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               199.161 |
+----------------------+
1 row in set (2,20 sec)
*/

SELECT COUNT(DISTINCT a.mobileID)       
      FROM riccaboni.t08_names_allclasses_us_mob a;
/*+----------------------------+
| COUNT(DISTINCT a.mobileID) |
+----------------------------+
|                     114.219 |
+----------------------------+
1 row in set (2,03 sec)

So, there are 84.942 less IDS, when using the mobile inventor links

SELECT COUNT(DISTINCT b.mobileID), CHAR_LENGTH(b.mobileID) AS Nchar
                              FROM riccaboni.t08_names_allclasses_us_mob b
                              GROUP BY CHAR_LENGTH(b.mobileID);
+----------------------------+-------+
| COUNT(DISTINCT b.mobileID) | Nchar |
+----------------------------+-------+
|                          8 |     3 |
|                         69 |     4 |
|                        628 |     5 |
|                       5200 |     6 |
|                      35310 |     7 |
|                      73004 |     8 |
+----------------------------+-------+
6 rows in set (2,17 sec)

*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------  

SELECT DISTINCT a.ID, a.name, a.mobileID       
      FROM riccaboni.t08_names_allclasses_us_mob a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Mobile_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*
Query OK, 1177432 rows affected (26,84 sec)

*/
