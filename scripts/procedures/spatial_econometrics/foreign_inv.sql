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

-- TO DO: EXTRACT ALL COORDINATES, NOT ONLY OF NON-CELTIC INVENTORS AND CREATE A DATABASE OF LOCATIONS IN MA AND ALSO IN COUNTIES AND STATES, SO I CAN USE IT AFTER

---------------------------------------------------------------------------------------------------
-- 2.1 - Merge table with Metropolitan area names
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic; 
SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc_allteam; 
SHOW INDEX FROM christian.ric_us_ma; 

-- Both classes
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc AS
SELECT a.*, c.METROID, c.OBJECTID, c.NAME AS maname
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*
Query OK, 863337 rows affected (37,76 sec)
Records: 863337  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(METROID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID, METROID);

SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic_loc a LIMIT 0,10;


---------------------------------------------------------------------------------------------------
-- 2.2 - Merge table with county area names
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic; 
SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc_allteam; 
SHOW INDEX FROM christian.ric_us_ma; 

-- Both classes
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic_loc_cou;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic_loc_cou AS
SELECT a.*, c.HASC_2, c.OBJECTID
  FROM christian.t08_class_at1us_date_fam_nceltic a 
  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
  INNER JOIN christian.ric_us_state c ON a.loc=c.loc;
/*
Query OK, 863337 rows affected (37,76 sec)
Records: 863337  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic_loc; 
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(HASC_2);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic_loc ADD INDEX(finalID, HASC_2);

SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic_loc a LIMIT 0,10;


---------------------------------------------------------------------------------------------------
-- 3 - Assign only one county by inventor
---------------------------------------------------------------------------------------------------

-- Assign only one county by inventor, and split the sample by field. Select only patents with teams of inventors, all living in the US, according to two criteria: patstat, Riccaboni (regpat and li)

-- Pboc class

DROP TABLE IF EXISTS christian.nceltic_state_g_pboc;
CREATE TABLE christian.nceltic_state_g_pboc AS
SELECT a.finalID, a.METROID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
FROM christian.t08_class_at1us_date_fam_nceltic_loc a
INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR;
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
SELECT a.finalID, a.METROID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
FROM christian.t08_class_at1us_date_fam_nceltic_loc a
  INNER JOIN riccaboni.t01_ctt_class d ON a.pat=d.pat
GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR;
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



