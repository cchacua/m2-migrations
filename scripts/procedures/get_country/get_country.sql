---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- GET ONLY PATENTS IN WHICH AT LEAST ONE AUTHOR COMES FROM THE USA
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN;                                     
--ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD PRIMARY KEY(PERSON_ID, APPLN_ID, APPLT_SEQ_NR, INVT_SEQ_NR);

SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN;                                     
ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD INDEX(PERSON_ID);
/*Query OK, 203539051 rows affected (12 min 31,19 sec)
Records: 203539051  Duplicates: 0  Warnings: 0
*/
ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD INDEX(APPLN_ID);
/*Query OK, 203539051 rows affected (25 min 8,57 sec)
Records: 203539051  Duplicates: 0  Warnings: 0
*/

SHOW INDEXES FROM  riccaboni.t01_allclasses_appid_patstat;   
ALTER TABLE riccaboni.t01_allclasses_appid_patstat ADD INDEX (APPLN_ID);

SHOW INDEX FROM  patstat2016b.TLS206_PERSON;                                     
ALTER TABLE patstat2016b.TLS206_PERSON ADD INDEX(PERSON_ID);

---------------------------------------------------------------------------------------------------
-- APPLN_ID FROM MORRISON THAT CAN BE FOUND IN TLS207
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT c.APPLN_ID) FROM patstat2016b.TLS207_PERS_APPLN c;
/*
+----------------------------+
| COUNT(DISTINCT c.APPLN_ID) |
+----------------------------+
|                   67779569 |
+----------------------------+
1 row in set (4 min 16,26 sec)
*/

SELECT COUNT(DISTINCT a.APPLN_ID)
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID;

/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    2379102 |
+----------------------------+
1 row in set (38,46 sec)

2379102 JOIN vs 2379110 RICPATSTAT, so there are 8 missing patents
*/                 

SELECT COUNT(DISTINCT a.PERSON_ID)
      FROM patstat2016b.TLS206_PERSON a
      WHERE a.PERSON_CTRY_CODE='US';
/*
+-----------------------------+
| COUNT(DISTINCT a.PERSON_ID) |
+-----------------------------+
|                    10188350 |
+-----------------------------+
1 row in set (23,56 sec)
*/

DROP TABLE IF EXISTS patstat2016b.TLS206_PERSON_ALL_US;
CREATE TABLE patstat2016b.TLS206_PERSON_ALL_US AS
SELECT DISTINCT a.PERSON_ID
      FROM patstat2016b.TLS206_PERSON a
      WHERE a.PERSON_CTRY_CODE='US';

SHOW INDEXES FROM  patstat2016b.TLS206_PERSON_ALL_US;   
ALTER TABLE patstat2016b.TLS206_PERSON_ALL_US ADD PRIMARY KEY(PERSON_ID);


SELECT COUNT(DISTINCT b.APPLN_ID)
      FROM patstat2016b.TLS206_PERSON_ALL_US a
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.PERSON_ID = b.PERSON_ID;
/*
+----------------------------+
| COUNT(DISTINCT b.APPLN_ID) |
+----------------------------+
|                   10390263 |
+----------------------------+
1 row in set (2 min 22,03 sec)
*/

-- Final number of patents in WHICH THERE ARE AT LEAST ONE INVENTOR RESIDING IN THE USA

SELECT COUNT(DISTINCT a.APPLN_ID)
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      INNER JOIN patstat2016b.TLS206_PERSON_ALL_US c
      ON b.PERSON_ID=c.PERSON_ID;

/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    1206237 |
+----------------------------+
1 row in set (1 min 45,72 sec)

1.206.237 FINAL_APPLN_ID vs 2379102 JOIN vs 2379110 RICPATSTAT
*/

SELECT COUNT(DISTINCT a.APPLN_ID)
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      INNER JOIN patstat2016b.TLS206_PERSON c
      ON b.PERSON_ID=c.PERSON_ID
      WHERE c.PERSON_CTRY_CODE='US';
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    1206237 |
+----------------------------+
1 row in set (2 min 24,25 sec)
*/

---------------------------------------------------------------------------------------------------
-- Merge and new table
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid_patstat_us;
CREATE TABLE riccaboni.t01_allclasses_appid_patstat_us AS
SELECT DISTINCT a.APPLN_ID
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      INNER JOIN patstat2016b.TLS206_PERSON_ALL_US c
      ON b.PERSON_ID=c.PERSON_ID;
/*
Query OK, 1206237 rows affected (1 min 19,34 sec)
Records: 1206237  Duplicates: 0  Warnings: 0
*/
---------------------------------------------------------------------------------------------------
-- TABLE TO USE: riccaboni.t01_allclasses_appid_patstat_us 
-- IT CONTAINS ONLY THE APPLN_ID OF THE PATENTS THAT CAN BE FOUND IN PATSTAT, THAT BELONG TO THE STUDIED CATEGORIES AND IN WHICH THERE IS AT LEAST ONE INVENTOR RESIDING IN THE USA
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.APPLN_ID) FROM riccaboni.t01_allclasses_appid_patstat_us a;
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    1206237 |
+----------------------------+
1 row in set (2,67 sec)
*/
