-- Can be used as a reference:
-- http://rawpatentdata.blogspot.fr/2014/03/mysql-script-for-importing-oecd-regpat.html

use oecd;

-- treg07 Inventor data
LOAD DATA LOCAL INFILE '/media/christian/Server1/Github/m2-migrations/data/regpat201602/201602_PCT_Inv_reg.txt' INTO TABLE treg07
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

-- treg03 Inventor data
LOAD DATA LOCAL INFILE '/media/christian/Server1/Github/m2-migrations/data/regpat201602/201602_EPO_Inv_reg.txt' INTO TABLE treg03
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

-- tqual03 Patent quality US
LOAD DATA LOCAL INFILE '/media/christian/Server1/Github/m2-migrations/data/patentquality201709/201709_OECD_PATENT_QUALITY_USPTO.txt' INTO TABLE tqual03
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;