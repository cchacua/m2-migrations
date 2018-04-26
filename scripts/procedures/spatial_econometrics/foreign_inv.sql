---------------------------------------------------------------------------------------------------
-- 1 - Table with coordinate points of non-celtic
-- using christian.t08_class_at1us_date_fam_nceltic : T08 No-Celtic rows, all team members are US residents
-- Also, use riccaboni.t08_allclasses_t01_loc_allteam to validate address using coordinates
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic; 
SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc_allteam; 

SELECT count(DISTINCT a.loc) FROM christian.t08_class_at1us_date_fam_nceltic a INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat;
/*
+-----------------------+
| count(DISTINCT a.loc) |
+-----------------------+
|                127918 |
+-----------------------+
1 row in set (10,58 sec)

*/

---------------------------------------------------------------------------------------------------
-- 2 - Merge table with state names
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic; 


DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc AS
SELECT a.*, c.METRO, c.OBJECTID, c.NAME AS maname
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*
Query OK, 863337 rows affected (43,70 sec)
Records: 863337  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(METRO);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID, METRO);

SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic_loc a LIMIT 0,10;

-- Assign only one county by inventor, and split the sample by field. Select only patents with teams of inventors, all living in the US, according to two criteria: patstat, Riccaboni (regpat and li)

DROP TABLE IF EXISTS christian.nceltic_state_g;
CREATE TABLE christian.nceltic_state_g AS
SELECT a.finalID, a.METRO, COUNT(DISTINCT a.EARLIEST_FILING_YEAR) AS nyears 
FROM christian.t08_class_at1us_date_fam_nceltic_loc a
GROUP BY a.finalID, a.METRO;
/*
Query OK, 200701 rows affected (19,46 sec)
Records: 200701  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nceltic_state_g; 
ALTER TABLE christian.nceltic_state_g ADD INDEX(finalID);
ALTER TABLE christian.nceltic_state_g ADD INDEX(nyears);

SELECT * FROM christian.nceltic_state_g LIMIT 0,100;
SELECT COUNT(DISTINCT a.finalID) FROM christian.nceltic_state_g a;
/*
+---------------------------+
| COUNT(DISTINCT a.finalID) |
+---------------------------+
|                    242003 |
+---------------------------+
1 row in set (0,23 sec)
*/

DROP TABLE IF EXISTS christian.nceltic_state_g2;
CREATE TABLE christian.nceltic_state_g2 AS
SELECT a.finalID, a.METRO, a.nyears 
FROM christian.nceltic_state_g a
WHERE a.nyears=(SELECT MAX(b.nyears) FROM christian.nceltic_state_g b WHERE b.finalID=a.finalID);
/*
Query OK, 253738 rows affected (6,01 sec)
Records: 253738  Duplicates: 0  Warnings: 0
*/
SELECT * FROM christian.nceltic_state_g2 LIMIT 0,100;
SELECT COUNT(DISTINCT a.finalID) FROM christian.nceltic_state_g2 a;



-- Collapse by state and compute the number of inventors



