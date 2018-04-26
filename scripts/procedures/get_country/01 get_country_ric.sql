---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES AND ALL COUNTRIES
-- riccaboni.t08_names_allclasses_t01
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;
ALTER TABLE riccaboni.t08 ADD INDEX(pat);
ALTER TABLE riccaboni.t08 ADD INDEX(ID);
                                     
SHOW INDEX FROM riccaboni.t01_allclasses; 

---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01;
CREATE TABLE riccaboni.t08_names_allclasses_t01 AS
SELECT b.ID, b.pat, b.name, b.loc, b.qual, b.loctype
      FROM riccaboni.t01_allclasses a 
      INNER JOIN riccaboni.t08 b
      ON a.pat=b.pat;

/*
Query OK, 7.652.380 rows affected (2 min 51,85 sec)
Records: 7652380  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_t01;                                     
ALTER TABLE riccaboni.t08_names_allclasses_t01 ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_t01 ADD INDEX(pat);

SELECT * FROM riccaboni.t08_names_allclasses_t01 LIMIT 0,10;
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNT NUMBER OF DIFFERENT INVENTORS AND IDS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


SELECT COUNT(DISTINCT a.ID) FROM riccaboni.t08_names_allclasses_t01 a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|              1710247 |
+----------------------+
1 row in set (18,26 sec)

So, all the inventors who have at least one patent are 1.710.247 
*/


SELECT COUNT(DISTINCT a.name) FROM riccaboni.t08_names_allclasses_t01 a;
/*
+------------------------+
| COUNT(DISTINCT a.name) |
+------------------------+
|                2005599 |
+------------------------+
1 row in set (57,21 sec)
*/


SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_names_allclasses_t01 a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2434318 |
+-----------------------+
1 row in set (25,47 sec)

*/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- SELECT ONLY DIFFERENT COORDINATES OF ALL INVENTORS' ADDRESS
-- AFTER THIS, THE R file should be run as to know if the point is inside the US polygon
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT a.loc) FROM riccaboni.t08_names_allclasses_t01 a;
/*
+-----------------------+
| COUNT(DISTINCT a.loc) |
+-----------------------+
|                786305 |
+-----------------------+
1 row in set (12,97 sec)

*/

SELECT DISTINCT a.loc 
  FROM riccaboni.t08_names_allclasses_t01 a
  INTO OUTFILE '/var/lib/mysql-files/Distinct_locations_allclasses.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';

/*
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TO MAKE TEST OF THE COORDINATES: A file that we know for sure that are inventors comming from the US
-- ATTENTION: THIS REQUIRES FROM TABLE riccaboni.t01_allclasses_appid_patstat_us_allteam
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses_appid_patstat_us_allteam b 
      INNER JOIN riccaboni.t08_names_allclasses_t01 a
      ON b.pat=a.pat
      LIMIT 0,10000
      INTO OUTFILE '/var/lib/mysql-files/t08_allusa_test.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';

*/


