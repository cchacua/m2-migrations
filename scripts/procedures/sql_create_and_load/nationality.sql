
DROP TABLE IF EXISTS christian.id_nat;
CREATE TABLE IF NOT EXISTS christian.id_nat
(
nrow varchar(6),
finalID varchar(15),
nation varchar(50),
prob varchar(10),
cname VARCHAR(500),
name VARCHAR(500)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/nationality/nationality_all_names_only.csv' INTO TABLE christian.id_nat
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

SHOW INDEX FROM christian.id_nat;
ALTER TABLE christian.id_nat ADD INDEX(finalID);
