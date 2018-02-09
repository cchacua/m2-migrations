---------------------------------------------------------------------------------------------------
--  invpat
---------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/li_uspto/invpat.csv' INTO TABLE invpat
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

SELECT COUNT(DISTINCT b.Firstname), CHAR_LENGTH(b.Firstname) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Firstname);


