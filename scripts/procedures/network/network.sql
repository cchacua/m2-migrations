---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES using IDS and patents
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM christian.ric_us_ao_both;  
SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone;

DROP TABLE IF EXISTS riccaboni.t_id_pat;
CREATE TABLE riccaboni.t_id_pat AS
SELECT DISTINCT a.finalID, a.pat
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      INNER JOIN christian.ric_us_ao_both b
      ON a.pat=b.pat;
/*
Query OK, 3015123 rows affected (2 min 1,25 sec)
Records: 3015123  Duplicates: 0  Warnings: 0

*/




SHOW INDEX FROM riccaboni.t_id_pat;                                     
ALTER TABLE riccaboni.t_id_pat ADD INDEX(finalID);
ALTER TABLE riccaboni.t_id_pat ADD INDEX(pat);

SELECT * FROM riccaboni.t_id_pat LIMIT 0,30;
SELECT * FROM riccaboni.t08_names_allclasses_us_mob_atleastone LIMIT 0,30;
---------------------------------------------------------------------------------------------------
-- DIRECTED EDGE LIST
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t_id_pat;                                     
ALTER TABLE riccaboni.t_id_pat ADD INDEX(finalID);
ALTER TABLE riccaboni.t_id_pat ADD INDEX(pat);



DROP TABLE IF EXISTS riccaboni.edges_dir;
CREATE TABLE riccaboni.edges_dir AS
SELECT DISTINCT a.finalID, b.finalID AS finalID_, a.pat
      FROM riccaboni.t_id_pat a
      INNER JOIN riccaboni.t_id_pat b
      ON a.pat=b.pat
      WHERE a.finalID!=b.finalID;
/*
WHERE a.ID!=b.ID IS TO AVOID LINKS TO THEMSELVES
Query OK, 10632746 rows affected (5 min 48,28 sec)
Records: 10632746  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.edges_dir;                                     
ALTER TABLE riccaboni.edges_dir ADD INDEX(pat);

SELECT * FROM riccaboni.edges_dir LIMIT 0,30;



-- Directed list using priority year: Computer technology and telecommunications
-- only used for find neighbors to counterfactual: riccaboni.edges_diryr_ctt
DROP TABLE IF EXISTS riccaboni.edges_diryr_ctt;
CREATE TABLE riccaboni.edges_diryr_ctt AS
SELECT DISTINCT a.finalID, a.finalID_, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID, a.finalID_) AS undid
      FROM riccaboni.edges_dir a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat;
/*
Query OK, 2185318 rows affected (3 min 20,62 sec)
Records: 2185318  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.edges_diryr_ctt;                                     
ALTER TABLE riccaboni.edges_diryr_ctt ADD INDEX(undid);

-- Directed list using priority year: Pharmaceuticals, biotechnology and organic fine chemistry
-- only used for find neighbors to counterfactual: riccaboni.edges_diryr_pboc

DROP TABLE IF EXISTS riccaboni.edges_diryr_pboc;
CREATE TABLE riccaboni.edges_diryr_pboc AS
SELECT DISTINCT a.finalID, a.finalID_, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID, a.finalID_) AS undid
      FROM riccaboni.edges_dir a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat;
/*
Query OK, 1.300.831 rows affected (2 min 0,80 sec)
Records: 1300831  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.edges_diryr_pboc;                                     
ALTER TABLE riccaboni.edges_diryr_pboc ADD INDEX(undid);


-- SELECT ONLY LINKS WHOSE PATENTS CONTAIN ONLY US RESIDENTS, AND AT LEAST ONE OF THE TEAM MEMBERS BELONGS TO THE TEN CONSIDERED CEL GROUPS:
SHOW INDEX FROM  christian.pat_nceltic_allus; 

DROP TABLE IF EXISTS riccaboni.edges_dir_aus;
CREATE TABLE riccaboni.edges_dir_aus AS
SELECT DISTINCT a.*, b.nation, c.nation AS nation_
      FROM riccaboni.edges_dir a
      INNER JOIN christian.finalid_10cel_allus b
      ON a.finalID=b.finalID
      INNER JOIN christian.finalid_cel_allus c
      ON a.finalID_=c.finalID
      INNER JOIN christian.pat_nceltic_allus d
      ON a.pat=d.pat;

/*
Query OK, 2800151 rows affected (3 min 26,06 sec)
Records: 2800151  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.edges_dir_aus;                                     
ALTER TABLE  riccaboni.edges_dir_aus ADD INDEX(pat);

SELECT * FROM riccaboni.edges_dir_aus LIMIT 0,10;
SELECT DISTINCT a.nation FROM riccaboni.edges_dir_aus a;
/*
+-----------------------------+
| nation                      |
+-----------------------------+
| European.Italian.Italy      |
| SouthAsian                  |
| EastAsian.Indochina.Vietnam |
| European.French             |
| European.German             |
| EastAsian.Chinese           |
| EastAsian.South.Korea       |
| European.EastEuropean       |
| Muslim.Persian              |
| EastAsian.Japan             |
| EastAsian.Malay.Indonesia   |
| European.Russian            |
+-----------------------------+
12 rows in set (6,82 sec)
*/

SELECT DISTINCT a.nation_ FROM riccaboni.edges_dir_aus a;
/*
+------------------------------+
| nation_                      |
+------------------------------+
| CelticEnglish                |
| SouthAsian                   |
| European.German              |
| EastAsian.Chinese            |
| Hispanic.Spanish             |
| European.French              |
| EastAsian.South.Korea        |
| Muslim.Nubian                |
| Hispanic.Portuguese          |
| EastAsian.Indochina.Vietnam  |
| European.SouthSlavs          |
| Muslim.Persian               |
| EastAsian.Japan              |
| Hispanic.Philippines         |
| EastAsian.Malay.Indonesia    |
| European.Russian             |
| Nordic.Scandavian.Denmark    |
| Nordic.Finland               |
| African.WestAfrican          |
| EastAsian.Indochina.Thailand |
| Muslim.ArabianPeninsula      |
| Greek                        |
| Muslim.Pakistanis.Pakistan   |
| European.Italian.Italy       |
| EastAsian.Indochina.Myanmar  |
| Nordic.Scandinavian.Sweden   |
| European.EastEuropean        |
| EastAsian.Malay.Malaysia     |
| African.EastAfrican          |
| Jewish                       |
| Muslim.Turkic.Turkey         |
| European.Italian.Romania     |
| Nordic.Scandinavian.Norway   |
| European.Baltics             |
| African.SouthAfrican         |
| Muslim.Pakistanis.Bangladesh |
| Muslim.Turkic.CentralAsian   |
| Muslim.Maghreb               |
| EastAsian.Indochina.Cambodia |
+------------------------------+
39 rows in set (6,33 sec)
*/


SELECT COUNT(DISTINCT a.finalID), a.nation_ FROM riccaboni.edges_dir_aus a GROUP BY a.nation_ ORDER BY COUNT(DISTINCT a.finalID) DESC;

SHOW INDEX FROM  riccaboni.t01_allclasses_appid_patstat_us_atleastone; 
SHOW INDEX FROM  patstat2016b.TLS201_APPLN; 

------------------------------
-- LINKS ETHNICS: Add priority year, type of patent
DROP TABLE IF EXISTS riccaboni.edges_dir_aus_pyr;
CREATE TABLE riccaboni.edges_dir_aus_pyr AS
SELECT a.*, c.EARLIEST_FILING_YEAR, CONCAT(c.EARLIEST_FILING_YEAR, a.finalID, a.finalID_) AS undid
      FROM riccaboni.edges_dir_aus a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID;
/*
Query OK, 2.800.151 rows affected (2 min 2,69 sec)
Records: 2800151  Duplicates: 0  Warnings: 0

Only keep links where at least one node belong to the ten considered groups
*/

SHOW INDEX FROM  riccaboni.edges_dir_aus_pyr;                                     
ALTER TABLE riccaboni.edges_dir_aus_pyr ADD INDEX(pat);
ALTER TABLE riccaboni.edges_dir_aus_pyr ADD INDEX(undid);

SELECT * FROM riccaboni.edges_dir_aus_pyr LIMIT 0,10;

SELECT COUNT(DISTINCT a.pat) 
FROM riccaboni.edges_dir_aus_pyr a 
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                436566 |
+-----------------------+
1 row in set (6,18 sec)
*/

SELECT * FROM riccaboni.edges_dir_aus_pyr WHERE finalID='HI107583' AND EARLIEST_FILING_YEAR='1990' ;

------------------------------
-- COUNTERFACTUAL: Add priority year, type of patent, ethnicity

-- PBOC
DROP TABLE IF EXISTS riccaboni.edges_dir_count_pboc;
CREATE TABLE riccaboni.edges_dir_count_pboc AS
SELECT DISTINCT a.finalID_ AS finalID, a.finalID__ AS finalID_, counterof AS pat, b.nation, c.nation AS nation_, a.year AS EARLIEST_FILING_YEAR, CONCAT(a.year, a.finalID_, a.finalID__) AS undid
      FROM christian.counter_pboc a
      INNER JOIN christian.finalid_cel_allus b
      ON a.finalID_=b.finalID
      INNER JOIN christian.finalid_cel_allus c
      ON a.finalID__=c.finalID;
/*
Query OK, 695680 rows affected (30,07 sec)
Records: 695680  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  riccaboni.edges_dir_count_pboc;                                     
ALTER TABLE riccaboni.edges_dir_count_pboc ADD INDEX(finalID_);
ALTER TABLE riccaboni.edges_dir_count_pboc ADD INDEX(finalID);

SELECT * FROM riccaboni.edges_dir_count_pboc LIMIT 0,10;
SELECT * FROM christian.counter_pboc LIMIT 0,10;


-- CTT
DROP TABLE IF EXISTS riccaboni.edges_dir_count_ctt;
CREATE TABLE riccaboni.edges_dir_count_ctt AS
SELECT DISTINCT a.finalID_ AS finalID, a.finalID__ AS finalID_, counterof AS pat, b.nation, c.nation AS nation_, a.year AS EARLIEST_FILING_YEAR, CONCAT(a.year, a.finalID_, a.finalID__) AS undid
      FROM christian.counter_ctt a
      INNER JOIN christian.finalid_cel_allus b
      ON a.finalID_=b.finalID
      INNER JOIN christian.finalid_cel_allus c
      ON a.finalID__=c.finalID;
/*
Query OK, 613468 rows affected (27,46 sec)
Records: 613468  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.edges_dir_count_ctt;                                     
ALTER TABLE riccaboni.edges_dir_count_ctt ADD INDEX(finalID_);
ALTER TABLE riccaboni.edges_dir_count_ctt ADD INDEX(finalID);

SELECT * FROM riccaboni.edges_dir_count_ctt LIMIT 0,10;

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- COUNTERFACTUAL AND EDGES BY FIELD
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
-- pboc
DROP TABLE IF EXISTS riccaboni.count_edges_pboc;
CREATE TABLE riccaboni.count_edges_pboc AS
SELECT DISTINCT a.finalID, a.finalID_, 1 AS linked, a.nation, a.nation_, a.EARLIEST_FILING_YEAR, IF(a.nation = a.nation_, 1, 0) AS ethnic, a.undid, CONCAT(a.EARLIEST_FILING_YEAR,a.finalID) AS yfinalID, CONCAT(a.EARLIEST_FILING_YEAR,a.finalID_) AS yfinalID_, NULL as counterof
FROM riccaboni.edges_dir_aus_pyr a
INNER JOIN  riccaboni.t01_pboc_class b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1976' AND a.EARLIEST_FILING_YEAR<='2012'
UNION ALL  
SELECT c.finalID, c.finalID_, 0 AS linked, c.nation, c.nation_, c.EARLIEST_FILING_YEAR, IF(c.nation = c.nation_, 1, 0) AS ethnic, c.undid, CONCAT(c.EARLIEST_FILING_YEAR,c.finalID) AS yfinalID, CONCAT(c.EARLIEST_FILING_YEAR,c.finalID_) AS yfinalID_, c.pat as counterof
FROM riccaboni.edges_dir_count_pboc c;  

/*
Query OK, 1391360 rows affected (1 min 3,03 sec)
Records: 1391360  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.count_edges_pboc;                                     
ALTER TABLE riccaboni.count_edges_pboc ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_pboc ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_pboc ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_pboc ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_pboc ADD INDEX(undid);

SELECT * FROM riccaboni.count_edges_pboc LIMIT 0,10;

SELECT * FROM riccaboni.count_edges_pboc WHERE ethnic='1' AND linked='0' LIMIT 0,10;

SELECT ethnic, count(*) FROM riccaboni.count_edges_pboc 
WHERE EARLIEST_FILING_YEAR>='1976' AND EARLIEST_FILING_YEAR<='2012'
GROUP BY ethnic;
/*
+--------+----------+
| ethnic | count(*) |
+--------+----------+
|      0 |  1230194 |
|      1 |   161166 |
+--------+----------+
2 rows in set (2,27 sec)

*/

SELECT linked, count(*) FROM riccaboni.count_edges_pboc 
WHERE EARLIEST_FILING_YEAR>='1976' AND EARLIEST_FILING_YEAR<='2012'
GROUP BY linked;
/*
+--------+----------+
| linked | count(*) |
+--------+----------+
|      0 |   695680 |
|      1 |   695680 |
+--------+----------+
2 rows in set (2,26 sec)

*/

-- CTT
DROP TABLE IF EXISTS riccaboni.count_edges_ctt;
CREATE TABLE riccaboni.count_edges_ctt AS
SELECT DISTINCT a.finalID, a.finalID_, 1 AS linked, a.nation, a.nation_, a.EARLIEST_FILING_YEAR, IF(a.nation = a.nation_, 1, 0) AS ethnic, a.undid, CONCAT(a.EARLIEST_FILING_YEAR,a.finalID) AS yfinalID, CONCAT(a.EARLIEST_FILING_YEAR,a.finalID_) AS yfinalID_, NULL as counterof
FROM riccaboni.edges_dir_aus_pyr a
INNER JOIN  riccaboni.t01_ctt_class b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1976' AND a.EARLIEST_FILING_YEAR<='2012'
UNION ALL  
SELECT c.finalID, c.finalID_, 0 AS linked, c.nation, c.nation_, c.EARLIEST_FILING_YEAR, IF(c.nation = c.nation_, 1, 0) AS ethnic, c.undid, CONCAT(c.EARLIEST_FILING_YEAR,c.finalID) AS yfinalID, CONCAT(c.EARLIEST_FILING_YEAR,c.finalID_) AS yfinalID_, c.pat as counterof
FROM riccaboni.edges_dir_count_ctt c;  

/*
Query OK, 1226936 rows affected (56,60 sec)
Records: 1226936  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM  riccaboni.count_edges_ctt;                                     
ALTER TABLE riccaboni.count_edges_ctt ADD INDEX(finalID_);
ALTER TABLE riccaboni.count_edges_ctt ADD INDEX(finalID);
ALTER TABLE riccaboni.count_edges_ctt ADD INDEX(yfinalID_);
ALTER TABLE riccaboni.count_edges_ctt ADD INDEX(yfinalID);
ALTER TABLE riccaboni.count_edges_ctt ADD INDEX(undid);

SELECT * FROM riccaboni.count_edges_ctt LIMIT 0,10;

SELECT * FROM riccaboni.count_edges_ctt WHERE ethnic='1' AND linked='0' LIMIT 0,10;

SELECT ethnic, count(*) FROM riccaboni.count_edges_ctt 
WHERE EARLIEST_FILING_YEAR>='1976' AND EARLIEST_FILING_YEAR<='2012'
GROUP BY ethnic;
/*
+--------+----------+
| ethnic | count(*) |
+--------+----------+
|      0 |  1067241 |
|      1 |   159695 |
+--------+----------+
2 rows in set (2,07 sec)
*/

SELECT linked, count(*) FROM riccaboni.count_edges_ctt 
WHERE EARLIEST_FILING_YEAR>='1976' AND EARLIEST_FILING_YEAR<='2012'
GROUP BY linked;
/*
+--------+----------+
| linked | count(*) |
+--------+----------+
|      0 |   613468 |
|      1 |   613468 |
+--------+----------+
2 rows in set (1,79 sec)
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
Query OK, 5316373 rows affected (4 min 51,73 sec)
Records: 5316373  Duplicates: 0  Warnings: 0

Query OK, 5316373 rows affected (5 min 19,34 sec)
Records: 5316373  Duplicates: 0  Warnings: 0


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
Query OK, 1092659 rows affected (1 min 46,90 sec)
Records: 1092659  Duplicates: 0  Warnings: 0
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
Query OK, 1.300.831 rows affected (2 min 0,80 sec)
Records: 1300831  Duplicates: 0  Warnings: 0

*/

SHOW INDEX FROM riccaboni.edges_undir_pyrpboc;                                     
ALTER TABLE riccaboni.edges_undir_pyrpboc ADD INDEX(undid);


SELECT COUNT(DISTINCT a.pat) from riccaboni.edges_undir_pat a
INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      WHERE c.EARLIEST_FILING_YEAR>='1975' and c.EARLIEST_FILING_YEAR<='2012'; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                766370 |
+-----------------------+
1 row in set (40,63 sec)
*/

SELECT COUNT(DISTINCT a.pat) from riccaboni.edges_undir_pat a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat
      WHERE c.EARLIEST_FILING_YEAR>='1975' and c.EARLIEST_FILING_YEAR<='2012'; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                390489 |
+-----------------------+
1 row in set (45,38 sec)


*/

SELECT COUNT(DISTINCT a.pat) from riccaboni.edges_undir_pat a
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      INNER JOIN patstat2016b.TLS201_APPLN c
      ON b.APPLN_ID=c.APPLN_ID
      INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat
      WHERE c.EARLIEST_FILING_YEAR>='1975' and c.EARLIEST_FILING_YEAR<='2012';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                378815 |
+-----------------------+
1 row in set (39,63 sec)



*/


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
Query OK, 306105 rows affected (12,39 sec)
Records: 306105  Duplicates: 0  Warnings: 0
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
Query OK, 347545 rows affected (14,76 sec)
Records: 347545  Duplicates: 0  Warnings: 0
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

