
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


DROP TABLE IF EXISTS christian.socialdis_pboc_ee;
CREATE TABLE christian.socialdis_pboc_ee AS
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

DROP TABLE IF EXISTS christian.socialdis_pboc_e;
CREATE TABLE christian.socialdis_pboc_e AS
SELECT DISTINCT a.undid, a.socialdist
FROM christian.socialdis_pboc_ee a;
/*
Query OK, 435459 rows affected (7,17 sec)
Records: 435459  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.socialdis_pboc_e;                                     
ALTER TABLE christian.socialdis_pboc_e ADD INDEX(undid);

SELECT * FROM christian.socialdis_pboc_e LIMIT 0,10;

----------------------------
DROP TABLE IF EXISTS christian.socialdis_ctt_ee;
CREATE TABLE christian.socialdis_ctt_ee AS
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
Query OK, 265868 rows affected (8,24 sec)
Records: 265868  Duplicates: 0  Warnings: 0
*/


DROP TABLE IF EXISTS christian.socialdis_ctt_e;
CREATE TABLE christian.socialdis_ctt_e AS
SELECT DISTINCT a.undid, a.socialdist
FROM christian.socialdis_ctt_ee a;
/*
Query OK, 196762 rows affected (2,66 sec)
Records: 196762  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  christian.socialdis_ctt_e;                                     
ALTER TABLE christian.socialdis_ctt_e ADD INDEX(undid);

SELECT * FROM christian.socialdis_ctt_e LIMIT 0,10;


------------------------------------------------
-- Add coordinates to each id

-- PBOC
DROP TABLE IF EXISTS riccaboni.count_edges_pboc_gs;
CREATE TABLE riccaboni.count_edges_pboc_gs AS
SELECT a.*, b.loc AS loc, c.loc AS loc_, CONCAT(loc,loc_) AS locid, d.socialdist
FROM riccaboni.count_edges_pboc a
LEFT JOIN christian.geo_onlyone b
ON a.yfinalID=b.yfinalID
LEFT JOIN christian.geo_onlyone c
ON a.yfinalID_=c.yfinalID
LEFT JOIN christian.socialdis_pboc_e d
ON a.undid=d.undid;

/*
Query OK, 1391360 rows affected (1 min 44,45 sec)
Records: 1391360  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  riccaboni.count_edges_pboc_gs;                                     
ALTER TABLE riccaboni.count_edges_pboc_gs ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_pboc_gs ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_pboc_gs ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_pboc_gs ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_pboc_gs ADD INDEX(undid);

SELECT * FROM riccaboni.count_edges_pboc_gs LIMIT 0,10;

SELECT COUNT(DISTINCT loc, loc_) FROM riccaboni.count_edges_pboc_gs;

-- CTT

-- ATTENTION: I HAVE TO RUN THIS TWICE: ONE WITHOUT THE TABLE H, THEN GOT THE GEOLOCATIONS IN R AND FINALLY MERGE WITH H


DROP TABLE IF EXISTS riccaboni.count_edges_ctt_gs;
CREATE TABLE riccaboni.count_edges_ctt_gs AS
SELECT a.*, b.loc AS loc, c.loc AS loc_, CONCAT(b.loc,c.loc) AS locid, IFNULL(d.socialdist, '99') AS socialdist, IFNULL(f.degreecen, '0') AS degreecen , IFNULL(g.degreecen, '0') AS degreecen_, IFNULL(e.insprox, '0') AS insprox, e.shareins
FROM riccaboni.count_edges_ctt a
LEFT JOIN christian.geo_onlyone b
ON a.yfinalID=b.yfinalID
LEFT JOIN christian.geo_onlyone c
ON a.yfinalID_=c.yfinalID
LEFT JOIN christian.socialdis_ctt_e d
ON a.undid=d.undid
LEFT JOIN christian.insdis_ctt e
ON a.undid=e.undid
LEFT JOIN  christian.degree_ctt f
ON a.yfinalID=f.yfinalID
LEFT JOIN  christian.degree_ctt g
ON a.yfinalID_=g.yfinalID;

/*
Query OK, 1226936 rows affected (2 min 41,44 sec)
Records: 1226936  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  riccaboni.count_edges_ctt_gs;  
/*                                   
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(undid);
*/
ALTER TABLE riccaboni.count_edges_ctt_gs ADD INDEX(locid);

SELECT * FROM riccaboni.count_edges_ctt_gs LIMIT 0,10;


DROP TABLE IF EXISTS riccaboni.count_edges_ctt_gsi;
CREATE TABLE riccaboni.count_edges_ctt_gsi AS
SELECT a.*, ((degreecen + degreecen_)/2) AS degreecenboth, h.geodis
FROM riccaboni.count_edges_ctt_gs a
LEFT JOIN christian.geodis_locid_ctt h
ON a.locid=h.locid;
/*
Query OK, 1226936 rows affected (1 min 1,94 sec)
Records: 1226936  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.count_edges_ctt_gsi;                                     
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(undid);
ALTER TABLE riccaboni.count_edges_ctt_gsi ADD INDEX(locid);

SELECT * FROM riccaboni.count_edges_ctt_gsi LIMIT 0,10;



