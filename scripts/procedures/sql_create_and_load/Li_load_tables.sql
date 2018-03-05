---------------------------------------------------------------------------------------------------
--  invpat
---------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/li_uspto/invpat.csv' INTO TABLE li.invpat
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.Firstname), CHAR_LENGTH(b.Firstname) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Firstname);

SELECT COUNT(DISTINCT b.Lastname), CHAR_LENGTH(b.Lastname) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Lastname);

SELECT COUNT(DISTINCT b.Street), CHAR_LENGTH(b.Street) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Street);

SELECT COUNT(DISTINCT b.Assignee), CHAR_LENGTH(b.Assignee) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Assignee);

SELECT COUNT(DISTINCT b.Patent), CHAR_LENGTH(b.Patent) AS Nchar
                              FROM li.invpat b
                              GROUP BY CHAR_LENGTH(b.Patent);

SELECT * FROM li.invpat LIMIT 0,10;

*/


---------------------------------------------------------------------------------------------------
--  patent
---------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/li_uspto/patent.csv' INTO TABLE li.patent
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
Query OK, 4.243.972 rows affected (10,22 sec)
Records: 4243972  Deleted: 0  Skipped: 0  Warnings: 0

SELECT COUNT(DISTINCT b.AppNum), CHAR_LENGTH(b.AppNum) AS Nchar
                              FROM li.patent b
                              GROUP BY CHAR_LENGTH(b.AppNum);

SELECT * FROM li.patent a WHERE a.AppType!='' LIMIT 0,10;
*/

---------------------------------------------------------------------------------------------------
--  usreldoc
---------------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/li_uspto/usreldoc.csv' INTO TABLE li.usreldoc
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  ESCAPED BY ''
lines terminated by '\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
Query OK, 1.428.471 rows affected (3,10 sec)
Records: 1428471  Deleted: 0  Skipped: 0  Warnings: 0

SELECT COUNT(DISTINCT b.Kind), CHAR_LENGTH(b.Kind) AS Nchar
                              FROM li.usreldoc b
                              GROUP BY CHAR_LENGTH(b.Kind);

SELECT * FROM li.usreldoc LIMIT 0,10;
*/


