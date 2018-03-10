---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- LIST OF ALL NAMES AND IDS CONTAINED IN T08, FOR ALL THE PATENTS (NOT ONLY THE TWO CLASSES THAT ARE CONSIDERED HERE)
-- FINAL TABLE (WITH MOBILITY LINKS): riccaboni.t08_id_name_allt08_mob
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t08_id_name_allt08;
CREATE TABLE riccaboni.t08_id_name_allt08 AS
SELECT DISTINCT a.ID, a.name
      FROM riccaboni.t08 a;
/*
Query OK, 7190067 rows affected (2 min 51,95 sec)
Records: 7190067  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_id_name_allt08; 
ALTER TABLE riccaboni.t08_id_name_allt08 ADD INDEX(ID);

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_id_name_allt08 a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|              5.160.210 |
+----------------------+
1 row in set (5,30 sec)
*/




DROP TABLE IF EXISTS riccaboni.t08_id_name_allt08_mob;
CREATE TABLE riccaboni.t08_id_name_allt08_mob AS
SELECT DISTINCT a.ID, c.mobileID, IFNULL(c.mobileID, a.ID) AS finalID, a.name
      FROM riccaboni.t08_id_name_allt08 a
      LEFT JOIN riccaboni.t09 c
      ON a.ID=c.localID;



--- test
select * from riccaboni.t08 where ID='LI4011537';

SELECT * FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.INVT_SEQ_NR>'0' AND a.pat='WO2002004023';
 
SELECT * FROM riccaboni.t08 a WHERE a.pat='WO2002004023';
SELECT * FROM riccaboni.t01 a WHERE a.pat='WO2002004023';
