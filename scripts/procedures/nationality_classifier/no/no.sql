---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES, WITH MOBILITY LINKS
-- riccaboni.t08_names_allclasses_us_mob_atleastone
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM riccaboni.t09;                                     
ALTER TABLE riccaboni.t09 ADD INDEX(localID);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_family;


DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_us_mob_atleastone;
CREATE TABLE riccaboni.t08_names_allclasses_us_mob_atleastone AS
SELECT a.*, b.mobileID, d.APPLN_ID, d.DOCDB_FAMILY_ID
      FROM riccaboni.t08_names_allclasses_us_atleastone a 
      LEFT JOIN riccaboni.t09 b
      ON a.ID=b.localID
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_atleastone c 
      ON a.pat=c.pat
      INNER JOIN riccaboni.t01_allclasses_appid_patstat_us_family d
      ON c.APPLN_ID = d.APPLN_ID;
/*
Query OK, 3122408 rows affected (2 min 6,72 sec)
Records: 3122408  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t08_names_allclasses_us_mob_atleastone;
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(DOCDB_FAMILY_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(APPLN_ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(ID);
ALTER TABLE riccaboni.t08_names_allclasses_us_mob_atleastone ADD INDEX(pat);

SELECT COUNT(DISTINCT a.ID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      WHERE a.mobileID IS NOT NULL;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|               179547 |
+----------------------+
1 row in set (3,00 sec)

*/

SELECT COUNT(DISTINCT a.mobileID)       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
+----------------------------+
| COUNT(DISTINCT a.mobileID) |
+----------------------------+
|                     105256 |
+----------------------------+
1 row in set (3,57 sec)

So, there are 74.291 less IDS, when using the mobile inventor links

SELECT COUNT(DISTINCT b.mobileID), CHAR_LENGTH(b.mobileID) AS Nchar
                              FROM riccaboni.t08_names_allclasses_us_mob_atleastone b
                              GROUP BY CHAR_LENGTH(b.mobileID);
+----------------------------+-------+
| COUNT(DISTINCT b.mobileID) | Nchar |
+----------------------------+-------+
|                          0 |  NULL |
|                          8 |     3 |
|                         67 |     4 |
|                        585 |     5 |
|                       4835 |     6 |
|                      32829 |     7 |
|                      66932 |     8 |
+----------------------------+-------+
7 rows in set (3,71 sec)

*/


---------------------------------------------------------------------------------------------------
-- File
---------------------------------------------------------------------------------------------------  

SELECT DISTINCT a.ID, a.name, a.mobileID       
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a
      INTO OUTFILE '/var/lib/mysql-files/Names_ID_Mobile_Classes.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
/*


*/
