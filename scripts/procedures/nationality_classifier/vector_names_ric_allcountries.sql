

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE ID, NAME WHITHOUT MOBIITY INVENTOR LINK FOR ALL INVENTORS IN THE CLASSES: riccaboni.t08_names_allclasses
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_ALL_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*
Query OK, 2365662 rows affected (41,79 sec)
*/     

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE ID, NAME AND MOBIITY INVENTOR LINK FOR ALL INVENTORS IN THE CLASSES: riccaboni.t08_names_allclasses_t01_t09
-- THIS IS BETTER THAN THE PREVIOUS TABLE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t09;                                     
ALTER TABLE riccaboni.t09 ADD INDEX(localID);

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_t01_t09_onlynames;
CREATE TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames AS
SELECT DISTINCT a.ID, b.mobileID, IFNULL(b.mobileID, a.ID) AS finalID, a.name
      FROM riccaboni.t08_names_allclasses_t01 a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID;

/*
Query OK, 2365662 rows affected (3 min 46,00 sec)
Records: 2365662  Duplicates: 0  Warnings: 0

*/

SELECT COUNT(DISTINCT a.name, a.finalID) FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a;
/*
+-----------------------------------+
| COUNT(DISTINCT a.name, a.finalID) |
+-----------------------------------+
|                           2181115 |
+-----------------------------------+
1 row in set (14,77 sec)

*/


SELECT COUNT(DISTINCT a.finalID) FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                   1511776 |
+---------------------------+
1 row in set (5,36 sec)

2181115 vs 1511776, so there are 669.339 rows to delete
*/

SELECT COUNT(DISTINCT a.name) FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a;

SELECT COUNT(DISTINCT a.name, a.ID) FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a;




