--------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE T08 EXTENDED, ONLY PATENTS WHERE ALL THE INVENTORS LIVE IN THE US, AND THERE IS AT LEAST ONE OF NON-CELTIC ORIGIN
-- FINAL TABLE: christian.t08_class_at1us_date_fam_for

-- ATTENTION: THIS REQUIRES: vector_names_atleastone_US
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.t08_class_at1us_date_fam;                                     
SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_allteam;  


---------------------------------------------------------------------------------------------------
-- 1 - T08 No-Celtic rows OF THE TEN CEL GROUPS, all team members are US residents IN BOTH PATSTAT AND RICCABONI
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic AS
SELECT a.*
      FROM christian.t08_class_at1us_date_fam a 
      INNER JOIN christian.ric_us_all_both b
      ON a.pat=b.pat
      WHERE a.nation='EastAsian.Chinese' OR a.nation='SouthAsian' OR a.nation='Muslim.Persian' OR a.nation='EastAsian.Japan' OR a.nation='EastAsian.South.Korea' OR a.nation='European.French' OR a.nation='European.German' OR a.nation='European.Italian.Italy' OR a.nation='European.EastEuropean' OR a.nation='European.Russian';

/*
Query OK, 884669 rows affected (26,91 sec)
Records: 884669  Duplicates: 0  Warnings: 0
*/

SELECT * FROM christian.t08_class_at1us_date_fam_nceltic LIMIT 0,10;

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic;                                     
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(ID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(loc);
---------------------------------------------------------------------------------------------------
-- 2- Only pat of patents with at least one non-celtic inventor, when all the inventors are US residents
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS christian.pat_nceltic_allus;
CREATE TABLE christian.pat_nceltic_allus AS
SELECT DISTINCT a.pat, a.APPLN_ID
      FROM christian.t08_class_at1us_date_fam_nceltic a ;
/*
Query OK, 638801 rows affected (9,62 sec)
Records: 638801  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  christian.pat_nceltic_allus;                                     
ALTER TABLE  christian.pat_nceltic_allus ADD INDEX(pat);
ALTER TABLE  christian.pat_nceltic_allus ADD INDEX(APPLN_ID);

---------------------------------------------------------------------------------------------------
-- 3 - T08 rows, if at least one member belong to the 10 CEL GROUPS, all team members are US residents
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_for;
CREATE TABLE christian.t08_class_at1us_date_fam_for AS
SELECT a.*
      FROM christian.t08_class_at1us_date_fam a 
      INNER JOIN christian.pat_nceltic_allus b
      ON a.pat=b.pat;

/*
Query OK, 1695713 rows affected (36,27 sec)
Records: 1695713  Duplicates: 0  Warnings: 0
*/

SELECT * FROM christian.t08_class_at1us_date_fam_for LIMIT 0,10;

SHOW INDEX FROM  christian.t08_class_at1us_date_fam_for;                                     
ALTER TABLE  christian.t08_class_at1us_date_fam_for ADD INDEX(pat);
ALTER TABLE  christian.t08_class_at1us_date_fam_for ADD INDEX(finalID);

