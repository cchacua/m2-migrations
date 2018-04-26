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


DROP TABLE IF EXISTS christian.ric_us_state;
CREATE TABLE IF NOT EXISTS christian.ric_us_state
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


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/output/spatial_eco/us_locations.csv' INTO TABLE christian.ric_us_state
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 127918 rows affected (0,35 sec)
Records: 127918  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_state; 
ALTER TABLE christian.ric_us_state ADD INDEX(loc);



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
loc VARCHAR(50)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/output/spatial_eco/us_locations_MA.csv' INTO TABLE christian.ric_us_ma
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
/*
Query OK, 92846 rows affected (0,30 sec)
Records: 92846  Deleted: 0  Skipped: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_ma; 
ALTER TABLE christian.ric_us_ma ADD INDEX(loc);
