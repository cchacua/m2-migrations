---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using WO_CITATIONS and creating a new table riccaboni.t01_allclasses_wo_appid
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_wo_appid; 
CREATE TABLE riccaboni.t01_allclasses_wo_appid AS
SELECT DISTINCT a.pat, c.APPLN_ID
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pat, b.Citing_appln_id AS APPLN_ID
                        FROM oecd_citations.WO_CITATIONS b) c 
    ON  a.pat=c.pat;  

/*
Query OK, 693718 rows affected (1 min 41,62 sec)
Records: 693718  Duplicates: 0  Warnings: 0

*/



---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using WO_CITATIONS
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT c.pnumber)
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pnumber
                        FROM oecd_citations.WO_CITATIONS b) c 
    ON  a.pat=c.pnumber;  

/*
+---------------------------+
| COUNT(DISTINCT c.pnumber) |
+---------------------------+
|                    693718 |
+---------------------------+
1 row in set (1 min 17,81 sec)

693.718 MERGE  VS 693.722 RICCABONNI
*/


---------------------------------------------------------------------------------------------------
-- Using new table riccaboni.t01_allclasses_wo_appid
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_wo_appid a; 
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                     693718 |
+----------------------------+
1 row in set (1,76 sec)
*/

SELECT COUNT(DISTINCT a.pat)
	FROM riccaboni.t01_allclasses_wo_appid a; 
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                693718 |
+-----------------------+
1 row in set (2,57 sec)
*/

-- IDENTIFY 4 MISSING PATENTS

SELECT a.pat
    FROM riccaboni.t01_allclasses a
    LEFT JOIN (SELECT DISTINCT b.pat
                      FROM riccaboni.t01_allclasses_wo_appid b) c                    
    ON a.pat=c.pat
    WHERE LEFT(a.pat,2)='WO' AND c.pat IS NULL;
/*
+--------------+
| pat          |
+--------------+
| WO1991007436 |
| WO1996040129 |
| WO1997013491 |
| WO2002200081 |
+--------------+
4 rows in set (12,45 sec)
*/


---------------------------------------------------------------------------------------------------
-- Using WO_CITATIONS and PATSTAT
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t01_allclasses_wo_appid;
ALTER TABLE riccaboni.t01_allclasses_wo_appid ADD PRIMARY KEY(APPLN_ID);

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_wo_appid a
	INNER JOIN patstat2016b.TLS201_APPLN c
	ON a.APPLN_ID=c.APPLN_ID; 
/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                     693716 |
+----------------------------+
1 row in set (3,79 sec)
So NOT ALL WO APPLN_ID can be found in Patstat. There are two missing APPLN_ID
*/  


-- Two additional missing patents
SELECT DISTINCT b.APPLN_ID, b.pat 
	FROM riccaboni.t01_allclasses_wo_appid b 
	LEFT JOIN (SELECT DISTINCT a.APPLN_ID FROM riccaboni.t01_allclasses_wo_appid a INNER JOIN patstat2016b.TLS201_APPLN c ON a.APPLN_ID=c.APPLN_ID) d
	ON b.APPLN_ID=d.APPLN_ID
	WHERE d.APPLN_ID IS NULL;
/*
+-----------+--------------+
| APPLN_ID  | pat          |
+-----------+--------------+
| 376948519 | WO2001075584 |
| 376948520 | WO2001075630 |
+-----------+--------------+
2 rows in set (12,40 sec)
*/


---------------------------------------------------------------------------------------------------
-- Using WO_EQUIVALENTS
---------------------------------------------------------------------------------------------------
SELECT * FROM oecd_citations.WO_EQUIVALENTS a WHERE a.Eqv_pub_nbr IN ('WO1991007436','WO1996040129','WO1997013491','WO2002200081','WO2001075584','WO2001075630');
/*Empty*/


/*
SO, IN TOTAL THERE ARE SIX PCT MISSING PATENT APPLICATIONS. THIS IS DUE TO THE FACT THAT THEY WERE VOID
Information retrieved from WIPO's Patent Scope


'WO1991007436', Considered void 1991-05-24 00:00:00.0
		No national office info	

'WO1996040129', Considered void 1996-12-13 00:00:00.0 demande internationale considérée comme retirée 1996-12-13 00:00:00.
		Office		Entry Date	National Number		National Status
		Mexico		13.12.1996	PA/a/1996/006404	Refused: 13.12.1996
		Canada		12.12.1996	2192796		Refused: 13.12.1996
		New Zealand	12.12.1996	311360		Refused: 13.12.1996

'WO1997013491', Considered void 1997-03-26 00:00:00.0 
		Office			Entry Date	National Number	National Status
		European Patent Office	10.07.1997	1996936364	Refused: 26.03.1997
									Withdrawn: 09.05.2001
'WO2002200081', No info


'WO2001075584',
		Office			Entry Date	National Number	National Status
		European Patent Office	29.10.2002	2001923006	Published: 23.07.2003
									Withdrawn: 27.02.2008
'WO2001075630'
		Office			Entry Date	National Number	National Status
		European Patent Office	29.10.2002	2001923008	Published: 28.05.2003
									Withdrawn: 27.02.2008
*/


