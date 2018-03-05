---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- GET ONLY PATENTS IN WHICH ALL AUTHORS BELONGING TO A TEAM COME FROM THE USA
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- 1. Run first: get_country_atleastone_us

-- 2. THEN EXTRACT ALL AUTHOR'S COUNTRY OF THE PATENTS
DROP TABLE IF EXISTS patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA;
CREATE TABLE patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA AS
SELECT DISTINCT a.APPLN_ID, a.pat, b.PERSON_CTRY_CODE
      FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat b
      ON a.APPLN_ID=b.APPLN_ID
      WHERE b.INVT_SEQ_NR>'0';
/*
Query OK, 1181141 rows affected (1 min 18,91 sec)
Records: 1181141  Duplicates: 0  Warnings: 0
*/

SELECT COUNT(DISTINCT a.pat) FROM patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA a WHERE a.PERSON_CTRY_CODE=''; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                  2336 |
+-----------------------+
1 row in set (0,55 sec)


PROBLEM: NOT ALL INVENTORS HAVE INFORMATION ON ADDRESS: EVEN THE COUNTRY IS NOT IDENTIFIED. SO, SHOULD I DEFINE THAT A TEAM IS FROM THE USA IF ALL INVENTORS COME FROM THE USA, BUT THERE IS A MISSING VALUE?
BY NOW, I WILL OMIT THOSE WHO DO NOT HAVE AN US ADDRESS TO DEFINE A TEAM (so, if some inventors do not have the country information, but all the other members of the team come from the US, there are going to be considered in the sample 
*/



DROP TABLE IF EXISTS patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA;
CREATE TABLE patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA AS
SELECT DISTINCT a.APPLN_ID, a.pat, b.PERSON_CTRY_CODE
      FROM riccaboni.t01_allclasses_appid_patstat_us_atleastone a 
      INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat b
      ON a.APPLN_ID=b.APPLN_ID
      WHERE b.INVT_SEQ_NR>'0' AND b.PERSON_CTRY_CODE!='';
/*
Query OK, 1178805 rows affected (1 min 18,75 sec)
Records: 1178805  Duplicates: 0  Warnings: 0
*/

SELECT * FROM patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA LIMIT 0,150;

-- 3. THEN COLLAPSE, WHERE THERE IS JUST ONE DIFFERENT NATIONALITY (WHICH IS THE US, BECAUSE OF THE USE OF riccaboni.t01_allclasses_appid_patstat_us

DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid_patstat_us_allteam;
CREATE TABLE riccaboni.t01_allclasses_appid_patstat_us_allteam AS
SELECT DISTINCT a.APPLN_ID, a.pat, COUNT(a.PERSON_CTRY_CODE)
      FROM patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA a 
      GROUP BY a.APPLN_ID, a.pat
      HAVING COUNT(a.PERSON_CTRY_CODE)=1;
/*
Query OK, 967413 rows affected (18,98 sec)
Records: 967413  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_allteam;                                     
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us_allteam ADD PRIMARY KEY(APPLN_ID);
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us_allteam ADD INDEX(pat);


SELECT * FROM riccaboni.t01_allclasses_appid_patstat_us_allteam LIMIT 0,100;

-- So, the final number of patents in which all the team resides in the USA (considering missing countries) is 967.413


