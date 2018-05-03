---------------------------------------------------------------------------------------------------
-- CLASSES
---------------------------------------------------------------------------------------------------

/*
1 - Pharmaceuticals, biotechnology and organic fine chemistry
| Pharmaceuticals                         | 4  |
| Biotechnology                           | 9  |
| Organic fine chemistry                  | 3  |


2 - Computer technology and telecommunications
| Computer technology                     | 13 |
| Telecommunications                      | 29 |

*/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS (General)
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 0 - All
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,4,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,9,%' 
                                     OR CONCAT(',', a.classes, ',') LIKE '%,3,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,13,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,29,%';
                                     
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2443177 |
+-----------------------+
1 row in set (18,60 sec)

*/                                     
---------------------------------------------------------------------------------------------------
-- 1 - Pharmaceuticals, biotechnology and organic fine chemistry
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') REGEXP ',4,|,9,|,3,';

/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1.191.548 |
+-----------------------+
1 row in set (12,47 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,4,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,9,%' 
                                     OR CONCAT(',', a.classes, ',') LIKE '%,3,%';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1191548 |
+-----------------------+
1 row in set (11,40 sec)
*/



---------------------------------------------------------------------------------------------------
-- 2 - Computer technology and telecommunications
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') REGEXP ',13,|,29,';

/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1.258.035 |
+-----------------------+
1 row in set (11,68 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,13,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,29,%';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1258035 |
+-----------------------+
1 row in set (9,75 sec)
*/

---------------------------------------------------------------------------------------------------
-- 3 - Comparison
---------------------------------------------------------------------------------------------------
/* 
0 = 2.443177 
1+2 = 2.449583

So, there are a total of 2443177 different patents, from which 6406 can be classiffied in both categories
*/


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 0 - All
---------------------------------------------------------------------------------------------------
CREATE TABLE riccaboni.t01_allclasses AS
SELECT * FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,4,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,9,%' 
                                     OR CONCAT(',', a.classes, ',') LIKE '%,3,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,13,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,29,%';
SHOW INDEX FROM riccaboni.t01_allclasses;                                     
ALTER TABLE riccaboni.t01_allclasses ADD PRIMARY KEY(pat);
-- ALTER TABLE riccaboni.t01_allclasses DROP PRIMARY KEY, ADD PRIMARY KEY(pat);   
                                 
---------------------------------------------------------------------------------------------------
-- 1 - Pharmaceuticals, biotechnology and organic fine chemistry
---------------------------------------------------------------------------------------------------
CREATE TABLE riccaboni.t01_pboc_class AS
SELECT * FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,4,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,9,%' 
                                     OR CONCAT(',', a.classes, ',') LIKE '%,3,%';


SHOW INDEX FROM riccaboni.t01_pboc_class;                                     
ALTER TABLE riccaboni.t01_pboc_class ADD INDEX(pat); 

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_pboc_class a;
SELECT COUNT(*) FROM riccaboni.t01_pboc_class;
---------------------------------------------------------------------------------------------------
-- 2 - Computer technology and telecommunications
---------------------------------------------------------------------------------------------------
CREATE TABLE riccaboni.t01_ctt_class AS
SELECT * FROM riccaboni.t01 a WHERE CONCAT(',', a.classes, ',') LIKE '%,13,%'
                                     OR CONCAT(',', a.classes, ',') LIKE '%,29,%';

SHOW INDEX FROM riccaboni.t01_ctt_class;                                     
ALTER TABLE riccaboni.t01_ctt_class ADD INDEX(pat);


SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_ctt_class a;
SELECT COUNT(*) FROM riccaboni.t01_ctt_class;                                     
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS (Detailed, by patent office)
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 0 - All
---------------------------------------------------------------------------------------------------

SELECT COUNT(*), LEFT(a.pat,2)
      FROM riccaboni.t01_allclasses a
      GROUP BY LEFT(a.pat,2);    
/*
+----------+---------------+
| COUNT(*) | LEFT(a.pat,2) |
+----------+---------------+
|   705255 | EP            |
|  1044200 | US            |
|   693722 | WO            |
+----------+---------------+
3 rows in set (2,47 sec)
*/      
      
