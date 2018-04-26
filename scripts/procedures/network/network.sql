---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES using IDS and patents
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t_id_pat;
CREATE TABLE riccaboni.t_id_pat AS
SELECT DISTINCT a.finalID, a.pat
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
Query OK, 3038676 rows affected (39,40 sec)
Records: 3038676  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.t_id_pat;                                     
ALTER TABLE riccaboni.t_id_pat ADD INDEX(finalID);
ALTER TABLE riccaboni.t_id_pat ADD INDEX(pat);

SELECT * FROM riccaboni.t_id_pat LIMIT 0,30;
SELECT * FROM riccaboni.t08_names_allclasses_us_mob_atleastone LIMIT 0,30;
---------------------------------------------------------------------------------------------------
-- DIRECTED EDGE LIST
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.edges_dir;
CREATE TABLE riccaboni.edges_dir AS
SELECT DISTINCT a.finalID, b.finalID AS finalID_, a.pat
      FROM riccaboni.t_id_pat a
      INNER JOIN riccaboni.t_id_pat b
      ON a.pat=b.pat
      WHERE a.finalID!=b.finalID;
/*
WHERE a.ID!=b.ID IS TO AVOID LINKS TO THEMSELVES
Query OK, 10710048 rows affected (6 min 3,01 sec)
Records: 10.710.048  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.edges_dir;                                     
ALTER TABLE riccaboni.edges_dir ADD INDEX(pat);

SELECT * FROM riccaboni.edges_dir LIMIT 0,30;



-- SELECT ONLY LINKS WHOSE PATENTS CONTAIN ONLY US RESIDENTS, AND AT LEAST ONE OF THE TEAM MEMBERS IS NON-CELTIC:
SHOW INDEX FROM  christian.pat_nceltic_allus; 

DROP TABLE IF EXISTS riccaboni.edges_dir_aus;
CREATE TABLE riccaboni.edges_dir_aus AS
SELECT DISTINCT a.*
      FROM riccaboni.edges_dir a
      INNER JOIN christian.pat_nceltic_allus b
      ON a.pat=b.pat;

/*
Query OK, 7.417.084 rows affected (3 min 34,15 sec)
Records: 7.417.084  Duplicates: 0  Warnings: 0

*/
SHOW INDEX FROM  riccaboni.edges_dir_aus;                                     
ALTER TABLE  riccaboni.edges_dir_aus ADD INDEX(pat);

SHOW INDEX FROM  riccaboni.t01_allclasses_appid_patstat_us_atleastone; 
SHOW INDEX FROM  patstat2016b.TLS201_APPLN; 

-- Add priority year, type of patent
DROP TABLE IF EXISTS riccaboni.edges_dir_aus_pyr;
CREATE TABLE riccaboni.edges_dir_aus_pyr AS
SELECT a.*, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID, a.finalID_) AS undid
      FROM riccaboni.edges_dir_aus a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID;
/*
Query OK, 7417084 rows affected (5 min 29,10 sec)
Records: 7417084  Duplicates: 0  Warnings: 0

Ask if keep links Celtic-English, Celtic-English, if they belong to a patent with one inventor of foreign origin
*/

SHOW INDEX FROM  riccaboni.edges_dir_aus_pyr;                                     
ALTER TABLE riccaboni.edges_dir_aus_pyr ADD INDEX(pat);
ALTER TABLE riccaboni.edges_dir_aus_pyr ADD INDEX(undid);

---------------------------------------------------------------------------------------------------
-- UNDIRECTED EDGE LIST
-- See: https://stackoverflow.com/questions/21800873/select-distinct-pair-values-mysql
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.edges_undir_pat;
CREATE TABLE riccaboni.edges_undir_pat AS
SELECT DISTINCT LEAST(a.finalID, b.finalID) AS finalID_, GREATEST(a.finalID, b.finalID) AS finalID__, a.pat
      FROM riccaboni.t_id_pat a
      INNER JOIN riccaboni.t_id_pat b
      ON a.pat=b.pat
      WHERE a.finalID!=b.finalID
      GROUP BY LEAST(a.finalID, b.finalID), GREATEST(a.finalID, b.finalID), a.pat;
/*
Query OK, 5355024 rows affected (5 min 10,18 sec)
Records: 5355024  Duplicates: 0  Warnings: 0
*/
SELECT * FROM riccaboni.edges_undir_pat LIMIT 0,30;
SHOW INDEX FROM riccaboni.edges_undir_pat;                                     
ALTER TABLE riccaboni.edges_undir_pat ADD INDEX(pat);

SHOW INDEX FROM christian.t08_class_at1us_date_fam;   

/*
-- Undirected list using priority year: the one for calculating distances: riccaboni.edges_undir_pyr
DROP TABLE IF EXISTS riccaboni.edges_undir_pyr;
CREATE TABLE riccaboni.edges_undir_pyr AS
SELECT DISTINCT a.finalID_, a.finalID__, b.EARLIEST_FILING_YEAR
      FROM riccaboni.edges_undir_pat a
      INNER JOIN christian.t08_class_at1us_date_fam b
      ON a.pat=b.pat;

Query OK, 2389267 rows affected (9 min 20,14 sec)
Records: 2389267  Duplicates: 0  Warnings: 0

SELECT * FROM riccaboni.edges_undir_pyr LIMIT 0,30;
*/


-- Undirected list using priority year: Computer technology and telecommunications
-- the one for calculating distances: riccaboni.edges_undir_pyrctt
DROP TABLE IF EXISTS riccaboni.edges_undir_pyrctt;
CREATE TABLE riccaboni.edges_undir_pyrctt AS
SELECT DISTINCT a.finalID_, a.finalID__, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID_, a.finalID__) AS undid
      FROM riccaboni.edges_undir_pat a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat;
/*
Query OK, 1097993 rows affected (2 min 2,35 sec)
Records: 1097993  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.edges_undir_pyrctt;                                     
ALTER TABLE riccaboni.edges_undir_pyrctt ADD INDEX(undid);

-- Undirected list using priority year: Pharmaceuticals, biotechnology and organic fine chemistry
-- the one for calculating distances: riccaboni.edges_undir_pyrpboc

DROP TABLE IF EXISTS riccaboni.edges_undir_pyrpboc;
CREATE TABLE riccaboni.edges_undir_pyrpboc AS
SELECT DISTINCT a.finalID_, a.finalID__, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID_, a.finalID__) AS undid
      FROM riccaboni.edges_undir_pat a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat;
/*
Query OK, 1310279 rows affected (1 min 42,86 sec)
Records: 1310279  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.edges_undir_pyrpboc;                                     
ALTER TABLE riccaboni.edges_undir_pyrpboc ADD INDEX(undid);

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Links that appear in both directed and undirected lists AND that should be estimated in the t-1,t-5
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Computer technology and telecommunications: ctt
DROP TABLE IF EXISTS riccaboni.edges_undid_ud_ctt;
CREATE TABLE riccaboni.edges_undid_ud_ctt AS
SELECT DISTINCT a.*
     FROM riccaboni.edges_undir_pyrctt a
     INNER JOIN riccaboni.edges_dir_aus_pyr b
     ON a.undid=b.undid
     ORDER BY a.EARLIEST_FILING_YEAR;
/*
Query OK, 796513 rows affected (19,84 sec)
Records: 796513  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.edges_undid_ud_ctt;                                     
ALTER TABLE riccaboni.edges_undid_ud_ctt ADD INDEX(undid);
ALTER TABLE riccaboni.edges_undid_ud_ctt ADD INDEX(EARLIEST_FILING_YEAR);

-- Pharmaceuticals, biotechnology and organic fine chemistry: pboc
DROP TABLE IF EXISTS riccaboni.edges_undid_ud_pboc;
CREATE TABLE riccaboni.edges_undid_ud_pboc AS
SELECT DISTINCT a.*
     FROM riccaboni.edges_undir_pyrpboc a
     INNER JOIN riccaboni.edges_dir_aus_pyr b
     ON a.undid=b.undid
     ORDER BY a.EARLIEST_FILING_YEAR;
/*
Query OK, 881403 rows affected (22,53 sec)
Records: 881403  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM riccaboni.edges_undid_ud_pboc;                                     
ALTER TABLE riccaboni.edges_undid_ud_pboc ADD INDEX(undid);
ALTER TABLE riccaboni.edges_undid_ud_pboc ADD INDEX(EARLIEST_FILING_YEAR);













---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES using IDS and priority year: THIS IS NOT USED IN THE MODEL, IT ONLY ALLOWS TO HAVE AN IDEA OF THE DATA
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t_id_pyr;
CREATE TABLE riccaboni.t_id_pyr AS
SELECT DISTINCT a.finalID, a.EARLIEST_FILING_YEAR
      FROM christian.t08_class_at1us_date_fam a;
/*
Query OK, 1253740 rows affected (26,31 sec)
Records: 1.253.740  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t_id_pyr;                                     
ALTER TABLE riccaboni.t_id_pyr ADD INDEX(finalID);
ALTER TABLE riccaboni.t_id_pyr ADD INDEX(EARLIEST_FILING_YEAR);

SELECT * FROM riccaboni.t_id_pyr LIMIT 0,30;

-- Number of inventors by Priority year
SELECT a.EARLIEST_FILING_YEAR, COUNT(a.finalID) FROM riccaboni.t_id_pyr a GROUP BY a.EARLIEST_FILING_YEAR ;
/*
+----------------------+------------------+
| EARLIEST_FILING_YEAR | COUNT(a.finalID) |
+----------------------+------------------+
|                 1907 |                2 |
|                 1953 |                2 |
|                 1954 |                1 |
|                 1955 |                1 |
|                 1957 |                1 |
|                 1960 |                2 |
|                 1961 |                2 |
|                 1962 |                2 |
|                 1963 |               15 |
|                 1964 |                8 |
|                 1965 |                5 |
|                 1966 |               12 |
|                 1967 |               33 |
|                 1968 |               37 |
|                 1969 |               32 |
|                 1970 |              101 |
|                 1971 |              209 |
|                 1972 |              277 |
|                 1973 |              453 |
|                 1974 |             1172 |
|                 1975 |             2126 |
|                 1976 |             7054 |
|                 1977 |             7018 |
|                 1978 |             7401 |
|                 1979 |             8189 |
|                 1980 |             8480 |
|                 1981 |             8298 |
|                 1982 |             9492 |
|                 1983 |            10578 |
|                 1984 |            11310 |
|                 1985 |            12655 |
|                 1986 |            13772 |
|                 1987 |            15823 |
|                 1988 |            17992 |
|                 1989 |            20889 |
|                 1990 |            23360 |
|                 1991 |            24436 |
|                 1992 |            25903 |
|                 1993 |            28222 |
|                 1994 |            31709 |
|                 1995 |            36470 |
|                 1996 |            42502 |
|                 1997 |            49223 |
|                 1998 |            55306 |
|                 1999 |            62258 |
|                 2000 |            69675 |
|                 2001 |            68400 |
|                 2002 |            68731 |
|                 2003 |            70312 |
|                 2004 |            68858 |
|                 2005 |            67018 |
|                 2006 |            61936 |
|                 2007 |            51801 |
|                 2008 |            41315 |
|                 2009 |            36500 |
|                 2010 |            38993 |
|                 2011 |            38813 |
|                 2012 |            28536 |
|                 2013 |               19 |
+----------------------+------------------+
59 rows in set (5,64 sec)
*/

