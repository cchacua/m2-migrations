---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- GET ONLY PATENTS IN WHICH AT LEAST ONE AUTHOR COMES FROM THE USA, USING PATSTAT
-- This requires the execution of file 04, to get table patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat 

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

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



SELECT DISTINCT a.APPLN_ID, a.pat
      FROM riccaboni.t01_allclasses_appid_patstat a 
      LEFT JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      WHERE b.APPLN_ID IS NULL;
/*
+----------+--------------+
| APPLN_ID | pat          |
+----------+--------------+
| 47180883 | WO1992014404 |
| 51228974 | US04981859   |
| 57899532 | WO2009088183 |
| 57899536 | WO2009088216 |
| 58044509 | WO2009096677 |
| 58044516 | WO2009096710 |
| 58044519 | WO2009096734 |
| 58044520 | WO2009096735 |
+----------+--------------+
8 rows in set (21,66 sec)

*/


-- Number of patents in which at least one of the applicants or the inventors resides in the US
SELECT COUNT(DISTINCT a.APPLN_ID) FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.PERSON_CTRY_CODE='US';
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    1206237 |
+----------------------------+
1 row in set (18,55 sec)
*/

-- Number or patents in which at least one of the inventors resides in the US
SELECT COUNT(DISTINCT a.APPLN_ID) FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.PERSON_CTRY_CODE='US' AND a.INVT_SEQ_NR>'0';
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    1067135 |
+----------------------------+
1 row in set (12,47 sec)
*/

---------------------------------------------------------------------------------------------------
-- Merge and new table: riccaboni.t01_allclasses_appid_patstat_us_atleastone
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid_patstat_us_atleastone;
CREATE TABLE riccaboni.t01_allclasses_appid_patstat_us_atleastone AS
SELECT DISTINCT a.pat, a.APPLN_ID FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.PERSON_CTRY_CODE='US' AND a.INVT_SEQ_NR>'0';

/*
Query OK, 1067135 rows affected (35,86 sec)
Records: 1067135  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone;                                     
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us_atleastone ADD INDEX(pat);
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us_atleastone ADD INDEX(APPLN_ID);
---------------------------------------------------------------------------------------------------
-- TABLE TO USE: riccaboni.t01_allclasses_appid_patstat_us_atleastone
-- IT CONTAINS ONLY THE APPLN_ID and the pat OF THE PATENTS THAT CAN BE FOUND IN PATSTAT, THAT BELONG TO THE STUDIED CATEGORIES AND IN WHICH THERE IS AT LEAST ONE INVENTOR RESIDING IN THE USA
---------------------------------------------------------------------------------------------------


SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone;
SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat;

-- Number or different names in which at least one of the inventors resides in the US
SELECT COUNT(DISTINCT a.PERSON_NAME) 
FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a 
INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b 
ON a.pat=b.pat WHERE a.INVT_SEQ_NR>'0';
/*
+-------------------------------+
| COUNT(DISTINCT a.PERSON_NAME) |
+-------------------------------+
|                        893665 |
+-------------------------------+
1 row in set (1 min 38,38 sec)
*/

SELECT COUNT(DISTINCT a.PSN_NAME)
FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a 
INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b 
ON a.pat=b.pat WHERE a.INVT_SEQ_NR>'0';
/*
+----------------------------+
| COUNT(DISTINCT a.PSN_NAME) |
+----------------------------+
|                     900849 |
+----------------------------+
1 row in set (2 min 2,67 sec)

*/
SELECT COUNT(DISTINCT a.HAN_NAME)
FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a 
INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b 
ON a.pat=b.pat WHERE a.INVT_SEQ_NR>'0';
/*
+----------------------------+
| COUNT(DISTINCT a.HAN_NAME) |
+----------------------------+
|                     898488 |
+----------------------------+
1 row in set (1 min 51,22 sec)


*/





