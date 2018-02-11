--------------------------------------------------------------------------------
-- TLS206
--------------------------------------------------------------------------------

use patstat2016b;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part01.txt' INTO TABLE TLS206_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part02.txt' INTO TABLE TLS206_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part03.txt' INTO TABLE TLS206_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part04.txt' INTO TABLE TLS206_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part05.txt' INTO TABLE TLS206_PERSON CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls206_part06.txt' INTO TABLE TLS206_PERSON CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

--------------------------------------------------------------------------------
-- TLS906 (instead of 206)
--------------------------------------------------------------------------------

use patstat2016b;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part01.txt' INTO TABLE TLS906_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part02.txt' INTO TABLE TLS906_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part03.txt' INTO TABLE TLS906_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part04.txt' INTO TABLE TLS906_PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part05.txt' INTO TABLE TLS906_PERSON CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls906_part06.txt' INTO TABLE TLS906_PERSON CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

--------------------------------------------------------------------------------
-- TLS207_PERS_APPLN
--------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls207_part01.txt' INTO TABLE TLS207_PERS_APPLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls207_part02.txt' INTO TABLE TLS207_PERS_APPLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw2/tls207_part03.txt' INTO TABLE TLS207_PERS_APPLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
