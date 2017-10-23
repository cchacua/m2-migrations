-- TLS211

-- code by Gianluca Tarasconi under CC3.0 license Attribution-NonCommercial-ShareAlike Unported 
-- http://rawpatentdata.blogspot.com for more info

-- 2016a VERSION 

-- Modified by Christian Chacua

use patstat2016b;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls211_part01.txt' INTO TABLE TLS211_PAT_PUBLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls211_part02.txt' INTO TABLE TLS211_PAT_PUBLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls211_part03.txt' INTO TABLE TLS211_PAT_PUBLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls211_part04.txt' INTO TABLE TLS211_PAT_PUBLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/patstat2016b/raw/tls211_part05.txt' INTO TABLE TLS211_PAT_PUBLN
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
