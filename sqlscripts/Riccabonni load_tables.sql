
use riccaboni;

--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/all_disambiguated_patents_withLocal.txt' INTO TABLE t01
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
-- CORRECT FILE 2, BECAUSE IT DOES NOT HAVE A PRIMARY KEY
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/Citation_AppExa.txt' INTO TABLE t02
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;

-- 06 ATTENTION, THE DELIMITER CHANGES
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/IPC_to_Industry_WIPOJan2013.txt' INTO TABLE t06
FIELDS TERMINATED BY '\t'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/LinkedAssigneeNameLocData.txt' INTO TABLE t07
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/LinkedInventorNameLocData.txt' INTO TABLE t08
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/mobilityLinks.txt' INTO TABLE t09
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/Patent_classes.txt' INTO TABLE t10
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/patent_to_triadic_family.txt' INTO TABLE t11
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/USPC_to_IPC_fullList.txt' INTO TABLE t12
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
--
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/wipo_class_ID.txt' INTO TABLE t13
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;