---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH ALL NAMES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     

---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_allclasses;
CREATE TABLE riccaboni.t08_names_allclasses AS
SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat;
/*
Query OK, 7.652.380 rows affected (5 min 49,21 sec)
Records: 7652380  Duplicates: 0  Warnings: 0
*/

---------------------------------------------------------------------------------------------------
-- Countings
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses a;
/*
+------------------------+
| COUNT(DISTINCT a.name) |
+------------------------+
|                2005599 |
+------------------------+
1 row in set (19,49 sec)

+-------------------------------+
| COUNT(DISTINCT UPPER(a.name)) |
+-------------------------------+
|                       2005599 |
+-------------------------------+
1 row in set (22,22 sec)


*/


SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|              1.710.247 |
+----------------------+
1 row in set (15,62 sec)
*/


SELECT COUNT(DISTINCT a.ID, UPPER(a.name))       
      FROM riccaboni.t08_names_allclasses a;
/*
+------------------------------+
| COUNT(DISTINCT a.ID, a.name) |
+------------------------------+
|                      2365662 |
+------------------------------+
1 row in set (22,45 sec)
+-------------------------------------+
| COUNT(DISTINCT a.ID, UPPER(a.name)) |
+-------------------------------------+
|                             2365662 |
+-------------------------------------+
1 row in set (27,68 sec)

*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------
      
SELECT DISTINCT a.ID, a.name       
      FROM riccaboni.t08_names_allclasses a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*
Query OK, 2365662 rows affected (41,79 sec)
*/            