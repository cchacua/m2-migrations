---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SHOW INDEX FROM patstat2016b.TLS201_APPLN;
ALTER TABLE patstat2016b.TLS201_APPLN ADD PRIMARY KEY(APPLN_ID);


SELECT COUNT(DISTINCT b.DOCDB_FAMILY_ID)
    FROM riccaboni.t01_allclasses_appid_patstat_us a
    INNER JOIN patstat2016b.TLS201_APPLN b
    ON a.APPLN_ID = b.APPLN_ID;

/*
+-----------------------------------+
| COUNT(DISTINCT b.DOCDB_FAMILY_ID) |
+-----------------------------------+
|                            779698 |
+-----------------------------------+
1 row in set (12,17 sec)


So, there is patent inflation (overcounting of patents) 1.206237 PATENTS vs  779.698 FAMILIES


*/


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid_patstat_us_family; 
CREATE TABLE riccaboni.t01_allclasses_appid_patstat_us_family AS
SELECT DISTINCT a.*, b.DOCDB_FAMILY_ID
    FROM riccaboni.t01_allclasses_appid_patstat_us a
    INNER JOIN patstat2016b.TLS201_APPLN b
    ON a.APPLN_ID = b.APPLN_ID;


SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat_us_family;
ALTER TABLE riccaboni.t01_allclasses_appid_patstat_us_family ADD INDEX(APPLN_ID);   
