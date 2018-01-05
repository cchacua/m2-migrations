-- MERGE WO
-- For more information and tests, please refer to the file merge-t01-treg-t211.sql

-- To verify the number of characters
SELECT COUNT(*), CHAR_LENGTH(a.pat), LEFT(a.pat,2) AS Authority
      FROM riccaboni.t01 a
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,2);
      /*
      +----------+--------------------+-----------+
      | COUNT(*) | CHAR_LENGTH(a.pat) | Authority |
      +----------+--------------------+-----------+
      |  2684761 |                  9 | EP        |
      |  4243972 |                 10 | US        |
      |  2361535 |                 12 | WO        |
      +----------+--------------------+-----------+
      */

-- TO verify years in Riccaboni    
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    WHERE LEFT(a.pat,2)='WO'
    GROUP BY a.yr;     
/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|           10 |    0 |
|          407 | 1978 |
|         1503 | 1979 |
|         2381 | 1980 |
|         2854 | 1981 |
|         3443 | 1982 |
|         3772 | 1983 |
|         4212 | 1984 |
|         5998 | 1985 |
|         7044 | 1986 |
|         8041 | 1987 |
|        10762 | 1988 |
|        12876 | 1989 |
|        17951 | 1990 |
|        21260 | 1991 |
|        23511 | 1992 |
|        27221 | 1993 |
|        31951 | 1994 |
|        37617 | 1995 |
|        45211 | 1996 |
|        53837 | 1997 |
|        63335 | 1998 |
|        72369 | 1999 |
|        88766 | 2000 |
|       103444 | 2001 |
|       105769 | 2002 |
|       110053 | 2003 |
|       120257 | 2004 |
|       134200 | 2005 |
|       146956 | 2006 |
|       157034 | 2007 |
|       160070 | 2008 |
|       152219 | 2009 |
|       160787 | 2010 |
|       178417 | 2011 |
|       179479 | 2012 |
|       106517 | 2013 |
|            1 | 2014 |
+--------------+------+
38 rows in set (3,56 sec)
 Even in Riccaboni's database there are rows with year 0, despite the fact that it can be infered from the publication number
*/    
      
-- Verify beginning of WO patents
SELECT COUNT(*), CHAR_LENGTH(a.pat), LEFT(a.pat,6) AS Authority
      FROM riccaboni.t01 a
      WHERE LEFT(a.pat,2)='WO'
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,6);      
      
-- Verify beginning of WO patents in patstat
SELECT COUNT(*), CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_NR,4) AS Year
      FROM patstat2016b.TLS211_PAT_PUBLN a
      WHERE a.PUBLN_AUTH='WO'
      GROUP BY CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_NR,4);        
----------------------------------------------------------------------------------------
-- Make the merge
----------------------------------------------------------------------------------------

------------------------------
-- Using patstat

SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,4) BETWEEN 1978 AND 2014) c
    ON  a.pat=c.pnumber;
-- 1.568.014  vs 2.361.535

SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '20',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) IN ('00', '01','02','03','04','05','06','07','08','09','10','11','12','13','14')) c
    ON  a.pat=c.pnumber;
--  381.431 VS 335965


SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '19',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) BETWEEN 78 AND 99 ) c
    ON  a.pat=c.pnumber;
-- 412.118    

-- table containing all matched publication numbers
CREATE TABLE patstat2016b.twotest AS
SELECT c.pnumber
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,4) BETWEEN 1978 AND 2014) c
    ON  a.pat=c.pnumber
UNION ALL    
SELECT c.pnumber
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '20',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) IN ('00', '01','02','03','04','05','06','07','08','09','10','11','12','13','14')) c
    ON  a.pat=c.pnumber
UNION ALL    
SELECT c.pnumber
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '19',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) BETWEEN 78 AND 99 ) c
    ON  a.pat=c.pnumber;  
--  2361563 vs 2.361.535  because there are duplicates

SELECT COUNT(DISTINCT c.pnumber)
    FROM patstat2016b.twotest c;
--  2.361.512 vs 2.361.535



-- Extract only those that were not matched
-- Analyze those that were not matched
  
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.pnumber
                      FROM patstat2016b.twotest b) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL
    GROUP BY a.yr;    
/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|            9 |    0 |
|            1 | 1980 |
|            1 | 1987 |
|            4 | 2001 |
|            1 | 2003 |
|            2 | 2004 |
|            3 | 2005 |
|            2 | 2006 |
+--------------+------+    
*/

 
---------------------------------------------------------------------------------------------------
-- using regpat
---------------------------------------------------------------------------------------------------
SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT b.PCT_Nbr AS pnumber
                        FROM oecd.treg07 b) c 
    ON  a.pat=c.pnumber;    
    -- 2.345.816 vs 2.361.535

-- Analyze those that were not matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.PCT_Nbr AS pnumber
                        FROM oecd.treg07 b) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL
    GROUP BY a.yr;    
/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|            1 | 1979 |
|            1 | 1985 |
|            4 | 1987 |
|            1 | 1988 |
|            3 | 1990 |
|            1 | 1991 |
|            3 | 1992 |
|            1 | 1994 |
|            5 | 1995 |
|            1 | 1996 |
|            7 | 1997 |
|            4 | 1998 |
|            5 | 1999 |
|            9 | 2000 |
|           12 | 2001 |
|           21 | 2002 |
|           27 | 2003 |
|           45 | 2004 |
|           49 | 2005 |
|           41 | 2006 |
|          302 | 2007 |
|         2105 | 2008 |
|         3192 | 2009 |
|         2044 | 2010 |
|          366 | 2011 |
|         4845 | 2012 |
|         2624 | 2013 |
+--------------+------+
27 rows in set (1 min 6,26 sec)
*/    


-- Non-matched using both

SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.PCT_Nbr AS pnumber
                        FROM oecd.treg07 b) c
    ON  a.pat=c.pnumber                    
    LEFT JOIN (SELECT DISTINCT f.pnumber
                      FROM patstat2016b.twotest f) e                    
    ON a.pat=e.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL AND e.pnumber IS NULL;

SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.PCT_Nbr AS pnumber
                        FROM oecd.treg07 b) c
    ON  a.pat=c.pnumber                    
    LEFT JOIN (SELECT DISTINCT f.pnumber
                      FROM patstat2016b.twotest f) e                    
    ON a.pat=e.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL AND e.pnumber IS NULL
    INTO OUTFILE '/var/lib/mysql-files/non-matched-wo-both--.csv'
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n';  
  --1 patent is missing
/*
+--------------+------+
| pat          | yr   |
+--------------+------+
| WO2008204036 | 2006 |
+--------------+------+
1 row in set (1 min 36,65 sec)

*/  

-- The problem is that even if the other patents are in RegPat, they do not have the Appln_id
SELECT DISTINCT d.PCT_Nbr, d.Appln_id
    FROM oecd.treg07 d
    INNER JOIN (SELECT DISTINCT a.pat
                      FROM riccaboni.t01 a
                      LEFT JOIN (SELECT DISTINCT b.pnumber
                                        FROM patstat2016b.twotest b) c
                      ON  a.pat=c.pnumber
                      WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL) e
    ON d.PCT_Nbr =e.pat;  
/*
+--------------+----------+
| PCT_Nbr      | Appln_id |
+--------------+----------+
| WO1980020067 |          |
| WO1986009146 |          |
| WO1986092232 |          |
| WO1989007063 |          |
| WO1991007436 |          |
| WO1992096729 |          |
| WO1994027872 |          |
| WO1994027873 |          |
| WO1996040129 |          |
| WO1997013491 |          |
| WO1997040926 |          |
| WO2000308114 |          |
| WO2001075584 |          |
| WO2001075630 |          |
| WO2002200081 |          |
| WO2002250103 |          |
| WO2005041197 |          |
| WO2005081352 |          |
| WO2005110003 |          |
| WO2005112236 |          |
| WO2005123531 |          |
| WO2007041233 |          |
+--------------+----------+
22 rows in set (55,63 sec)
*/

SELECT *
    FROM oecd.treg07 d
    WHERE d.PCT_Nbr='WO1980020067';
    
---------------------------------------------------------------------------------------------------
-- Using WO_CITATIONS
---------------------------------------------------------------------------------------------------
SELECT d.Citing_pub_nbr
    FROM oecd_citations.WO_CITATIONS d
    WHERE d.Citing_pub_nbr='WO1980020067';

SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pnumber
                        FROM oecd_citations.WO_CITATIONS b) c 
    ON  a.pat=c.pnumber;    
/*
+------------------+
| COUNT(c.pnumber) |
+------------------+
|          2361517 |
+------------------+
2.361.517 vs 2.361.535 
*/    

CREATE TABLE patstat2016b.two_cit_ric AS
SELECT c.pnumber, c.Citing_pub_date, c.Citing_app_nbr, c.Citing_appln_id
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pnumber, b.Citing_pub_date, b.Citing_app_nbr, b.Citing_appln_id
                        FROM oecd_citations.WO_CITATIONS b) c 
    ON  a.pat=c.pnumber; 

SELECT a.pat, a.yr, c.Citing_appln_id
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.pnumber, b.Citing_appln_id
                        FROM patstat2016b.two_cit_ric b) c
    ON  a.pat=c.pnumber                    
    LEFT JOIN (SELECT DISTINCT f.pnumber
                      FROM patstat2016b.twotest f) e                    
    ON a.pat=e.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL AND e.pnumber IS NULL;
/*
+--------------+------+
| pat          | yr   |
+--------------+------+
| WO1980020067 | 1980 |
| WO1986009146 | 1987 |
| WO1986092232 |    0 |
| WO1989007063 |    0 |
| WO1991007436 |    0 |
| WO1992096729 |    0 |
| WO1994027872 |    0 |
| WO1994027873 |    0 |
| WO1996040129 |    0 |
| WO1997013491 |    0 |
| WO1997040926 |    0 |
| WO2000308114 | 2003 |
| WO2002200081 | 2001 |
| WO2002250103 | 2001 |
| WO2005041197 | 2004 |
| WO2005110003 | 2005 |
| WO2005123531 | 2005 |
| WO2008204036 | 2006 |
+--------------+------+
18 rows in set (1 min 8,98 sec)

*/

SELECT c.pnumber, c.Citing_appln_id
    FROM patstat2016b.two_cit_ric c
    LEFT JOIN (SELECT DISTINCT f.pnumber
                      FROM patstat2016b.twotest f) e                    
    ON c.pnumber=e.pnumber
    WHERE e.pnumber IS NULL;
/*
+--------------+-----------------+
| pnumber      | Citing_appln_id |
+--------------+-----------------+
| WO2001075584 | 376948519       |
| WO2001075630 | 376948520       |
| WO2005081352 | 54538343        |
| WO2005112236 | 24366857        |
| WO2007041233 | 473940487       |
+--------------+-----------------+
5 rows in set (42,88 sec)

*/



SELECT *
  FROM patstat2016b.two_cit_ric a
  LIMIT 0, 10;

-- Empty, the citation database does not increase the quality of the matching
SELECT d.APPLN_ID
  FROM patstat2016b.TLS211_PAT_PUBLN d
  INNER JOIN (SELECT c.pnumber, c.Citing_appln_id
                      FROM patstat2016b.two_cit_ric c
                      LEFT JOIN (SELECT DISTINCT f.pnumber
                                        FROM patstat2016b.twotest f) e                    
                      ON c.pnumber=e.pnumber
                      WHERE e.pnumber IS NULL) a
  ON d.APPLN_ID=a.Citing_appln_id;  
  
  
SELECT d.APPLN_ID
  FROM patstat2016b.TLS201_APPLN d
  INNER JOIN (SELECT c.pnumber, c.Citing_appln_id
                      FROM patstat2016b.two_cit_ric c
                      LEFT JOIN (SELECT DISTINCT f.pnumber
                                        FROM patstat2016b.twotest f) e                    
                      ON c.pnumber=e.pnumber
                      WHERE e.pnumber IS NULL) a
  ON d.APPLN_ID=a.Citing_appln_id;
-- Empty th


SELECT COUNT(DISTINCT c.pnumber)
    FROM patstat2016b.two_cit_ric c
    WHERE c.Citing_appln_id IS NULL;
-- So all the publication numbers have an application id

SELECT d.APPLN_ID
  FROM patstat2016b.TLS201_APPLN d
  WHERE d.APPLN_ID='19981923';

SELECT d.APPLN_ID, CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber, d.PUBLN_KIND, d.PAT_PUBLN_ID
  FROM patstat2016b.TLS211_PAT_PUBLN d
  WHERE d.APPLN_ID='19981923' AND d.PUBLN_AUTH='WO' ;


--
SELECT COUNT(DISTINCT a.Citing_appln_id)
  FROM patstat2016b.two_cit_ric a;
-- 2361517 

---------------------------------------------------------------------------------------------------
-- Final match table
---------------------------------------------------------------------------------------------------
-- table containing all matched publication numbers
CREATE TABLE patstat2016b.twopt AS
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber, d.PUBLN_KIND, d.PAT_PUBLN_ID, d.APPLN_ID 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,4) BETWEEN 1978 AND 2014) c
    ON  a.pat=c.pnumber
UNION ALL    
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '20',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber, d.PUBLN_KIND, d.PAT_PUBLN_ID, d.APPLN_ID  
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) IN ('00', '01','02','03','04','05','06','07','08','09','10','11','12','13','14')) c
    ON  a.pat=c.pnumber
UNION ALL    
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              '19',
                              LEFT(d.PUBLN_NR,2),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-2), 6, '0')
                              ) AS pnumber, d.PUBLN_KIND, d.PAT_PUBLN_ID, d.APPLN_ID  
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,2) BETWEEN 78 AND 99 ) c
    ON  a.pat=c.pnumber ;  
--  2361563 vs 2.361.535  because there are duplicates
SELECT COUNT(DISTINCT a.PAT_PUBLN_ID)
  FROM patstat2016b.twopt a;
--2985895  

SELECT COUNT(DISTINCT a.pnumber)
  FROM patstat2016b.twopt a;
-- 2.361.512  vs 2.361.535

SELECT COUNT(DISTINCT a.APPLN_ID)
  FROM patstat2016b.twopt a;
-- 2.363.210 vs 2.361.535
-- There are more application IDs than patent publication numbers