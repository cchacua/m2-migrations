CREATE SCHEMA `christian` DEFAULT CHARACTER SET utf8mb4 ;



DROP TABLE IF EXISTS christian.ric_us_co;
CREATE TABLE IF NOT EXISTS christian.ric_us_co
(
nrow varchar(10),
nrowd varchar(10),
loc varchar(50),
lati varchar(20),
longi VARCHAR(20),
isin VARCHAR(5)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/21 Distinct locations/points.output.usa.csv' INTO TABLE christian.ric_us_co
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;


DROP TABLE IF EXISTS christian.ric_us_cou;
CREATE TABLE IF NOT EXISTS christian.ric_us_cou
(
nrow varchar(10),
lati varchar(20),
longi VARCHAR(20),
OBJECTID VARCHAR(20),
HASC_2 VARCHAR(10),
loc VARCHAR(50)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/output/spatial_eco/us_locations_counties.csv' INTO TABLE christian.ric_us_cou
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 297820 rows affected (0,67 sec)
Records: 297820  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_cou; 
ALTER TABLE christian.ric_us_cou ADD INDEX(loc);


------------------------------------------------------

DROP TABLE IF EXISTS christian.ric_us_states;
CREATE TABLE IF NOT EXISTS christian.ric_us_states
(
nrow varchar(10),
lati varchar(20),
longi VARCHAR(20),
OBJECTID VARCHAR(20),
HASC_1 VARCHAR(10),
loc VARCHAR(50)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/output/spatial_eco/us_locations_states.csv' INTO TABLE christian.ric_us_states
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 297820 rows affected (0,67 sec)
Records: 297820  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_states; 
ALTER TABLE christian.ric_us_states ADD INDEX(loc);

--------------------------------------------
DROP TABLE IF EXISTS christian.ric_us_ma;
CREATE TABLE IF NOT EXISTS christian.ric_us_ma
(
nrow varchar(10),
lati varchar(20),
longi VARCHAR(20),
OBJECTID VARCHAR(20),
METRO CHAR(5),	
NAME VARCHAR(100),
CORE CHAR(1),
loc VARCHAR(50),
METROID CHAR(6)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/output/spatial_eco/us_locations_MA_both.csv' INTO TABLE christian.ric_us_ma
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 92846 rows affected (0,29 sec)
Records: 92846  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_ma; 
ALTER TABLE christian.ric_us_ma ADD INDEX(loc);





--------------------------------------------
DROP TABLE IF EXISTS christian.geo_onlyone;
CREATE TABLE IF NOT EXISTS christian.geo_onlyone
(
yfinalID VARCHAR(20),
loc VARCHAR(50),
ncount VARCHAR(4)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/geo_onlyone.csv' INTO TABLE christian.geo_onlyone
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 1060819 rows affected (1,40 sec)
Records: 1060819  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.geo_onlyone; 
ALTER TABLE christian.geo_onlyone ADD INDEX(yfinalID);

--------------------------------------------
-- Counterfactual CTT
--------------------------------------------
DROP TABLE IF EXISTS christian.counter_ctt;
CREATE TABLE IF NOT EXISTS christian.counter_ctt
(
finalID_ VARCHAR(15),
finalID__ VARCHAR(15),
year CHAR(4),	
counterof VARCHAR(15),
class CHAR(6),	
ncount CHAR(1)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/counterctt.csv' INTO TABLE christian.counter_ctt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 613468 rows affected (1,09 sec)
Records: 613468  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.counter_ctt; 
ALTER TABLE christian.counter_ctt ADD INDEX(finalID_);
ALTER TABLE christian.counter_ctt ADD INDEX(finalID__);


--------------------------------------------
-- Social distance CTT
--------------------------------------------
DROP TABLE IF EXISTS christian.socialdis_ctt;
CREATE TABLE IF NOT EXISTS christian.socialdis_ctt
(
undid VARCHAR(50), 
undid_ VARCHAR(50),
socialdist VARCHAR(5),
finalID VARCHAR(15), 
finalID_ VARCHAR(15),
EARLIEST_FILING_YEAR CHAR(4)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/socialdis_ctt.csv' INTO TABLE christian.socialdis_ctt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 196762 rows affected (0,43 sec)
Records: 196762  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.socialdis_ctt; 
ALTER TABLE christian.socialdis_ctt ADD INDEX(undid);
ALTER TABLE christian.socialdis_ctt ADD INDEX(undid_);

--------------------------------------------
-- Institutional distance ctt
--------------------------------------------
DROP TABLE IF EXISTS christian.insdis_ctt;
CREATE TABLE IF NOT EXISTS christian.insdis_ctt
(
finalID VARCHAR(15), 
finalID_ VARCHAR(15),
insprox CHAR(1),
shareins VARCHAR(50),
EARLIEST_FILING_YEAR CHAR(4),
undid VARCHAR(50)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/insdis_ctt.csv' INTO TABLE christian.insdis_ctt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 271156 rows affected (0,54 sec)
Records: 271156  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.insdis_ctt; 
ALTER TABLE christian.insdis_ctt ADD INDEX(undid);

--------------------------------------------
-- Degree centrality ctt
--------------------------------------------
DROP TABLE IF EXISTS christian.degree_ctt;
CREATE TABLE IF NOT EXISTS christian.degree_ctt
(
degreecen VARCHAR(5),
finalID VARCHAR(15), 
EARLIEST_FILING_YEAR CHAR(4),
yfinalID VARCHAR(20)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/degree_ctt.csv' INTO TABLE christian.degree_ctt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 141846 rows affected (0,21 sec)
Records: 141846  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.degree_ctt; 
ALTER TABLE christian.degree_ctt ADD INDEX(yfinalID);


--------------------------------------------
-- Geographic distances ctt
--------------------------------------------
DROP TABLE IF EXISTS christian.geodis_locid_ctt;
CREATE TABLE IF NOT EXISTS christian.geodis_locid_ctt
(
geodis VARCHAR(50),
locid VARCHAR(100)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/geodis_locidctt_list.csv' INTO TABLE christian.geodis_locid_ctt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 645922 rows affected (1,07 sec)
Records: 645922  Deleted: 0  Skipped: 0  Warnings: 0

*/

SHOW INDEX FROM christian.geodis_locid_ctt; 
ALTER TABLE christian.geodis_locid_ctt ADD INDEX(locid);



--------------------------------------------
-- Counterfactual pboc
--------------------------------------------
DROP TABLE IF EXISTS christian.counter_pboc;
CREATE TABLE IF NOT EXISTS christian.counter_pboc
(
finalID_ VARCHAR(15),
finalID__ VARCHAR(15),
year CHAR(4),	
counterof VARCHAR(15),
class CHAR(6),	
ncount CHAR(1)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/counterpboc.csv' INTO TABLE christian.counter_pboc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 695.680 rows affected (1,21 sec)
Records: 695680  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.counter_pboc; 
ALTER TABLE christian.counter_pboc ADD INDEX(finalID_);
ALTER TABLE christian.counter_pboc ADD INDEX(finalID__);

--------------------------------------------
-- Social distance pboc
--------------------------------------------
DROP TABLE IF EXISTS christian.socialdis_pboc;
CREATE TABLE IF NOT EXISTS christian.socialdis_pboc
(
undid VARCHAR(50), 
undid_ VARCHAR(50),
socialdist VARCHAR(5),
finalID VARCHAR(15), 
finalID_ VARCHAR(15),
EARLIEST_FILING_YEAR CHAR(4)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/socialdis_pboc.csv' INTO TABLE christian.socialdis_pboc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 436093 rows affected (1,13 sec)
Records: 436093  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.socialdis_pboc; 
ALTER TABLE christian.socialdis_pboc ADD INDEX(undid);
ALTER TABLE christian.socialdis_pboc ADD INDEX(undid_);

--------------------------------------------
-- Institutional distance pboc
--------------------------------------------
DROP TABLE IF EXISTS christian.insdis_pboc;
CREATE TABLE IF NOT EXISTS christian.insdis_pboc
(
finalID VARCHAR(15), 
finalID_ VARCHAR(15),
insprox CHAR(1),
shareins VARCHAR(50),
EARLIEST_FILING_YEAR CHAR(4),
undid VARCHAR(50)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/insdis_pboc.csv' INTO TABLE christian.insdis_pboc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 505742 rows affected (0,98 sec)
Records: 505742  Deleted: 0  Skipped: 0  Warnings: 0

*/

SHOW INDEX FROM christian.insdis_pboc; 
ALTER TABLE christian.insdis_pboc ADD INDEX(undid);

--------------------------------------------
-- Degree centrality pboc
--------------------------------------------
DROP TABLE IF EXISTS christian.degree_pboc;
CREATE TABLE IF NOT EXISTS christian.degree_pboc
(
degreecen VARCHAR(5),
finalID VARCHAR(15), 
EARLIEST_FILING_YEAR CHAR(4),
yfinalID VARCHAR(20)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/degree_pboc.csv' INTO TABLE christian.degree_pboc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 170390 rows affected (0,31 sec)
Records: 170390  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.degree_pboc; 
ALTER TABLE christian.degree_pboc ADD INDEX(yfinalID);


--------------------------------------------
-- Geographic distances pboc
--------------------------------------------
DROP TABLE IF EXISTS christian.geodis_locid_pboc;
CREATE TABLE IF NOT EXISTS christian.geodis_locid_pboc
(
geodis VARCHAR(50),
locid VARCHAR(100)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/sql/geodis_locidpboc_list.csv' INTO TABLE christian.geodis_locid_pboc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*

Query OK, 963986 rows affected (1,86 sec)
Records: 963986  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.geodis_locid_pboc; 
ALTER TABLE christian.geodis_locid_pboc ADD INDEX(locid);


