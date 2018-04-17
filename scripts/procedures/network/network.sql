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



-- SELECT ONLY LINKS WHOSE PATENTS CONTAIN ONLY US RESIDENTS:
SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_allteam;                                     

DROP TABLE IF EXISTS riccaboni.edges_dir_aus;
CREATE TABLE riccaboni.edges_dir_aus AS
SELECT DISTINCT a.*
      FROM riccaboni.edges_dir a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_allteam b
      ON a.pat=b.pat;

/*
Query OK, 8212510 rows affected (4 min 29,76 sec)
Records: 8.212.510  Duplicates: 0  Warnings: 0

TO DO: 
DELETE PATENTS WHERE ALL INVENTORS ARE CELTIC ENGLISH. 

*/



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

-- Undirected list using priority year: the one for calculating distances: riccaboni.edges_undir_pyr
DROP TABLE IF EXISTS riccaboni.edges_undir_pyr;
CREATE TABLE riccaboni.edges_undir_pyr AS
SELECT DISTINCT a.finalID_, a.finalID__, b.EARLIEST_FILING_YEAR
      FROM riccaboni.edges_undir_pat a
      INNER JOIN christian.t08_class_at1us_date_fam b
      ON a.pat=b.pat;
/*
Query OK, 2389267 rows affected (9 min 20,14 sec)
Records: 2389267  Duplicates: 0  Warnings: 0
*/

SELECT * FROM riccaboni.edges_undir_pyr LIMIT 0,30;


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES using IDS and priority year
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

