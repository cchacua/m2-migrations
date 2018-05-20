-- Get ids of nodes of both counterfactual and sample

DROP TABLE IF EXISTS christian.nodes_counter_allsamples;
CREATE TABLE christian.nodes_counter_allsamples AS
SELECT DISTINCT a.finalID
FROM riccaboni.count_edges_pboc a
UNION ALL  
SELECT DISTINCT a.finalID_ AS finalID
FROM riccaboni.count_edges_pboc a 
UNION ALL  
SELECT DISTINCT a.finalID
FROM riccaboni.count_edges_ctt a
UNION ALL  
SELECT DISTINCT a.finalID_ AS finalID
FROM riccaboni.count_edges_ctt a;
/*
THIS TABLE HAVE REPEATED VALUES
Query OK, 547152 rows affected (8,98 sec)
Records: 547152  Duplicates: 0  Warnings: 0
*/


DROP TABLE IF EXISTS christian.nodes_counter_allsamples_dis;
CREATE TABLE christian.nodes_counter_allsamples_dis AS
SELECT DISTINCT a.finalID
FROM  christian.nodes_counter_allsamples a;
/*
THIS TABLE HAS UNIQUE IDS
Query OK, 378836 rows affected (5,53 sec)
Records: 378836  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nodes_counter_allsamples_dis;                                     
ALTER TABLE christian.nodes_counter_allsamples_dis ADD INDEX(finalID);


-- Get all the patents made by those ids
SHOW INDEX FROM riccaboni.t08; 
SELECT * FROM riccaboni.t08 LIMIT 0,10;
SHOW INDEX FROM riccaboni.t09; 
ALTER TABLE riccaboni.t09 ADD INDEX(mobileID);
SELECT * FROM riccaboni.t09 LIMIT 0,10;

DROP TABLE IF EXISTS christian.nodes_counter_allsamples_dis_pat;
CREATE TABLE christian.nodes_counter_allsamples_dis_pat AS
SELECT DISTINCT a.pat, b.finalID
FROM riccaboni.t08 a
INNER JOIN christian.nodes_counter_allsamples b
ON a.ID=b.finalID
UNION ALL
SELECT DISTINCT c.pat, e.finalID
FROM riccaboni.t08 c
INNER JOIN riccaboni.t09 d
ON c.ID=d.localID
INNER JOIN christian.nodes_counter_allsamples e
ON d.mobileID=e.finalID;
/*
Query OK, 4205617 rows affected (2 min 33,73 sec)
Records: 4205617  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nodes_counter_allsamples_dis_pat; 
ALTER TABLE christian.nodes_counter_allsamples_dis_pat ADD INDEX(pat);
ALTER TABLE christian.nodes_counter_allsamples_dis_pat ADD INDEX(finalID);


-- Those are the patents that can be found in patstat, that belong to the studied clases and that contain information of the inventors
DROP TABLE IF EXISTS christian.nodes_counter_allsamples_dis_pat2;
CREATE TABLE christian.nodes_counter_allsamples_dis_pat2 AS
SELECT DISTINCT a.pat, b.APPLN_ID, c.EARLIEST_FILING_YEAR 
FROM christian.nodes_counter_allsamples_dis_pat a
INNER JOIN riccaboni.t01_allclasses_appid_patstat b
ON a.pat=b.pat
INNER JOIN patstat2016b.TLS201_APPLN c
ON b.APPLN_ID=c.APPLN_ID;
/*
Query OK, 960131 rows affected (1 min 8,05 sec)
Records: 960131  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.nodes_counter_allsamples_dis_pat2; 
ALTER TABLE christian.nodes_counter_allsamples_dis_pat2 ADD INDEX(pat);


SELECT COUNT(DISTINCT pat) FROM christian.nodes_counter_allsamples_dis_pat2;

-- IPC classes for the considered patents IPC 6

SHOW INDEX FROM riccaboni.t10;                                     
ALTER TABLE riccaboni.t10 ADD INDEX(Pub_number);
SHOW INDEX FROM christian.ric_us_all_both; 

DROP TABLE IF EXISTS christian.pat_6ipc_prox_p; 
CREATE TABLE christian.pat_6ipc_prox_p AS
SELECT DISTINCT a.Pub_number AS pat, LEFT(a.class,6)  AS class, b.EARLIEST_FILING_YEAR 
FROM riccaboni.t10 a
INNER JOIN christian.nodes_counter_allsamples_dis_pat2 b
ON a.Pub_number=b.pat
WHERE a.class_type='i' OR a.class_type='m';
/*
Query OK, 3174129 rows affected (2 min 24,66 sec)
Records: 3174129  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.pat_6ipc_prox_p;                                     
ALTER TABLE christian.pat_6ipc_prox_p ADD INDEX(pat);

SELECT * FROM christian.pat_6ipc_prox_p LIMIT 0,10;

SELECT COUNT(DISTINCT pat) FROM christian.pat_6ipc_prox_p;
/*
+---------------------+
| COUNT(DISTINCT pat) |
+---------------------+
|              960131 |
+---------------------+
1 row in set (7,06 sec)

*/






