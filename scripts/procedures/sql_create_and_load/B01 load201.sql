-- tls201 CREATION

-- code by Gianluca Tarasconi under CC3.0 license Attribution-NonCommercial-ShareAlike Unported 
-- http://rawpatentdata.blogspot.com for more info

-- 2016b VERSION
-- Modified by Christian Chacua
-- To run: mysql -h "localhost" -u "root" -p "patstat2016b" < "B01load201.sql"

use patstat2016b;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part01.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part02.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part03.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part04.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part05.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part06.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part07.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part08.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls201_part09.txt' INTO TABLE TLS201_APPLN
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY ''
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
