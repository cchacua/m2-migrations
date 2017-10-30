-- Can be used as a reference:
-- http://rawpatentdata.blogspot.fr/2014/03/mysql-script-for-importing-oecd-regpat.html

use oecd;

-- treg07 Inventor data
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/regpat201602/201602_PCT_Inv_reg.txt' INTO TABLE treg07
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;
