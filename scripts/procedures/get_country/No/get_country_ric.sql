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
Query OK, 7.652.380 rows affected (5 min 49,21 sec)
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
1 row in set (13,42 sec)
*/

SELECT DISTINCT a.loc 
  FROM riccaboni.t08_names_allclasses_t01 a
  INTO OUTFILE '/var/lib/mysql-files/Distinct_locations_allclasses.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
