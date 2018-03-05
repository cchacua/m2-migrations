--------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     
ALTER TABLE riccaboni.t08 ADD INDEX(pat);


---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_allteam;
CREATE TABLE riccaboni.t08_names_allclasses_us_allteam AS
SELECT a.*
      FROM riccaboni.t01_allclasses_appid_patstat_us_allteam b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat;



/*

Query OK, 2.673.214 rows affected (1 min 34,29 sec)
Records: 2.673.214  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_allteam;                                     
ALTER TABLE riccaboni.t08_names_allclasses_us_allteam ADD INDEX(pat);
ALTER TABLE riccaboni.t08_names_allclasses_us_allteam ADD INDEX(ID);
---------------------------------------------------------------------------------------------------
-- Countings
---------------------------------------------------------------------------------------------------


SELECT COUNT(DISTINCT UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us_allteam a;
/*
+-------------------------------+
| COUNT(DISTINCT UPPER(a.name)) |
+-------------------------------+
|                        820570 |
+-------------------------------+
1 row in set (16,24 sec)


*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_allteam a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               626797 |
+----------------------+
1 row in set (5,02 sec)



*/


SELECT COUNT(DISTINCT a.ID, UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses_us_allteam a;
/*
+-------------------------------------+
| COUNT(DISTINCT a.ID, UPPER(a.name)) |
+-------------------------------------+
|                              918678 |
+-------------------------------------+
1 row in set (16,75 sec)


*/


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES, WITH MOBILITY LINKS
-- FINAL TABLE: riccaboni.t08_names_allclasses_us_mob_allteam
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob_allteam;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob_allteam AS
SELECT a.*, b.mobileID, d.APPLN_ID, d.DOCDB_FAMILY_ID
      FROM riccaboni.t08_names_allclasses_us_allteam a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us c 
      ON a.pat=c.pat
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_family d
      ON c.APPLN_ID = d.APPLN_ID;
/*
Query OK, 2465653 rows affected (1 min 59,83 sec)
Records: 2465653  Duplicates: 0  Warnings: 0


*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_allteam;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_allteam ADD INDEX(DOCDB_FAMILY_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_allteam ADD INDEX(APPLN_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_allteam ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_allteam ADD INDEX(pat);

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob_allteam a
      WHERE a.mobileID IS NOT NULL;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               135854 |
+----------------------+
1 row in set (2,89 sec)

*/

SELECT COUNT(DISTINCT a.mobileID)       
      FROM riccaboni.t08_names_allclasses_us_mob_allteam a;
/*

+----------------------------+
| COUNT(DISTINCT a.mobileID) |
+----------------------------+
|                      81671 |
+----------------------------+
1 row in set (2,58 sec)

 135854-81671 
So, there are 54.183 less IDS, when using the mobile inventor links

*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------  

SELECT DISTINCT a.ID, a.name, a.mobileID       
      FROM riccaboni.t08_names_allclasses_us_mob_allteam a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Mobile_Classes_allteam_us.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*

Query OK, 877722 rows affected (15,84 sec)

*/
