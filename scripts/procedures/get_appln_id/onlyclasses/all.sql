---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid; 
CREATE TABLE riccaboni.t01_allclasses_appid AS
SELECT *
    FROM riccaboni.t01_allclasses_ep_appid
UNION
SELECT *
    FROM riccaboni.t01_allclasses_us_appid
UNION
SELECT *
    FROM riccaboni.t01_allclasses_wo_appid;

/*
Query OK, 2379115 rows affected (31,54 sec)
Records: 2379115  Duplicates: 0  Warnings: 0

2379115 WITH ID VS 2443177 ALL RICCABONI, SO 64062 PATENTS ARE MISSING + THE ONES THAT CANNOT BE FOUND IN PATSTAT
*/


SELECT DISTINCT b.APPLN_ID, b.pat 
	FROM riccaboni.t01_allclasses_appid b 
	LEFT JOIN (SELECT DISTINCT a.APPLN_ID FROM riccaboni.t01_allclasses_appid a INNER JOIN patstat2016b.TLS201_APPLN c ON a.APPLN_ID=c.APPLN_ID) d
	ON b.APPLN_ID=d.APPLN_ID
	WHERE d.APPLN_ID IS NULL;

/*
So, there are four more missing patents
+-----------+--------------+
| APPLN_ID  | pat          |
+-----------+--------------+
| 459353324 | US07235378   |
| 474189140 | US07656793   |
| 376948519 | WO2001075584 |
| 376948520 | WO2001075630 |
+-----------+--------------+
4 rows in set (1 min 0,61 sec)
*/

DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid_patstat; 
CREATE TABLE riccaboni.t01_allclasses_appid_patstat AS
SELECT DISTINCT a.APPLN_ID, a.pat
    FROM riccaboni.t01_allclasses_appid a 
    INNER JOIN patstat2016b.TLS201_APPLN c 
    ON a.APPLN_ID=c.APPLN_ID;
/*
Query OK, 2379111 rows affected (46,62 sec)
Records: 2379111  Duplicates: 0  Warnings: 0
*/
DROP TABLE IF EXISTS riccaboni.t01_allclasses_appid; 


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- So, the final table to USE IS riccaboni.t01_allclasses_appid_patstat
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.pat)
	FROM riccaboni.t01_allclasses_appid_patstat a; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|               2379111 |
+-----------------------+
1 row in set (6,33 sec)
*/
SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_appid_patstat a; 
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    2379110 |
+----------------------------+
1 row in set (5,41 sec)
*/

SELECT  a.*, b.totalCount AS Duplicate
FROM    riccaboni.t01_allclasses_appid_patstat a
        INNER JOIN
        (
            SELECT  c.APPLN_ID, COUNT(*) totalCount
            FROM    riccaboni.t01_allclasses_appid_patstat c
            GROUP   BY c.APPLN_ID
            HAVING  COUNT(*) >= 2
        ) b ON a.APPLN_ID = b.APPLN_ID;
/*
There are two patents with the same APPLN_ID
+----------+------------+-----------+
| APPLN_ID | pat        | Duplicate |
+----------+------------+-----------+
| 48692432 | US06658622 |         2 |
| 48692432 | US06964010 |         2 |
+----------+------------+-----------+
2 rows in set (23,96 sec)

It seems to be the same patent, but an inventor was deleted from the list
https://www.google.com.pg/patents/US6658622

US 6658622 B1 2 déc. 2003
US 6964010 B1 Nov. 8, 2005 
*/

---------------------------------------------------------------------------------------------------
-- All relevant patents by authority
---------------------------------------------------------------------------------------------------

SELECT COUNT(*), LEFT(a.pat,2)
      FROM riccaboni.t01_allclasses_appid_patstat a
      GROUP BY LEFT(a.pat,2);

SHOW INDEX FROM riccaboni.t01_allclasses_appid_patstat;                                     
ALTER TABLE riccaboni.t01_allclasses_appid_patstat ADD PRIMARY KEY(pat);
      
---------------------------------------------------------------------------------------------------
-- All relevant patents by authority from 1975-2013
---------------------------------------------------------------------------------------------------
SELECT COUNT(*), LEFT(a.pat,2)
      FROM riccaboni.t01_allclasses_appid_patstat a
      INNER JOIN riccaboni.t01_allclasses b
      ON a.pat=b.pat
      WHERE b.yr>='1975' AND b.yr<='2013'
      GROUP BY LEFT(a.pat,2);

---------------------------------------------------------------------------------------------------
-- All relevant patents by authority from 1980-2013
---------------------------------------------------------------------------------------------------

SELECT COUNT(*), LEFT(a.pat,2)
      FROM riccaboni.t01_allclasses_appid_patstat a
      INNER JOIN riccaboni.t01_allclasses b
      ON a.pat=b.pat
      WHERE b.yr>='1980' AND b.yr<='2013'
      GROUP BY LEFT(a.pat,2);   
      
