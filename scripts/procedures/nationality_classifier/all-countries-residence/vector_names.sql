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