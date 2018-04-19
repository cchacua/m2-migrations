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
-- 1 - T08 No-Celtic rows, all team members are US residents
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_nceltic;
CREATE TABLE christian.t08_class_at1us_date_fam_nceltic AS
SELECT a.*
      FROM christian.t08_class_at1us_date_fam a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_allteam b
      ON a.pat=b.pat
      WHERE a.nation!='CelticEnglish';

/*

Query OK, 1171779 rows affected (41,08 sec)
Records: 1171779  Duplicates: 0  Warnings: 0
*/

SELECT * FROM christian.t08_class_at1us_date_fam_nceltic LIMIT 0,10;

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic;                                     
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(ID);

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
-- 3 - T08 rows, if at least one member is non-celtic, all team members are US residents
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS christian.t08_class_at1us_date_fam_for;
CREATE TABLE christian.t08_class_at1us_date_fam_for AS
SELECT a.*
      FROM christian.t08_class_at1us_date_fam a 
      INNER JOIN christian.pat_nceltic_allus b
      ON a.pat=b.pat;

/*
Query OK, 2036168 rows affected (50,10 sec)
Records: 2036168  Duplicates: 0  Warnings: 0
*/


