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
-- 2 - Merge table with Metropolitan area names
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic; 

-- Both classes
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc AS
SELECT a.*, c.METRO, c.OBJECTID, c.NAME AS maname
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*

Query OK, 863337 rows affected (39,99 sec)
Records: 863337  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(METRO);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID, METRO);


-- Pboc class
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc_pboc;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc_pboc AS
SELECT a.*, c.METRO, c.OBJECTID, c.NAME AS maname
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*
Query OK, 417269 rows affected (39,44 sec)
Records: 417269  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc_pboc; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_pboc ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_pboc ADD INDEX(METRO);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_pboc ADD INDEX(finalID, METRO);

SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic_loc_pboc a LIMIT 0,10;


-- ctt class
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc_ctt;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc_ctt AS
SELECT a.*, c.METRO, c.OBJECTID, c.NAME AS maname
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN riccaboni.t01_ctt_class d ON a.pat=d.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*
Query OK, 449590 rows affected (42,80 sec)
Records: 449590  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc_ctt; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_ctt ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_ctt ADD INDEX(METRO);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc_ctt ADD INDEX(finalID, METRO);

SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic_loc_ctt a LIMIT 0,10;

---------------------------------------------------------------------------------------------------
-- 3 - Assign only one county by inventor
---------------------------------------------------------------------------------------------------

-- Assign only one county by inventor, and split the sample by field. Select only patents with teams of inventors, all living in the US, according to two criteria: patstat, Riccaboni (regpat and li)

-- Pboc class

DROP TABLE IF EXISTS christian.nceltic_state_g_pboc;
CREATE TABLE christian.nceltic_state_g_pboc AS
SELECT a.finalID, a.METRO, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
FROM christian.t08_class_at1us_date_fam_nceltic_loc a
INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
GROUP BY a.finalID, a.METRO, a.EARLIEST_FILING_YEAR;
/*
Query OK, 162066 rows affected (2,66 sec)
Records: 162066  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nceltic_state_g_pboc; 
ALTER TABLE christian.nceltic_state_g_pboc ADD INDEX(finalID);
ALTER TABLE christian.nceltic_state_g_pboc ADD INDEX(nloc);

SELECT * FROM christian.nceltic_state_g_pboc LIMIT 0,100;
SELECT COUNT(DISTINCT a.finalID, a.EARLIEST_FILING_YEAR) FROM christian.nceltic_state_g_pboc a;
/*
+---------------------------------------------------+
| COUNT(DISTINCT a.finalID, a.EARLIEST_FILING_YEAR) |
+---------------------------------------------------+
|                                            158147 |
+---------------------------------------------------+
1 row in set (0,38 sec)

162066-158147= 3919 repeated rows
*/

-- ctt class

DROP TABLE IF EXISTS christian.nceltic_state_g_ctt;
CREATE TABLE christian.nceltic_state_g_ctt AS
SELECT a.finalID, a.METRO, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
FROM christian.t08_class_at1us_date_fam_nceltic_loc_ctt a
GROUP BY a.finalID, a.METRO, a.EARLIEST_FILING_YEAR;
/*
Query OK, 210561 rows affected (2,94 sec)
Records: 210561  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nceltic_state_g_ctt; 
ALTER TABLE christian.nceltic_state_g_ctt ADD INDEX(finalID);
ALTER TABLE christian.nceltic_state_g_ctt ADD INDEX(nloc);

SELECT * FROM christian.nceltic_state_g_ctt LIMIT 0,100;
SELECT COUNT(DISTINCT a.finalID, a.EARLIEST_FILING_YEAR) FROM christian.nceltic_state_g_ctt a;
/*
+---------------------------------------------------+
| COUNT(DISTINCT a.finalID, a.EARLIEST_FILING_YEAR) |
+---------------------------------------------------+
|                                            208116 |
+---------------------------------------------------+
1 row in set (0,54 sec)

210561-208116= 2445 repeated rows
*/






---------------------------------------------------------------------
--- This does not work well
DROP TABLE IF EXISTS christian.nceltic_state_g2_pboc;
CREATE TABLE christian.nceltic_state_g2_pboc AS
SELECT a.finalID, a.METRO, a.EARLIEST_FILING_YEAR, a.nloc 
FROM christian.nceltic_state_g_pboc a
WHERE a.nloc=(SELECT MAX(b.nloc) FROM christian.nceltic_state_g_pboc b WHERE b.finalID=a.finalID);
/*
Query OK, 253738 rows affected (6,01 sec)
Records: 253738  Duplicates: 0  Warnings: 0
*/
SELECT * FROM christian.nceltic_state_g2_pboc LIMIT 0,100;
SELECT COUNT(DISTINCT a.finalID) FROM christian.nceltic_state_g2_pboc a;



-- Collapse by state and compute the number of inventors



