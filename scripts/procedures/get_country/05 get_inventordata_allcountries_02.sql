---------------------------------------------------------------------------------------------------
-- TABLES OF PATENTS AND NUMBER OF INVENTORS
---------------------------------------------------------------------------------------------------

-- USING T01 AS T08 RICCABONI
DROP TABLE IF EXISTS riccaboni.t01_allclasses_as_t08_pat_inv_counts;
CREATE TABLE riccaboni.t01_allclasses_as_t08_pat_inv_counts AS
SELECT c.pat, MAX(c.n) AS n FROM riccaboni.t01_allclasses_as_t08 c
    GROUP BY c.pat;
/*
Query OK, 2443177 rows affected (1 min 15,51 sec)
Records: 2443177  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts;
ALTER TABLE riccaboni.t01_allclasses_as_t08_pat_inv_counts ADD INDEX(pat);

-- USING THE MERGE OF PATSTAT
DROP TABLE IF EXISTS patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts;
CREATE TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts AS
SELECT c.pat, MAX(c.INVT_SEQ_NR) AS n FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat c WHERE c.INVT_SEQ_NR>'0'
    GROUP BY c.pat;
/*
Query OK, 2378310 rows affected (2 min 33,83 sec)
Records: 2378310  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts;
ALTER TABLE patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts ADD INDEX(pat);

--USING T08
DROP TABLE IF EXISTS riccaboni.t08_allclasses_t09_patstat_pat_inv_counts;
CREATE TABLE riccaboni.t08_allclasses_t09_patstat_pat_inv_counts AS
SELECT a.pat, COUNT(DISTINCT CONCAT(a.pat, a.ID)) AS n FROM riccaboni.t08_allclasses_t09_patstat a GROUP BY a.pat;

/*
Query OK, 2370257 rows affected (34,59 sec)
Records: 2370257  Duplicates: 0  Warnings: 0

-- OTHER ALTERNATIVE IS TO USE:
DROP TABLE IF EXISTS riccaboni.t08_allclasses_t09_patstat_pat_inv_counts_temp;
CREATE TABLE riccaboni.t08_allclasses_t09_patstat_pat_inv_counts_temp AS
SELECT DISTINCT b.pat, b.ID FROM riccaboni.t08_allclasses_t09_patstat b;

-- Query OK, 6797635 rows affected (2 min 24,83 sec)
-- Records: 6797635  Duplicates: 0  Warnings: 0

DROP TABLE IF EXISTS riccaboni.t08_allclasses_t09_patstat_pat_inv_counts;
CREATE TABLE riccaboni.t08_allclasses_t09_patstat_pat_inv_counts AS
SELECT a.pat, COUNT(a.ID) AS n FROM riccaboni.t08_allclasses_t09_patstat_pat_inv_counts_temp a GROUP BY a.pat;

Query OK, 2370257 rows affected (2 min 4,48 sec)
Records: 2370257  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.t08_allclasses_t09_patstat_pat_inv_counts;
ALTER TABLE riccaboni.t08_allclasses_t09_patstat_pat_inv_counts ADD INDEX(pat);

---------------------------------------------------------------------------------------------------
-- Table with the three countings: T01 AS T08, MERGE OF PATSTAT and T08
-- christian.counting_invenbypatents_allclasses
-- ATTENTION: CONDITION TO GET THE PATENTS THAT HAVE THE SAME NUMBER OF INVENTORS:
-- WHERE a.n01=a.npas AND a.n01=a.n08 AND a.npas=a.n08;
---------------------------------------------------------------------------------------------------

SELECT COUNT(*) 
FROM (
SELECT a.pat
  FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a
UNION
SELECT b.pat
  FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
UNION
SELECT c.pat
  FROM riccaboni.t08_allclasses_t09_patstat_pat_inv_counts c) d;

/*
+----------+
| COUNT(*) |
+----------+
|  2443177 |
+----------+

So, table t01 as t08 contains everything
mysql> SELECT COUNT(n08)     FROM christian.counting_invenbypatents_allclasses a;
+------------+
| COUNT(n08) |
+------------+
|    2370257 |
+------------+
1 row in set (1,16 sec)

mysql> SELECT COUNT(npas)     FROM christian.counting_invenbypatents_allclasses a;
+-------------+
| COUNT(npas) |
+-------------+
|     2378310 |
+-------------+
1 row in set (1,14 sec)
*/


DROP TABLE IF EXISTS christian.counting_invenbypatents_allclasses;
CREATE TABLE christian.counting_invenbypatents_allclasses AS
SELECT a.pat, a.n AS n01, b.n AS npas, c.n AS n08
  FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a
  LEFT JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
  ON a.pat=b.pat
  LEFT JOIN riccaboni.t08_allclasses_t09_patstat_pat_inv_counts c
  ON a.pat=c.pat;
/*
Query OK, 2443177 rows affected (1 min 24,15 sec)
Records: 2443177  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.counting_invenbypatents_allclasses;
ALTER TABLE christian.counting_invenbypatents_allclasses ADD INDEX(pat);


SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a;

-- Equal in three
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n01=a.npas AND a.n01=a.n08 AND a.npas=a.n08;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2344312 |
+-----------------------+
1 row in set (8,06 sec)

2443177-2344312=98865 so in 98.865 the countings are not the same (incluiding 73496 missing patents in patstat or in t08)
*/


-- Equal in two
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n01=a.npas;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2359021 |
+-----------------------+
1 row in set (7,28 sec)
2359021-2344312=14709
*/

SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n01=a.n08;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2359652 |
+-----------------------+
1 row in set (7,48 sec)
2359652-2344312=15340


*/
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.npas=a.n08;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2344331 |
+-----------------------+
1 row in set (7,80 sec)
2344331-2344312=19
SO, THE PROBLEMS IN THE COINCIDENCE OF THE THREE ARE MAINLY DRIVEN BY THE NOT COINCIDENCE OF a.npas=a.n08
*/


-- Different in the three
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n01!=a.npas AND a.n01!=a.n08 AND a.npas!=a.n08;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                    61 |
+-----------------------+
1 row in set (1,42 sec)
*/

-- At least one null
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n08 IS NULL OR a.npas IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 73496 |
+-----------------------+
1 row in set (1,56 sec)
98865-73496=25369

N08NOTNULL-(n01=a.n08)=25369-15340=10029
15340/25369=0.604675
*/

-- Both are null
SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n08 IS NULL AND a.npas IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 64291 |
+-----------------------+
1 row in set (1,31 sec)
*/

SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.n08 IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 72920 |
+-----------------------+
1 row in set (1,28 sec)
*/

SELECT COUNT(DISTINCT a.pat)
    FROM christian.counting_invenbypatents_allclasses a
    WHERE a.npas IS NULL;
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                 64867 |
+-----------------------+
1 row in set (1,26 sec)
*/

/*
So, there are more null patents in t08 than in pastat's merge
*/


---------------------------------------------------------------------------------------------------
-- SELECT ONLY THOSE THAT DO NOT EXACTLY MATCH: T08 MERGE VS T01_AS_T08
---------------------------------------------------------------------------------------------------

SELECT count(distinct a.pat)
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN riccaboni.t08_allclasses_t09_patstat_pat_inv_counts b
    ON a.pat=b.pat WHERE NULLIF(a.n, b.n) IS NOT NULL;
/*
+-----------------------+
| count(distinct a.pat) |
+-----------------------+
|                 10605 |
+-----------------------+
1 row in set (27,51 sec)

PROBLEM: THERE ARE EVEN PATENTS THAT DO NOT HAVE THE SAME NUMBER OF LOCAL INVENTORS BETWEEN TABLES T01 AND T08. THIS IS A BIG CONCERN
*/

---------------------------------------------------------------------------------------------------
-- SELECT ONLY THOSE THAT DO NOT EXACTLY MATCH: PATSTAT MERGE VS T01_AS_T08
---------------------------------------------------------------------------------------------------

SELECT a.pat, a.n, b.n, NULLIF(a.n, b.n) AS notequal
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
    ON a.pat=b.pat WHERE NULLIF(a.n, b.n) IS NOT NULL
LIMIT 0,100;

SELECT count(distinct a.pat)
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
    ON a.pat=b.pat WHERE NULLIF(a.n, b.n) IS NOT NULL;
/*
+-----------------------+
| count(distinct a.pat) |
+-----------------------+
|                 19289 |
+-----------------------+
1 row in set (26,84 sec)
So, in 19289 patents, the number of inventors do not coincide
*/

SELECT count(distinct a.pat)
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
    ON a.pat=b.pat WHERE a.n>b.n;
/*
+-----------------------+
| count(distinct a.pat) |
+-----------------------+
|                  7173 |
+-----------------------+
1 row in set (32,97 sec)

*/

SELECT count(distinct a.pat)
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
    ON a.pat=b.pat WHERE a.n=b.n;
/*
+-----------------------+
| count(distinct a.pat) |
+-----------------------+
|               2359021 |
+-----------------------+
1 row in set (46,05 sec)
*/

SELECT count(distinct a.pat)
    FROM riccaboni.t01_allclasses_as_t08_pat_inv_counts a 
    INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat_inv_counts b
    ON a.pat=b.pat WHERE a.n<b.n;
/*
+-----------------------+
| count(distinct a.pat) |
+-----------------------+
|                 12116 |
+-----------------------+
1 row in set (31,36 sec)
*/

-- Examples

-- In this case they say it was completed but it was not: there is one author missing
SELECT a.* FROM riccaboni.t01_allclasses a
    WHERE a.pat='EP0000165';

SELECT a.* FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a WHERE a.INVT_SEQ_NR>'0' AND a.pat='EP0000165';

SELECT a.* FROM riccaboni.t08 a
    WHERE a.pat='EP0000165';

