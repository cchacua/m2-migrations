---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- GET ONLY PATENTS IN WHICH ALL AUTHORS BELONGING TO A TEAM COME FROM THE USA
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


SHOW INDEX FROM riccaboni.t01_allclasses_us_nonappid;                                     
ALTER TABLE riccaboni.t01_allclasses_us_nonappid ADD INDEX(pat);


---------------------------------------------------------------------------------------------------
-- LI MAIN TABLE ONLY FOR NON_APPLID PATENTS li.invpat_nonappid
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS li.invpat_nonappid;
CREATE TABLE li.invpat_nonappid AS
SELECT b.*, a.* 
    FROM li.invpat a
    INNER JOIN riccaboni.t01_allclasses_us_nonappid b
    ON CONCAT('US', a.Patent)= b.pat;
/*
Query OK, 150833 rows affected (48,82 sec)
Records: 150833  Duplicates: 0  Warnings: 0

*/


-- 
SELECT COUNT(DISTINCT a.pat) FROM li.invpat_nonappid a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 64058 |
+-----------------------+
1 row in set (0,36 sec)

So all 64.058 US patents that were not found in Patstat are found in Li
*/


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- 1. All authors in the studied classes: li.invpat_classes
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS li.invpat_classes;
CREATE TABLE li.invpat_classes AS
SELECT b.*, a.* 
    FROM li.invpat a
    INNER JOIN riccaboni.t01_allclasses b
    ON CONCAT('US', a.Patent)= b.pat;
/*
Query OK, 2712030 rows affected (1 min 33,07 sec)
Records: 2712030  Duplicates: 0  Warnings: 0
*/

SELECT COUNT(DISTINCT a.pat) FROM li.invpat_classes a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               1044200 |
+-----------------------+
1 row in set (10,62 sec)

1044200 vs 1044200, so all US patents are found in Li's database
*/

SELECT COUNT(DISTINCT a.Country) FROM li.invpat_classes a;

SHOW INDEX FROM li.invpat_classes;                                     
ALTER TABLE li.invpat_classes ADD INDEX(pat);

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- 2. At least one patent in the US: li.invpat_classes_atleastone_us
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS li.invpat_classes_atleastone_us;
CREATE TABLE li.invpat_classes_atleastone_us AS
SELECT a.* 
    FROM li.invpat_classes a
    WHERE a.Country='US';
/*
Query OK, 1434515 rows affected (42,87 sec)
Records: 1434515  Duplicates: 0  Warnings: 0
*/

SELECT COUNT(DISTINCT a.pat) FROM li.invpat_classes_atleastone_us a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                598853 |
+-----------------------+
1 row in set (5,60 sec)
*/

SHOW INDEX FROM li.invpat_classes_atleastone_us;                                     
ALTER TABLE li.invpat_classes_atleastone_us ADD INDEX(pat);

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- 3. THEN EXTRACT ALL AUTHORS OF THE PATENTS in which at least one is US resident: li.invpat_classes_atleastone_us
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS li.invpat_classes_atleastone_us_team;
CREATE TABLE li.invpat_classes_atleastone_us_team AS
SELECT DISTINCT a.pat, b.Country
      FROM li.invpat_classes_atleastone_us a 
      INNER JOIN li.invpat_classes b
      ON a.pat=b.pat
      WHERE b.Country!='';
/*
Query OK, 640398 rows affected (54,30 sec)
Records: 640398  Duplicates: 0  Warnings: 0

*/

SELECT * FROM li.invpat_classes_atleastone_us_team LIMIT 0,100;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- 4. THEN COLLAPSE, WHERE THERE IS JUST ONE DIFFERENT NATIONALITY (WHICH IS THE US, BECAUSE OF THE USE OF li.invpat_classes_atleastone_us)
-- TABLE: li.invpat_classes_allteam_us
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS li.invpat_classes_allteam_us ;
CREATE TABLE li.invpat_classes_allteam_us AS
SELECT DISTINCT a.pat, COUNT(a.Country)
      FROM li.invpat_classes_atleastone_us_team a 
      GROUP BY a.pat
      HAVING COUNT(a.Country)=1;
/*
Query OK, 560638 rows affected (10,43 sec)
Records: 560638  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM li.invpat_classes_allteam_us;                                     
ALTER TABLE li.invpat_classes_allteam_us ADD INDEX(pat);


SELECT * FROM li.invpat_classes_allteam_us LIMIT 0,100;

SELECT COUNT(DISTINCT a.pat) FROM li.invpat_classes_allteam_us a;


-- So, the final number of patents in which all the team resides in the USA is 560.638, for the Li database

