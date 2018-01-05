-----------------------------------------------------------------------------------------------
-- OECD Citations
-----------------------------------------------------------------------------------------------

--
use oecd_citations;
--

-----------------------------------------------------------------------------------------------
-- US_CITATIONS
-----------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_US_Citations_1.txt' INTO TABLE US_CITATIONS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_US_Citations_2.txt' INTO TABLE US_CITATIONS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_US_Citations_3.txt' INTO TABLE US_CITATIONS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_US_Citations_4.txt' INTO TABLE US_CITATIONS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.Citn_lag_year), CHAR_LENGTH(b.Citn_lag_year) AS Nchar
                              FROM oecd_citations.US_CITATIONS b
                              GROUP BY CHAR_LENGTH(b.Citn_lag_year);
*/


-----------------------------------------------------------------------------------------------
-- US_CIT_COUNTS
-----------------------------------------------------------------------------------------------

LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_US_Cit_Counts.txt' INTO TABLE US_CIT_COUNTS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.US_Pub_nbr), CHAR_LENGTH(b.US_Pub_nbr) AS Nchar
                              FROM oecd_citations.US_CIT_COUNTS b
                              GROUP BY CHAR_LENGTH(b.US_Pub_nbr);
                              
+------------------------------+-------+
| COUNT(DISTINCT b.US_Pub_nbr) | Nchar |
+------------------------------+-------+
|                      5438536 |     9 |
|                      1559533 |    12 |
+------------------------------+-------+
*/

-----------------------------------------------------------------------------------------------
-- WO_CITATIONS
-----------------------------------------------------------------------------------------------
LOAD DATA LOCAL INFILE '/media/christian/Server/Github/m2-migrations/data/oecd_citations/201709_WO_Citations.txt' INTO TABLE WO_CITATIONS
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
IGNORE 1 LINES ;
SHOW WARNINGS;

/*
SELECT COUNT(DISTINCT b.Citn_category), CHAR_LENGTH(b.Citn_category) AS Nchar
                              FROM oecd_citations.WO_CITATIONS b
                              GROUP BY CHAR_LENGTH(b.Citn_category);

SELECT COUNT(DISTINCT b.Citing_pub_nbr), CHAR_LENGTH(b.Citing_pub_nbr) AS Nchar
                              FROM oecd_citations.WO_CITATIONS b
                              GROUP BY CHAR_LENGTH(b.Citing_pub_nbr);

+----------------------------------+-------+
| COUNT(DISTINCT b.Citing_pub_nbr) | Nchar |
+----------------------------------+-------+
|                          2998017 |    12 |
+----------------------------------+-------+
1 row in set (46,50 sec)


                              
SELECT *
  FROM oecd_citations.WO_CITATIONS b
  WHERE CHAR_LENGTH(b.Citn_category)=5;
*/

-----------------------------------------------------------------------------------------------


