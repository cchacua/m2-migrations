
use riccaboni;

-- OK
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/all_disambiguated_patents_withLocal.txt' INTO TABLE t01
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;

-- 02  NO PRIMARY KEY
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/Citation_AppExa.txt' INTO TABLE t02
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;

-- 06 OK, BUT ATTENTION, THE DELIMITER CHANGES
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/IPC_to_Industry_WIPOJan2013.txt' INTO TABLE t06
FIELDS TERMINATED BY '\t'
IGNORE 1 LINES ;
SHOW WARNINGS;
-- 07 NO PRIMARY KEY, ATTENTION: NO HEADERS!
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/LinkedAssigneeNameLocData.txt' INTO TABLE t07
FIELDS TERMINATED BY '|';
SHOW WARNINGS;
-- 08 NO PRIMARY KEY, ATTENTION: NO HEADERS! 
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/LinkedInventorNameLocData.txt' INTO TABLE t08
FIELDS TERMINATED BY '|' ESCAPED BY '';
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.loc), CHAR_LENGTH(b.loc) AS Nchar
                              FROM riccaboni.t08 b
                              GROUP BY CHAR_LENGTH(b.loc);

+-----------------------+-------+
| COUNT(DISTINCT b.loc) | Nchar |
+-----------------------+-------+
|                     1 |     0 |
|                     1 |     7 |
|                    14 |     8 |
|                    48 |     9 |
|                    52 |    10 |
|                    75 |    11 |
|                   319 |    12 |
|                  1183 |    13 |
|                  6762 |    14 |
|                 43499 |    15 |
|                238269 |    16 |
|                565285 |    17 |
|                413997 |    18 |
|                341966 |    19 |
|                463445 |    20 |
|                150527 |    21 |
|                     7 |    22 |
+-----------------------+-------+
17 rows in set (41,69 sec)

SELECT COUNT(*) FROM riccaboni.t08 b;
+----------+
| COUNT(*) |
+----------+
| 25307460 |
+----------+

SELECT *
      FROM riccaboni.t08 b
      WHERE CHAR_LENGTH(b.loc) IN ('7','8','9','10');

SELECT COUNT(DISTINCT a.pat)
      FROM riccaboni.t08 a;

+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               9234879 |
+-----------------------+
1 row in set (1 min 12,30 sec)


SELECT COUNT(DISTINCT a.pat)
      FROM riccaboni.t01 a;
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               9290268 |
+-----------------------+
1 row in set (9,44 sec)

*/

-- 09 OK
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/mobilityLinks.txt' INTO TABLE riccaboni.t09
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(*) FROM riccaboni.t09 b;
+----------+
| COUNT(*) |
+----------+
|  1015484 |
+----------+
1 row in set (0,00 sec)


*/

-- 10 NO PRIMARY KEY
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/Patent_classes.txt' INTO TABLE t10
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
-- 11 OK
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/patent_to_triadic_family.txt' INTO TABLE t11
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
-- 12 NO PRIMARY KEY, 9 WARNINGS
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/USPC_to_IPC_fullList.txt' INTO TABLE t12
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
-- 13 OK
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/riccaboni/wipo_class_ID.txt' INTO TABLE t13
FIELDS TERMINATED BY '|'
IGNORE 1 LINES ;
SHOW WARNINGS;
