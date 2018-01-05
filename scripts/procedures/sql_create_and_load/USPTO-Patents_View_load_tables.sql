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
-----------------------------------------------------------------------------------------------
-- PID
-----------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/uspto-patentview/patentid_applnid.txt' INTO TABLE PID
FIELDS TERMINATED BY '\t'
IGNORE 1 LINES ;
SHOW WARNINGS;