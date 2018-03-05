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

