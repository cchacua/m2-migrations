---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     
SHOW INDEX FROM riccaboni.t01_allclasses; 
---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01;
CREATE TABLE riccaboni.t08_names_allclasses_t01 AS
SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat;
/*
Query OK, 7.652.380 rows affected (3 min 9,94 sec)
Records: 7652380  Duplicates: 0  Warnings: 0

*/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- SELECT ONLY COORDINATES
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


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TO MAKE TEST
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses_appid_patstat_us_allteam b 
      INNER JOIN riccaboni.t08_names_allclasses_t01 a
      ON b.pat=a.pat
      LIMIT 0,1000
INTO OUTFILE '/var/lib/mysql-files/t08_allusa_test.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';




