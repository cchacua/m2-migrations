---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using EP_CITATIONS and creating a new table riccaboni.t01_allclasses_ep_appid
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_ep_appid; 
CREATE TABLE riccaboni.t01_allclasses_ep_appid AS
SELECT DISTINCT a.pat, c.APPLN_ID
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pat, b.Citing_appln_id AS APPLN_ID
                        FROM oecd_citations.EP_CITATIONS b) c 
    ON  a.pat=c.pat;  

/*
Query OK, 705255 rows affected (1 min 9,81 sec)
Records: 705255  Duplicates: 0  Warnings: 0
*/



---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using EP_CITATIONS
---------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT c.pnumber)
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pnumber
                        FROM oecd_citations.EP_CITATIONS b) c 
    ON  a.pat=c.pnumber;  


/*
+---------------------------+
| COUNT(DISTINCT c.pnumber) |
+---------------------------+
|                    705255 |
+---------------------------+
1 row in set (55,39 sec)

705255 MERGE  VS 705255 RICCABONNI
*/


---------------------------------------------------------------------------------------------------
-- Using new table riccaboni.t01_allclasses_ep_appid
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_ep_appid a; 
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                     705255 |
+----------------------------+
1 row in set (1,31 sec)
*/

SELECT COUNT(DISTINCT a.pat)
	FROM riccaboni.t01_allclasses_ep_appid a; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                705255 |
+-----------------------+
1 row in set (1,97 sec)
*/

---------------------------------------------------------------------------------------------------
-- Using EP_CITATIONS and PATSTAT
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t01_allclasses_ep_appid;                                     
ALTER TABLE riccaboni.t01_allclasses_ep_appid ADD PRIMARY KEY(APPLN_ID);

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_ep_appid a
	INNER JOIN patstat2016b.TLS201_APPLN c
	ON a.APPLN_ID=c.APPLN_ID; 
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                     705255 |
+----------------------------+
1 row in set (3,77 sec)
So all EP APPLN_ID can be found in Patstat
*/  
