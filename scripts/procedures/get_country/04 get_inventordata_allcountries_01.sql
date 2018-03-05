---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE PATENTS AND INVENTORS 
-- 1: Only Patstat and t01
-- 2: Problem that t01 and t08 do not have the same number of patents
-- 3: T01 converted as table similar to T08
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN;                                     
--ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD PRIMARY KEY(PERSON_ID, APPLN_ID, APPLT_SEQ_NR, INVT_SEQ_NR);

SHOW INDEX FROM  patstat2016b.TLS206_PERSON;                                     
ALTER TABLE patstat2016b.TLS206_PERSON ADD INDEX(PERSON_ID);

---------------------------------------------------------------------------------------------------
-- ONLY PATSTAT: patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ATTENTION: THIS TABLE CONTAINS DATA ON APPLICANTS AND INVENTORS
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat;                                     
ALTER TABLE riccaboni.t01_allclasses_appid_patstat ADD INDEX (APPLN_ID);

SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN;                                     
ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD INDEX(PERSON_ID);
/*Query OK, 203539051 rows affected (12 min 31,19 sec)
Records: 203539051  Duplicates: 0  Warnings: 0
*/
ALTER TABLE patstat2016b.TLS207_PERS_APPLN ADD INDEX(APPLN_ID);
/*Query OK, 203539051 rows affected (25 min 8,57 sec)
Records: 203539051  Duplicates: 0  Warnings: 0
*/


SHOW INDEX FROM patstat2016b.TLS906_PERSON;                                     
ALTER TABLE patstat2016b.TLS906_PERSON ADD INDEX(PERSON_ID);
/*
Query OK, 53295057 rows affected (5 min 30,49 sec)
Records: 53295057  Duplicates: 0  Warnings: 0
*/


DROP TABLE IF EXISTS patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat;
CREATE TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat AS
SELECT DISTINCT a.*, b.APPLT_SEQ_NR, b.INVT_SEQ_NR, c.*, CONCAT(a.pat, '_',LPAD(b.INVT_SEQ_NR, 2, '0')) AS patinvid
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      INNER JOIN patstat2016b.TLS906_PERSON c
      ON b.PERSON_ID=c.PERSON_ID;
/*
Query OK, 9329333 rows affected (11 min 13,13 sec)
Records: 9329333  Duplicates: 0  Warnings: 0

*/


SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat;     
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(pat);
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(APPLN_ID);
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(PERSON_ID);
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(patinvid);

SELECT COUNT(DISTINCT a.pat) FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2379102 |
+-----------------------+
1 row in set (26,70 sec)

*/

SELECT COUNT(DISTINCT a.APPLN_ID) FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a;
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    2379102 |
+----------------------------+
1 row in set (23,33 sec)*/


/*
ATTENTION: TO SELECT ONLY INVENTORS: WHERE a.INVT_SEQ_NR>0
*/

---------------------------------------------------------------------------------------------------
-- DIMENSIONS OF THE TABLE EXCLUDING DATA ON APPLICANTS WHERE a.INVT_SEQ_NR>0
---------------------------------------------------------------------------------------------------

SELECT COUNT(*) FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.INVT_SEQ_NR>'0';
/*
+----------+
| COUNT(*) |
+----------+
|  6826872 |
+----------+
1 row in set (9,53 sec)
*/


---------------------------------------------------------------------------------------------------
-- ONLY RICCABONI: riccaboni.t08_allclasses_t09_patstat
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t08;

DROP TABLE IF EXISTS riccaboni.t08_allclasses_t09_patstat;
CREATE TABLE riccaboni.t08_allclasses_t09_patstat AS
SELECT DISTINCT a.ID, b.mobileID, IFNULL(b.mobileID, a.ID) AS finalID, a.pat, a.name, a.loc, a.qual, a.loctype 
      FROM riccaboni.t08 a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat c
      ON a.pat=c.pat
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID;
/*
Query OK, 7467356 rows affected (10 min 41,12 sec)
Records: 7467356  Duplicates: 0  Warnings: 0

*/

SELECT COUNT(DISTINCT a.pat, a.ID) FROM riccaboni.t08_allclasses_t09_patstat a;
/*
+-----------------------------+
| COUNT(DISTINCT a.pat, a.ID) |
+-----------------------------+
|                     6797635 |
+-----------------------------+
1 row in set (30,39 sec)

*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_allclasses_t09_patstat a;
/*
 
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2370257 |
+-----------------------+
1 row in set (24,88 sec)

*/

/*
PROBLEM: THERE ARE LESS PATENTS IN riccaboni.t08_allclasses_t09_patstat THAN IN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat
2379102-2370257=8.845
*/
---------------------------------------------------------------------------------------------------
-- VERIFICATION: WHY ARE THERE AROUND 9000 MISSING PATENTS?
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_names_allclasses_t01 a
    INNER JOIN riccaboni.t01_allclasses_appid_patstat c
    ON a.pat=c.pat;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2370257 |
+-----------------------+
1 row in set (51,20 sec)
*/


SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08 a
    INNER JOIN riccaboni.t01_allclasses_appid_patstat c
    ON a.pat=c.pat;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2370257 |
+-----------------------+
1 row in set (1 min 30,00 sec)*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08 a
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat c
    ON a.pat=c.pat;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2370249 |
+-----------------------+
1 row in set (6 min 4,59 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_names_allclasses_t01 a
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat c
    ON a.pat=c.pat;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2370249 |
+-----------------------+
1 row in set (3 min 3,40 sec)
*/

/*
So, there are patents that are in t01, which are not included in t08, but that are included in patstat. The simple counting confirms that
2443177-2434318=8.859
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01 a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               9290268 |
+-----------------------+
1 row in set (8,47 sec)
*/
SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08 a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               9234879 |
+-----------------------+
1 row in set (17,55 sec)
*/


SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t08_names_allclasses_t01 a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2434318 |
+-----------------------+
1 row in set (25,47 sec)

*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_allclasses a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2443177 |
+-----------------------+
1 row in set (7,71 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_allclasses a WHERE a.wasComplete='0';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 32746 |
+-----------------------+
1 row in set (1,24 sec)
*/


SELECT COUNT(DISTINCT a.pat)
    FROM riccaboni.t01_allclasses a
    LEFT JOIN riccaboni.t08_names_allclasses_t01 b
    ON a.pat=b.pat
    WHERE b.pat IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                  8859 |
+-----------------------+
1 row in set (19,93 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_allclasses a
    LEFT JOIN riccaboni.t08_names_allclasses_t01 b
    ON a.pat=b.pat
    WHERE b.pat IS NULL AND a.localInvs IS NOT NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                  8859 |
+-----------------------+
1 row in set (20,88 sec)
*/

SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_allclasses a
    LEFT JOIN riccaboni.t08_names_allclasses_t01 b
    ON a.pat=b.pat
    WHERE b.pat IS NULL AND a.localInvs IS NOT NULL AND a.wasComplete='1';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                  8838 |
+-----------------------+
1 row in set (32,81 sec)
*/

SELECT a.* FROM riccaboni.t01_allclasses a
    WHERE a.pat='EP0009592';
/*
+-----------+---------+-----------+------+------+---------+-------------+
| pat       | invs    | localInvs | apps | yr   | classes | wasComplete |
+-----------+---------+-----------+------+------+---------+-------------+
| EP0009592 | HM36997 | HI89722   | HA2  | 1979 | 28,29   | 1           |
+-----------+---------+-----------+------+------+---------+-------------+
1 row in set (0,00 sec)
*/

SELECT a.* FROM riccaboni.t08_names_allclasses_t01 a
    WHERE a.pat='EP0009592';

/*
Empty set (0,01 sec)
*/

SELECT a.* FROM riccaboni.t08 a
    WHERE a.pat='EP0009592';
/*
Empty set (0,00 sec)
*/

SELECT a.* FROM riccaboni.t08 a
    WHERE a.ID='HI89722';
/*
+---------+--------------+--------------------------+--------------------+------+---------+
| ID      | pat          | name                     | loc                | qual | loctype |
+---------+--------------+--------------------------+--------------------+------+---------+
| HI89722 | EP0985265    | HAASS, Adolf             | 48.1745,11.38808   |   87 | high    |
| HI89722 | EP0319677    | Haass, Adolf             | 48.051559,11.45803 |   39 | low     |
| HI89722 | EP0319677    | Haass, Adolf             | 48.13545,11.563065 |   39 | low     |
| HI89722 | EP0319727    | Haass, Adolf, Ing.(grad) | 48.051559,11.45803 |   39 | low     |
| HI89722 | EP0319727    | Haass, Adolf, Ing.(grad) | 48.13545,11.563065 |   39 | low     |
| HI89722 | EP0392264    | Haass, Adolf             | 48.051559,11.45803 |   39 | low     |
| HI89722 | EP0392264    | Haass, Adolf             | 48.13545,11.563065 |   39 | low     |
| HI89722 | US03919647   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US03930203   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US03942098   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04012590   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04041239   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04052556   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04086428   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04250459   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04263668   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04370741   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04607146   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US04852082   | HAASS, ADOLF             | 48.13642,11.57755  |   40 | low     |
| HI89722 | US05820081   | HAASS, ADOLF             | 48.136421,11.57755 |   40 | low     |
| HI89722 | US06179105   | HAASS, ADOLF             | 48.136421,11.57755 |   40 | low     |
| HI89722 | WO1998054830 | HAASS, Adolf             | 48.163212,11.40176 |   59 | low     |
+---------+--------------+--------------------------+--------------------+------+---------+
22 rows in set (0,01 sec)

*/

SELECT a.* FROM riccaboni.t11 a
    WHERE a.Pub_number='EP0009592';
/*Empty set (0,56 sec)*/

---------------------------------------------------------------------------------------------------
-- SO IT IS NECESSARY TO CREATE A TABLE SIMILAR TO T08, TO LINK AUTHORS AND PATENTS, BUT USING T01_CLASSES
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE PATENTS AND INVENTORS RICCABONI, USING T01_CLASSES
-- riccaboni.t01_allclasses_as_t08
-- Adapted from: https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 1- Counting number of inventors in each row: number of commas +1
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t01_allclasses_invcounts;
CREATE TABLE riccaboni.t01_allclasses_invcounts AS
SELECT a.*, CHAR_LENGTH(a.localInvs) - CHAR_LENGTH(REPLACE(a.localInvs, ',', '')) AS `localInvscomas`, CHAR_LENGTH(a.invs) - CHAR_LENGTH(REPLACE(a.invs, ',', ''))
AS `invscomas`
 FROM riccaboni.t01_allclasses a;
/*
Query OK, 2443177 rows affected (30,26 sec)
Records: 2443177  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t01_allclasses_invcounts;     
ALTER TABLE riccaboni.t01_allclasses_invcounts ADD INDEX(localInvscomas);
ALTER TABLE riccaboni.t01_allclasses_invcounts ADD INDEX(pat);

-- The number of localInvs and invs is not the same
SELECT a.pat, a.invs, a.localInvs, NULLIF(a.localInvscomas, a.invscomas) AS notequal FROM riccaboni.t01_allclasses_invcounts a WHERE NULLIF(a.localInvscomas, a.invscomas) IS NOT NULL LIMIT 0,100;

-- But as a fact, the number of localInvscomas is always bigger than invscomas, so the table will be build using the number of local inventors
SELECT a.pat, a.invs, a.localInvs, a.localInvscomas, a.invscomas FROM riccaboni.t01_allclasses_invcounts a WHERE a.localInvscomas<a.invscomas;

SELECT DISTINCT a.localInvscomas, COUNT(a.localInvscomas) FROM riccaboni.t01_allclasses_invcounts a GROUP BY a.localInvscomas;
/*
+----------------+-------------------------+
| localInvscomas | COUNT(a.localInvscomas) |
+----------------+-------------------------+
|              0 |                  682973 |
|              1 |                  631609 |
|              2 |                  463397 |
|              3 |                  286878 |
|              4 |                  159105 |
|              5 |                   89623 |
|              6 |                   49654 |
|              7 |                   29302 |
|              8 |                   17392 |
|              9 |                   10937 |
|             10 |                    6840 |
|             11 |                    4602 |
|             12 |                    2987 |
|             13 |                    2038 |
|             14 |                    1562 |
|             15 |                     954 |
|             16 |                     731 |
|             17 |                     566 |
|             18 |                     465 |
|             19 |                     283 |
|             20 |                     244 |
|             21 |                     201 |
|             22 |                     129 |
|             23 |                      97 |
|             24 |                      90 |
|             25 |                      60 |
|             26 |                      78 |
|             27 |                      69 |
|             28 |                      76 |
|             29 |                      39 |
|             30 |                      18 |
|             31 |                      16 |
|             32 |                      22 |
|             33 |                      24 |
|             34 |                      16 |
|             35 |                      12 |
|             36 |                       9 |
|             37 |                       5 |
|             38 |                       7 |
|             39 |                      14 |
|             40 |                       6 |
|             41 |                       6 |
|             42 |                       7 |
|             43 |                       2 |
|             45 |                       3 |
|             46 |                       2 |
|             47 |                       2 |
|             48 |                       9 |
|             49 |                       3 |
|             50 |                       3 |
|             52 |                       2 |
|             53 |                       4 |
|             59 |                       1 |
|             75 |                       1 |
|             98 |                       2 |
+----------------+-------------------------+
55 rows in set (2,45 sec)
*/

---------------------------------------------------------------------------------------------------
-- 2 - Create a table with the number of inventors (fields)
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.numbers_0_100;
CREATE TABLE riccaboni.numbers_0_100 AS
SELECT (t*10+u+1) AS n, (t*10+u) AS nminusone  from
(select 0 t union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) A,
(select 0 u union select 1 union select 2 union select 3 union select 4 union
select 5 union select 6 union select 7 union select 8 union select 9) B
order by n;

SELECT a.* FROM riccaboni.numbers_0_100 a;

SHOW INDEX FROM riccaboni.numbers_0_100;     
ALTER TABLE riccaboni.numbers_0_100 ADD INDEX(n);
ALTER TABLE riccaboni.numbers_0_100 ADD INDEX(nminusone);
---------------------------------------------------------------------------------------------------
-- 3 - Create new table with csv column as rows: riccaboni.t01_allclasses_as_t08
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_as_t08;
CREATE TABLE riccaboni.t01_allclasses_as_t08 AS
SELECT
  b.pat,
  SUBSTRING_INDEX(SUBSTRING_INDEX(b.localInvs, ',', a.n), ',', -1) AS localInventor, a.n, CONCAT(b.pat, '_',LPAD(a.n, 2, '0')) AS patinvid  
  FROM riccaboni.numbers_0_100 a
  INNER JOIN riccaboni.t01_allclasses_invcounts b
  ON b.localInvscomas>=a.nminusone
ORDER BY
  patinvid;

/*
Query OK, 6972318 rows affected (2 min 9,89 sec)
Records: 6972318  Duplicates: 0  Warnings: 0

So, this table has more combinations (pat localID) than t08
6797635 from t08_allclasses vs 6972318 now
*/

SHOW INDEX FROM riccaboni.t01_allclasses_as_t08;     
ALTER TABLE riccaboni.t01_allclasses_as_t08 ADD INDEX(patinvid);
ALTER TABLE riccaboni.t01_allclasses_as_t08 ADD INDEX(pat);

-- TO verify the number of rows: 
SELECT SUM(a.localInvscomas+1) from riccaboni.t01_allclasses_invcounts a;
/*
+-------------------------+
| SUM(a.localInvscomas+1) |
+-------------------------+
|                 6972318 |
+-------------------------+
1 row in set (1,47 sec)
*/
SELECT SUM(a.localInvscomas) from riccaboni.t01_allclasses_invcounts a;
/*
+-----------------------+
| SUM(a.localInvscomas) |
+-----------------------+
|               4529141 |
+-----------------------+
1 row in set (1,28 sec)
*/


SELECT COUNT(DISTINCT a.pat) FROM riccaboni.t01_allclasses_as_t08 a;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2443177 |
+-----------------------+
1 row in set (21,23 sec)
*/

SELECT * FROM riccaboni.t01_allclasses_as_t08 LIMIT 0,100;
