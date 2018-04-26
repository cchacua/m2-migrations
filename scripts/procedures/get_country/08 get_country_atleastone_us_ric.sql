SHOW INDEX FROM riccaboni.t08_names_allclasses_t01;                                     
ALTER TABLE riccaboni.t08_names_allclasses_t01 ADD INDEX(loc);
SHOW INDEX FROM christian.ric_us_co; 
ALTER TABLE christian.ric_us_co ADD INDEX(loc);

-- 1 - Patents with at least one inventor in the US
DROP TABLE IF EXISTS riccaboni.t08_allclasses_t01_loc;
CREATE TABLE riccaboni.t08_allclasses_t01_loc AS
SELECT DISTINCT a.pat
      FROM riccaboni.t08_names_allclasses_t01 a 
      INNER JOIN christian.ric_us_co b
      ON a.loc=b.loc;
/*
Query OK, 1167019 rows affected (1 min 12,43 sec)
Records: 1167019  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc; 
ALTER TABLE riccaboni.t08_allclasses_t01_loc ADD INDEX(pat);

SELECT * FROM riccaboni.t08_allclasses_t01_loc LIMIT 0,10;


-- 2. THEN EXTRACT ALL AUTHOR'S COUNTRY OF THE PATENTS

DROP TABLE IF EXISTS riccaboni.t08_allclasses_t01_loc_ao;
CREATE TABLE riccaboni.t08_allclasses_t01_loc_ao AS
SELECT DISTINCT a.pat, c.isin
      FROM riccaboni.t08 a 
      INNER JOIN riccaboni.t08_allclasses_t01_loc b
      ON a.pat=b.pat
      LEFT JOIN christian.ric_us_co c
      ON a.loc=c.loc;
/*
Query OK, 1293197 rows affected (2 min 8,23 sec)
Records: 1293197  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc_ao; 
ALTER TABLE riccaboni.t08_allclasses_t01_loc_ao ADD INDEX(pat);

SELECT * FROM riccaboni.t08_allclasses_t01_loc_ao LIMIT 0,100;

-- 3. THEN COLLAPSE, WHERE THERE IS JUST ONE DIFFERENT NATIONALITY (WHICH IS THE US, 
-- BECAUSE OF THE USE OF riccaboni.t08_allclasses_t01_loc)

DROP TABLE IF EXISTS riccaboni.t08_allclasses_t01_loc_allteam;
CREATE TABLE riccaboni.t08_allclasses_t01_loc_allteam AS
SELECT DISTINCT a.pat, COUNT(IFNULL(a.isin, 'FALSE'))
      FROM riccaboni.t08_allclasses_t01_loc_ao a 
      GROUP BY a.pat
      HAVING COUNT(IFNULL(a.isin, 'FALSE'))=1;
/*
Query OK, 1040841 rows affected (17,34 sec)
Records: 1040841  Duplicates: 0  Warnings: 0
*/
SHOW INDEX FROM riccaboni.t08_allclasses_t01_loc_allteam; 
ALTER TABLE riccaboni.t08_allclasses_t01_loc_allteam ADD INDEX(pat);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_allteam; 

-- Compare with patstat: at least one in US
DROP TABLE IF EXISTS christian.ric_us_ao_diff;
CREATE TABLE christian.ric_us_ao_diff AS
SELECT DISTINCT a.pat
      FROM riccaboni.t08_allclasses_t01_loc a 
      LEFT JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat
      WHERE b.pat IS NULL;
/*
Query OK, 111175 rows affected (12,72 sec)
Records: 111175  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_ao_diff; 
ALTER TABLE christian.ric_us_ao_diff ADD INDEX(pat);

-- Compare with patstat: all us
DROP TABLE IF EXISTS christian.ric_us_co_diff;
CREATE TABLE christian.ric_us_co_diff AS
SELECT DISTINCT a.pat
      FROM riccaboni.t08_allclasses_t01_loc_allteam a 
      LEFT JOIN riccaboni.t01_allclasses_appid_patstat_us_allteam b
      ON a.pat=b.pat
      WHERE b.pat IS NULL;

SHOW INDEX FROM christian.ric_us_co_diff; 
ALTER TABLE christian.ric_us_co_diff ADD INDEX(pat);

/*
Query OK, 100666 rows affected (11,93 sec)
Records: 100666  Duplicates: 0  Warnings: 0
So, there are 100.666 additional patents when doing with Riccaboni
*/

----------------------------------------------
-- IDs of diff at least one US

DROP TABLE IF EXISTS christian.ric_us_ao_diff_8;
CREATE TABLE christian.ric_us_ao_diff_8 AS
SELECT DISTINCT IFNULL(c.mobileID, a.ID) AS finalID
      FROM riccaboni.t08 a 
      INNER JOIN christian.ric_us_ao_diff b
      ON a.pat=b.pat
      LEFT JOIN riccaboni.t09 c
      ON a.ID=c.localID;
/*
Query OK, 149870 rows affected (28,32 sec)
Records: 149870  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_ao_diff_8;
ALTER TABLE christian.ric_us_ao_diff_8 ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.ric_us_ao_diff_8_aid;
CREATE TABLE christian.ric_us_ao_diff_8_aid AS
SELECT a.*
      FROM christian.ric_us_ao_diff_8 a 
      LEFT JOIN (SELECT DISTINCT c.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility c) b
      ON a.finalID=b.finalID
      WHERE b.finalID IS NULL;
/*
Query OK, 34828 rows affected (6,71 sec)
Records: 34828  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.ric_us_ao_diff_8_aid;
ALTER TABLE christian.ric_us_ao_diff_8_aid ADD INDEX(finalID);


DROP TABLE IF EXISTS christian.ric_us_ao_diff_8_aid_n;
CREATE TABLE christian.ric_us_ao_diff_8_aid_n AS
SELECT DISTINCT a.finalID, a.name, CHAR_LENGTH(a.name) AS ncharac, 
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' ', ''))) / CHAR_LENGTH(' ')) AS nblanks,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, '.', ''))) / CHAR_LENGTH('.')) AS ndots,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ',', ''))) / CHAR_LENGTH(',')) AS ncommas,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' , ', ''))) / CHAR_LENGTH(' , ')) AS ncommasblanksboth,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ' ,', ''))) / CHAR_LENGTH(' ,')) AS ncommasblanksleft,
           ROUND ((CHAR_LENGTH(a.name)- CHAR_LENGTH(REPLACE(a.name, ', ', ''))) / CHAR_LENGTH(', ')) AS ncommasblanksright,
           IF(a.name REGEXP '[0-9]', '1', '0') AS hnumber
FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a INNER JOIN christian.ric_us_ao_diff_8_aid b ON a.finalID=b.finalID;


SELECT a.* FROM riccaboni.t08 a WHERE a.ID='HI104214'



--christian.id_nat 
------------------------------------------------------
--
DROP TABLE IF EXISTS christian.ric_us_co_diff_app2;
CREATE TABLE christian.ric_us_co_diff_app2 AS
SELECT DISTINCT a.pat
      FROM christian.ric_us_co_diff a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone b
      ON a.pat=b.pat;
/*
Query OK, 2002 rows affected (0,89 sec)
Records: 2002  Duplicates: 0  Warnings: 0
*/

DROP TABLE IF EXISTS christian.ric_us_co_diff_app;
CREATE TABLE christian.ric_us_co_diff_app AS
SELECT DISTINCT a.pat
      FROM christian.ric_us_co_diff a 
      INNER JOIN riccaboni.t01_allclasses_appid_patstat b
      ON a.pat=b.pat;
/*
Query OK, 63868 rows affected (2,37 sec)
Records: 63868  Duplicates: 0  Warnings: 0
*/



