--
use uspto;
--


-----------------------------------------------------------------------------------------------
-- PVIEW
-----------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/uspto-patentview/application.tsv' INTO TABLE PVIEW
FIELDS TERMINATED BY '\t'
IGNORE 1 LINES ;
SHOW WARNINGS;


SELECT COUNT(DISTINCT b.number), CHAR_LENGTH(b.number) AS Nchar
                              FROM uspto.PVIEW b
                              GROUP BY CHAR_LENGTH(b.number);
/*
+--------------------------+-------+
| COUNT(DISTINCT b.number) | Nchar |
+--------------------------+-------+
|                    19648 |     7 |
|                  6337820 |     8 |
+--------------------------+-------+
2 rows in set (16,70 sec)

*/

-----------------------------------------------------------------------------------------------
-- PID
-----------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/uspto-patentview/patentid_applnid.txt' INTO TABLE PID
FIELDS TERMINATED BY '\t'
IGNORE 1 LINES ;
SHOW WARNINGS;
