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

