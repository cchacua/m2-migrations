---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT b.DOCDB_FAMILY_ID)
    FROM riccaboni.t01_allclasses_appid_patstat a
    INNER JOIN patstat2016b.TLS201_APPLN b
    ON a.APPLN_ID = b.APPLN_ID;

/*
+-----------------------------------+
| COUNT(DISTINCT b.DOCDB_FAMILY_ID) |
+-----------------------------------+
|                           1524496 |
+-----------------------------------+
1 row in set (24,06 sec)

So, there is overcounting of patents 2379110 PATENTS vs 1524496 FAMILIES
*/

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS riccaboni.t01_allclasses_family; 
CREATE TABLE riccaboni.t01_allclasses_family AS
SELECT DISTINCT a.*, b.DOCDB_FAMILY_ID
    FROM riccaboni.t01_allclasses_appid_patstat a
    INNER JOIN patstat2016b.TLS201_APPLN b
    ON a.APPLN_ID = b.APPLN_ID;