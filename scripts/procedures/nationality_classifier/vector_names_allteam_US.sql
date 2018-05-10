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
      WHERE a.nation='EastAsian.Chinese' OR a.nation='SouthAsian' OR a.nation='Muslim.Persian' OR a.nation='EastAsian.Japan' OR a.nation='EastAsian.South.Korea' OR a.nation='European.French' OR a.nation='European.German' OR a.nation='European.Italian.Italy' OR a.nation='European.EastEuropean' OR a.nation='European.Russian' OR a.nation='EastAsian.Indochina.Vietnam' OR a.nation='EastAsian.Malay.Indonesia';

/*
Query OK, 885442 rows affected (29,59 sec)
Records: 885442  Duplicates: 0  Warnings: 0
*/

SELECT * FROM christian.t08_class_at1us_date_fam_nceltic LIMIT 0,10;

SHOW INDEX FROM christian.t08_class_at1us_date_fam_nceltic;                                     
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(pat);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(ID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(finalID);
ALTER TABLE christian.t08_class_at1us_date_fam_nceltic ADD INDEX(loc);


SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_nceltic a 
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;
/*
+-----------------------------+---------------------------+
| nation                      | COUNT(DISTINCT a.finalID) |
+-----------------------------+---------------------------+
| European.German             |                     49886 |
| EastAsian.Chinese           |                     44079 |
| SouthAsian                  |                     35796 |
| European.French             |                     22076 |
| European.Italian.Italy      |                      8617 |
| EastAsian.Indochina.Vietnam |                      5068 |
| EastAsian.South.Korea       |                      4876 |
| Muslim.Persian              |                      4158 |
| European.Russian            |                      3945 |
| EastAsian.Malay.Indonesia   |                      3682 |
| EastAsian.Japan             |                      3027 |
| European.EastEuropean       |                      1712 |
+-----------------------------+---------------------------+
12 rows in set (2,84 sec)
*/

DROP TABLE IF EXISTS christian.finalid_10cel_allus;
CREATE TABLE christian.finalid_10cel_allus AS
SELECT DISTINCT a.finalID, a.nation
FROM christian.t08_class_at1us_date_fam_nceltic a;
/*
Query OK, 187.120 rows affected (6,87 sec)
Records: 187120  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.finalid_10cel_allus;                                     
ALTER TABLE christian.finalid_10cel_allus ADD INDEX(finalID);

SELECT COUNT(DISTINCT a.finalID) FROM christian.finalid_10cel_allus a;


DROP TABLE IF EXISTS christian.finalid_cel_allus;
CREATE TABLE christian.finalid_cel_allus AS
SELECT DISTINCT a.finalID, a.nation
FROM christian.t08_class_at1us_date_fam a 
     INNER JOIN christian.ric_us_all_both b
     ON a.pat=b.pat;
/*
Query OK, 558.677 rows affected (43,17 sec)
Records: 558677  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.finalid_cel_allus;                                     
ALTER TABLE christian.finalid_cel_allus ADD INDEX(finalID);

SELECT COUNT(DISTINCT a.finalID) FROM christian.finalid_cel_allus a;


SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_nceltic a 
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';
---------------------------------------------------------------------------------------------------
-- 2- Only pat of patents with at least one non-celtic inventor, when all the inventors are US residents
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS christian.pat_nceltic_allus;
CREATE TABLE christian.pat_nceltic_allus AS
SELECT DISTINCT a.pat, a.APPLN_ID
      FROM christian.t08_class_at1us_date_fam_nceltic a ;
/*
Query OK, 528438 rows affected (7,71 sec)
Records: 528438  Duplicates: 0  Warnings: 0

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
Query OK, 1729886 rows affected (37,71 sec)
Records: 1729886  Duplicates: 0  Warnings: 0
*/

SELECT * FROM christian.t08_class_at1us_date_fam_for LIMIT 0,10;

SHOW INDEX FROM  christian.t08_class_at1us_date_fam_for;                                     
ALTER TABLE  christian.t08_class_at1us_date_fam_for ADD INDEX(pat);
ALTER TABLE  christian.t08_class_at1us_date_fam_for ADD INDEX(finalID);


SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';

