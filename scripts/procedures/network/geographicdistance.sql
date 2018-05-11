
-- Table ids, locations, years and frequency 

DROP TABLE IF EXISTS christian.finalid_geo_all;
CREATE TABLE christian.finalid_geo_all AS
SELECT a.finalID, a.EARLIEST_FILING_YEAR, CONCAT(a.EARLIEST_FILING_YEAR, a.finalID) AS yfinalID, a.loc, COUNT(DISTINCT a.pat) AS nloc 
FROM christian.t08_class_at1us_date_fam a 
     INNER JOIN christian.ric_us_all_both b
     ON a.pat=b.pat
     GROUP BY a.finalID, a.EARLIEST_FILING_YEAR, a.loc;
/*
Query OK, 1595987 rows affected (44,80 sec)
Records: 1595987  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.finalid_geo_all;                                     
ALTER TABLE christian.finalid_geo_all ADD INDEX(yfinalID);

SELECT * FROM christian.finalid_geo_all LIMIT 0,10;


-----------------------------------------------
-- SOCIAL DISTANCE DIRECTED


DROP TABLE IF EXISTS christian.socialdis_pboc_e;
CREATE TABLE christian.socialdis_pboc_e AS
SELECT DISTINCT a.undid, a.socialdist, a.finalID, a.finalID_, a.EARLIEST_FILING_YEAR
FROM christian.socialdis_pboc a
INNER JOIN riccaboni.count_edges_pboc c
ON a.undid=c.undid
UNION ALL  
SELECT DISTINCT b.undid_ AS undid, b.socialdist, b.finalID_ AS finalID, b.finalID AS finalID_, b.EARLIEST_FILING_YEAR
FROM christian.socialdis_pboc b
INNER JOIN riccaboni.count_edges_pboc d
ON b.undid_=d.undid;  
/*
Query OK, 560275 rows affected (17,03 sec)
Records: 560275  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.socialdis_pboc_e;                                     
ALTER TABLE christian.socialdis_pboc_e ADD INDEX(undid);

SELECT * FROM christian.socialdis_pboc_e LIMIT 0,10;

DROP TABLE IF EXISTS christian.socialdis_ctt_e;
CREATE TABLE christian.socialdis_ctt_e AS
SELECT DISTINCT a.undid, a.socialdist, a.finalID, a.finalID_, a.EARLIEST_FILING_YEAR
FROM christian.socialdis_ctt a
INNER JOIN riccaboni.count_edges_ctt c
ON a.undid=c.undid
UNION ALL  
SELECT DISTINCT b.undid_ AS undid, b.socialdist, b.finalID_ AS finalID, b.finalID AS finalID_, b.EARLIEST_FILING_YEAR
FROM christian.socialdis_ctt b
INNER JOIN riccaboni.count_edges_ctt d
ON b.undid_=d.undid;
/*
Query OK, 265862 rows affected (9,02 sec)
Records: 265862  Duplicates: 0  Warnings: 0

*/
SHOW INDEX FROM  christian.socialdis_ctt_e;                                     
ALTER TABLE christian.socialdis_ctt_e ADD INDEX(undid);

SELECT * FROM christian.socialdis_ctt_e LIMIT 0,10;

------------------------------------------------
-- Add coordinates to each id


-- RE-RUN

-- PBOC
DROP TABLE IF EXISTS riccaboni.count_edges_pboc_g;
CREATE TABLE riccaboni.count_edges_pboc_g AS
SELECT a.*, b.loc AS loc, c.loc AS loc_, d.socialdist
FROM riccaboni.count_edges_pboc a
LEFT JOIN christian.geo_onlyone b
ON a.yfinalID=b.yfinalID
LEFT JOIN christian.geo_onlyone c
ON a.yfinalID_=c.yfinalID;

/*
Query OK, 1391360 rows affected (1 min 22,80 sec)
Records: 1391360  Duplicates: 0  Warnings: 0


ATTENTION: CORRECT:
THERE ARE MORE ROWS WHEN ADDING SOCIAL DISTANCE
Query OK, 1517219 rows affected (1 min 42,55 sec)
Records: 1517219  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.count_edges_pboc_g;                                     
ALTER TABLE riccaboni.count_edges_pboc_g ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_pboc_g ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_pboc_g ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_pboc_g ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_pboc_g ADD INDEX(undid);

SELECT * FROM riccaboni.count_edges_pboc_g LIMIT 0,10;

-- CTT

DROP TABLE IF EXISTS riccaboni.count_edges_ctt_g;
CREATE TABLE riccaboni.count_edges_ctt_g AS
SELECT a.*, b.loc AS loc, c.loc AS loc_, d.socialdist
FROM riccaboni.count_edges_ctt a
LEFT JOIN christian.geo_onlyone b
ON a.yfinalID=b.yfinalID
LEFT JOIN christian.geo_onlyone c
ON a.yfinalID_=c.yfinalID;

/*
Query OK, 1226936 rows affected (1 min 14,28 sec)
Records: 1226936  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  riccaboni.count_edges_ctt_g;                                     
ALTER TABLE riccaboni.count_edges_ctt_g ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_ctt_g ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_ctt_g ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_ctt_g ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_ctt_g ADD INDEX(undid);

SELECT * FROM riccaboni.count_edges_ctt_g LIMIT 0,10;
