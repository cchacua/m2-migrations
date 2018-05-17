-- IPC classes for the considered patents

SHOW INDEX FROM riccaboni.t10;                                     
ALTER TABLE riccaboni.t10 ADD INDEX(Pub_number);
SHOW INDEX FROM riccaboni.edges_dir_aus_pyr; 

DROP TABLE IF EXISTS christian.pat_ipc;
CREATE TABLE christian.pat_ipc AS
SELECT DISTINCT a.Pub_number AS pat, a.class
FROM riccaboni.t10 a
INNER JOIN riccaboni.edges_dir_aus_pyr b
ON a.Pub_number=b.pat
WHERE a.class_type='i' OR a.class_type='m' AND b.EARLIEST_FILING_YEAR>='1975' AND b.EARLIEST_FILING_YEAR<='2013';

SHOW INDEX FROM christian.pat_ipc;                                     
ALTER TABLE christian.pat_ipc ADD INDEX(pat);

SELECT COUNT(*) FROM christian.pat_ipc;
/*
+----------+
| COUNT(*) |
+----------+
|  2.546.919 |
+----------+
1 row in set (0,99 sec)
*/

SELECT * FROM christian.pat_ipc LIMIT 0,10;

SELECT COUNT(DISTINCT pat) FROM christian.pat_ipc;
/*
+---------------------+
| COUNT(DISTINCT pat) |
+---------------------+
|              426731 |
+---------------------+
1 row in set (2,73 sec)
*/


-- IPC 3-digit code per patent
DROP TABLE IF EXISTS christian.pat_3ipc;
CREATE TABLE christian.pat_3ipc AS
SELECT DISTINCT a.pat, LEFT(a.class,3) AS class, c.EARLIEST_FILING_YEAR
FROM christian.pat_ipc a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID;
/*
Query OK, 816085 rows affected (1 min 36,71 sec)
Records: 816085  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.pat_3ipc;                                     
ALTER TABLE christian.pat_3ipc ADD INDEX(pat);

SELECT * FROM christian.pat_3ipc LIMIT 0,10;


-- IPC 6-digit code per patent
DROP TABLE IF EXISTS christian.pat_6ipc;
CREATE TABLE christian.pat_6ipc AS
SELECT DISTINCT a.pat, LEFT(a.class,6)  AS class, c.EARLIEST_FILING_YEAR
FROM christian.pat_ipc a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID;
/*
Query OK, 1419762 rows affected (1 min 18,79 sec)
Records: 1419762  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.pat_6ipc;                                     
ALTER TABLE christian.pat_6ipc ADD INDEX(pat);

SELECT * FROM christian.pat_6ipc LIMIT 0,10;





