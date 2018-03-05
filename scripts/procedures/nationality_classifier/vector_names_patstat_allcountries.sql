---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE PATENTS AND INVENTORS THAT CAN BE FOUND IN PATSTAT
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
-- ONLY PATSTAT: patstat2016b.TLS207_PERS_APPLN_allclasses_onlynames
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat;                                     

SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN;                                     

SHOW INDEX FROM patstat2016b.TLS906_PERSON;                                     
ALTER TABLE patstat2016b.TLS906_PERSON ADD INDEX(PERSON_ID);
/*
Query OK, 53295057 rows affected (5 min 30,49 sec)
Records: 53295057  Duplicates: 0  Warnings: 0
*/


DROP TABLE IF EXISTS patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat;
CREATE TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat AS
SELECT DISTINCT a.*, b.APPLT_SEQ_NR, b.INVT_SEQ_NR, c.*
      FROM riccaboni.t01_allclasses_appid_patstat a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN b
      ON a.APPLN_ID=b.APPLN_ID
      INNER JOIN patstat2016b.TLS906_PERSON c
      ON b.PERSON_ID=c.PERSON_ID;
/*
Query OK, 9329333 rows affected (12 min 22,02 sec)
Records: 9329333  Duplicates: 0  Warnings: 0
*/


SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat;     
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(pat);
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(APPLN_ID);
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat ADD INDEX(PERSON_ID);


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
-- VERIFICATION: WHY ARE THERE AROUND 9000 MISSING PATENTS
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
    WHERE b.pat IS NULL AND a.localInvs IS NOT NULL AND a.wasComplete='1';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                  8859 |
+-----------------------+
1 row in set (20,88 sec)
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



SELECT `id`, `url`, LENGTH(`url`) - LENGTH(REPLACE(`url`, '/', '')) AS `number` FROM `url`;
