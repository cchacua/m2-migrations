--- Metropolitan areas
-- Table at least one inventor in US, using both criteria, Riccaboni and

DROP TABLE IF EXISTS christian.t08_classes_locboth;
CREATE TABLE christian.t08_classes_locboth AS
SELECT a.*, c.METROID, c.OBJECTID, c.NAME AS maname
  FROM  christian.t08_class_at1us_date_fam a 
  INNER JOIN christian.ric_us_ao_both b ON a.pat=b.pat
  INNER JOIN christian.ric_us_ma c ON a.loc=c.loc;
/*
Query OK, 2094796 rows affected (1 min 46,70 sec)
Records: 2094796  Duplicates: 0  Warnings: 0

Attention: the use of christian.ric_us_ma guarantees that only those that are found on riccaboni are used
*/

SHOW INDEX FROM christian.t08_classes_locboth; 
ALTER TABLE christian.t08_classes_locboth ADD INDEX(pat);

--- Counties
-- Table at least one inventor in US, using both criteria, Riccaboni and

DROP TABLE IF EXISTS christian.t08_classes_locbothcoun;
CREATE TABLE christian.t08_classes_locbothcoun AS
SELECT  a.*, c.HASC_2, c.OBJECTID
  FROM  christian.t08_class_at1us_date_fam a 
  INNER JOIN christian.ric_us_ao_both b ON a.pat=b.pat
  INNER JOIN christian.ric_us_cou c ON a.loc=c.loc;
/*
Query OK, 2828042 rows affected (2 min 21,83 sec)
Records: 2828042  Duplicates: 0  Warnings: 0

Attention: the use of christian.ric_us_cou guarantees that only those that are found on riccaboni are used
*/
SHOW INDEX FROM christian.t08_classes_locbothcoun; 
ALTER TABLE christian.t08_classes_locbothcoun ADD INDEX(pat);


--- States
-- Table at least one inventor in US, using both criteria, Riccaboni and

DROP TABLE IF EXISTS christian.t08_classes_locbothstates;
CREATE TABLE christian.t08_classes_locbothstates AS
SELECT  a.*, c.HASC_1, c.OBJECTID
  FROM  christian.t08_class_at1us_date_fam a 
  INNER JOIN christian.ric_us_ao_both b ON a.pat=b.pat
  INNER JOIN christian.ric_us_states c ON a.loc=c.loc;
/*
Query OK, 2828042 rows affected (2 min 17,89 sec)
Records: 2828042  Duplicates: 0  Warnings: 0

Attention: the use of christian.ric_us_cou guarantees that only those that are found on riccaboni are used
*/

SHOW INDEX FROM christian.t08_classes_locbothstates; 
ALTER TABLE christian.t08_classes_locbothstates ADD INDEX(pat);




----------------------------
SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_allclasses_t01_loc_allteam a;
SELECT COUNT(*) FROM riccaboni.t08_allclasses_t01_loc_allteam;     

