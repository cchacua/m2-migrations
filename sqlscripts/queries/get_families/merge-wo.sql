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
                WHERE d.PUBLN_AUTH='WO') c
    ON  a.pat=c.pnumber;
    --1.568.014 vs 2.361.535

SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_NR,4) BETWEEN 1978 AND 2014) c
    ON  a.pat=c.pnumber;
-- 1.568.014

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

SELECT c.pnumber
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO') c
    ON  a.pat=c.pnumber
    LIMIT 0,10;

-- Extract only those that were not matched
-- Analyze those that were not matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO') c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL
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
|        17950 | 1990 |
|        21260 | 1991 |
|        23511 | 1992 |
|        27221 | 1993 |
|        31951 | 1994 |
|        37617 | 1995 |
|        45211 | 1996 |
|        53836 | 1997 |
|        63333 | 1998 |
|        72363 | 1999 |
|        88750 | 2000 |
|       103402 | 2001 |
|       101783 | 2002 |
|        42023 | 2003 |
|            2 | 2004 |
|            3 | 2005 |
|            2 | 2006 |
+--------------+------+

 */    
------------------------------
-- using regpat    
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
    LEFT JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO') e                    
    ON a.pat=e.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL AND e.pnumber IS NULL
    INTO OUTFILE '/var/lib/mysql-files/non-matched-wo-both.csv'
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n';  
  -- 85 patents are missing
  
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT b.PCT_Nbr AS pnumber
                        FROM oecd.treg07 b) c
    ON  a.pat=c.pnumber                    
    LEFT JOIN (SELECT DISTINCT CONCAT(d.PUBLN_AUTH,
                              LEFT(d.PUBLN_NR,4),
                              LPAD(RIGHT(d.PUBLN_NR, CHAR_LENGTH(d.PUBLN_NR)-4), 6, '0')
                              ) AS pnumber 
                FROM patstat2016b.TLS211_PAT_PUBLN d
                WHERE d.PUBLN_AUTH='WO') e                    
    ON a.pat=e.pnumber
    WHERE LEFT(a.pat,2)='WO' AND c.pnumber IS NULL AND e.pnumber IS NULL
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
|           20 | 2002 |
|            6 | 2003 |
|            1 | 2006 |
+--------------+------+
18 rows in set (2 min 17,79 sec)

*/    