-----------------------------------------------------------------------------------------------
-- PCT Nationality
-----------------------------------------------------------------------------------------------

--
use pct;
--

-----------------------------------------------------------------------------------------------
-- NAT
-----------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/pct/inventors_names_patstat.csv' INTO TABLE NAT
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.NAME), CHAR_LENGTH(b.NAME) AS Nchar
                              FROM pct.NAT b
                              GROUP BY CHAR_LENGTH(b.NAME);
                              
SELECT COUNT(DISTINCT b.RELATION_TYPE_ID), CHAR_LENGTH(b.RELATION_TYPE_ID) AS Nchar
                              FROM pct.NAT b
                              GROUP BY CHAR_LENGTH(b.RELATION_TYPE_ID);
                              
SELECT COUNT(DISTINCT b.appln_nr), CHAR_LENGTH(b.appln_nr) AS Nchar
                              FROM pct.NAT b
                              GROUP BY CHAR_LENGTH(b.appln_nr);  
                              
SELECT COUNT(DISTINCT b.appln_id), CHAR_LENGTH(b.appln_id) AS Nchar
                              FROM pct.NAT b
                              GROUP BY CHAR_LENGTH(b.appln_id);                                   
*/


-----------------------------------------------------------------------------------------------
-- REG
-----------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/pct/regpat_pct_inv_reg_nationality.csv' INTO TABLE REG
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;