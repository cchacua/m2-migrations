---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- PRELIMINARY COUNTINGS COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using Riccaboni
---------------------------------------------------------------------------------------------------

SELECT COUNT(a.pat) AS Frequency, LEFT(a.pat,4) AS US_Char 
      FROM riccaboni.t01_allclasses a
      WHERE LEFT(a.pat,2)='US'
      GROUP BY LEFT(a.pat,4);
/*
+-----------+---------+
| Frequency | US_Char |
+-----------+---------+
|     26427 | US03    |
|    184183 | US04    |
|    245603 | US05    |
|    288336 | US06    |
|    299651 | US07    |
+-----------+---------+
5 rows in set (1,73 sec)
*/


SELECT COUNT(*), CHAR_LENGTH(a.pat), LEFT(a.pat,2) AS Authority
      FROM riccaboni.t01_allclasses a
	WHERE LEFT(a.pat,2)='US'
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,2);
/*
+----------+--------------------+-----------+
| COUNT(*) | CHAR_LENGTH(a.pat) | Authority |
+----------+--------------------+-----------+
|  1044200 |                 10 | US        |
+----------+--------------------+-----------+
1 row in set (1,87 sec)
*/


SELECT COUNT(a.pat), LEFT(a.pat,4), a.yr
    FROM riccaboni.t01_allclasses a
    WHERE LEFT(a.pat,2)='US'
    GROUP BY a.yr, LEFT(a.pat,4);
/*
Progressive numbers, according to years
*/

SELECT * FROM oecd_citations.US_CIT_COUNTS b LIMIT 0,10;

---------------------------------------------------------------------------------------------------
-- Using US_CITATIONS
---------------------------------------------------------------------------------------------------
/*
SELECT COUNT(DISTINCT b.US_Pub_nbr), CHAR_LENGTH(b.US_Pub_nbr) AS Nchar
                              FROM oecd_citations.US_CIT_COUNTS b
                              GROUP BY CHAR_LENGTH(b.US_Pub_nbr);
                              
+------------------------------+-------+
| COUNT(DISTINCT b.US_Pub_nbr) | Nchar |
+------------------------------+-------+
|                      5438536 |     9 |
|                      1559533 |    12 |
+------------------------------+-------+
*/

SELECT COUNT(DISTINCT a.US_Pub_nbr) AS Frequency, LEFT(a.US_Pub_nbr,4) AS US_Char 
      FROM oecd_citations.US_CIT_COUNTS a
      WHERE CHAR_LENGTH(a.US_Pub_nbr)='9'
      GROUP BY LEFT(a.US_Pub_nbr,4);
/*There are not US(0)2*/

SELECT COUNT(DISTINCT a.US_Pub_nbr) AS Frequency, LEFT(a.US_Pub_nbr,8) AS US_Char 
      FROM oecd_citations.US_CIT_COUNTS a
      WHERE CHAR_LENGTH(a.US_Pub_nbr)='12'
      GROUP BY LEFT(a.US_Pub_nbr,8);
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- MERGE
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using US_CIT_COUNTS and creating a new table riccaboni.t01_allclasses_us_appid
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t01_allclasses_us_appid; 
CREATE TABLE riccaboni.t01_allclasses_us_appid AS
SELECT DISTINCT a.pat, c.APPLN_ID
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT CONCAT(LEFT(b.US_Pub_nbr,2), LPAD(RIGHT(b.US_Pub_nbr, CHAR_LENGTH(b.US_Pub_nbr)-2), 8, '0')) AS pat, b.US_Appln_id AS APPLN_ID
                        FROM oecd_citations.US_CIT_COUNTS b) c 
    ON  a.pat=c.pat;  

/*
Query OK, 980142 rows affected (1 min 24,00 sec)
Records: 980142  Duplicates: 0  Warnings: 0
980142 US_CIT_COUNTS vs 1044200 Riccaboni
*/

---------------------------------------------------------------------------------------------------
-- Table for US non-matched patents: riccaboni.t01_allclasses_us_nonappid
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t01_allclasses_us_nonappid; 
CREATE TABLE riccaboni.t01_allclasses_us_nonappid AS
SELECT DISTINCT a.pat
    FROM riccaboni.t01_allclasses a
    LEFT JOIN (SELECT DISTINCT CONCAT(LEFT(b.US_Pub_nbr,2), LPAD(RIGHT(b.US_Pub_nbr, CHAR_LENGTH(b.US_Pub_nbr)-2), 8, '0')) AS pat FROM oecd_citations.US_CIT_COUNTS b) c 
    ON  a.pat=c.pat
    WHERE LEFT(a.pat,2)='US' AND c.pat IS NULL;  
/*
Query OK, 64058 rows affected (1 min 11,50 sec)
Records: 64058  Duplicates: 0  Warnings: 0
*/

SELECT * FROM riccaboni.t01_allclasses_us_nonappid LIMIT 0,10;


SELECT COUNT(DISTINCT a.pat), a.yr, LEFT(a.pat,4)
    FROM riccaboni.t01_allclasses a
    LEFT JOIN (SELECT DISTINCT CONCAT(LEFT(b.US_Pub_nbr,2), LPAD(RIGHT(b.US_Pub_nbr, CHAR_LENGTH(b.US_Pub_nbr)-2), 8, '0')) AS pat, b.US_Appln_id AS APPLN_ID FROM oecd_citations.US_CIT_COUNTS b) c 
    ON  a.pat=c.pat
    WHERE LEFT(a.pat,2)='US' AND c.pat IS NULL
    GROUP BY a.yr, LEFT(a.pat,4);  
/*
+-----------------------+------+---------------+
| COUNT(DISTINCT a.pat) | yr   | LEFT(a.pat,4) |
+-----------------------+------+---------------+
|                     1 | 1933 | US06          |
|                     1 | 1936 | US06          |
|                     1 | 1940 | US04          |
|                     3 | 1941 | US03          |
|                     1 | 1942 | US03          |
|                     2 | 1943 | US03          |
|                     7 | 1944 | US03          |
|                     5 | 1944 | US04          |
|                     1 | 1944 | US06          |
|                     4 | 1945 | US03          |
|                     5 | 1945 | US04          |
|                     2 | 1946 | US03          |
|                     4 | 1946 | US04          |
|                     1 | 1947 | US04          |
|                     1 | 1948 | US04          |
|                     3 | 1950 | US03          |
|                     2 | 1950 | US04          |
|                     1 | 1951 | US03          |
|                     2 | 1951 | US04          |
|                     1 | 1952 | US03          |
|                     1 | 1952 | US04          |
|                     5 | 1953 | US04          |
|                     2 | 1954 | US03          |
|                     5 | 1954 | US04          |
|                     1 | 1954 | US06          |
|                     4 | 1955 | US03          |
|                     6 | 1955 | US04          |
|                     6 | 1956 | US03          |
|                     8 | 1956 | US04          |
|                     8 | 1957 | US03          |
|                     3 | 1957 | US04          |
|                     4 | 1958 | US03          |
|                     9 | 1958 | US04          |
|                     1 | 1958 | US06          |
|                    10 | 1959 | US03          |
|                     6 | 1959 | US04          |
|                     1 | 1959 | US06          |
|                    15 | 1960 | US03          |
|                    14 | 1960 | US04          |
|                     1 | 1960 | US06          |
|                    22 | 1961 | US03          |
|                    24 | 1961 | US04          |
|                    14 | 1962 | US03          |
|                    25 | 1962 | US04          |
|                     4 | 1962 | US05          |
|                    30 | 1963 | US03          |
|                    19 | 1963 | US04          |
|                     1 | 1963 | US05          |
|                     1 | 1963 | US06          |
|                    21 | 1964 | US03          |
|                    27 | 1964 | US04          |
|                     8 | 1964 | US05          |
|                     1 | 1964 | US06          |
|                    20 | 1965 | US03          |
|                    26 | 1965 | US04          |
|                     6 | 1965 | US05          |
|                     1 | 1965 | US06          |
|                    30 | 1966 | US03          |
|                    25 | 1966 | US04          |
|                     1 | 1966 | US05          |
|                     2 | 1966 | US06          |
|                    49 | 1967 | US03          |
|                    46 | 1967 | US04          |
|                     4 | 1967 | US05          |
|                     1 | 1967 | US06          |
|                    77 | 1968 | US03          |
|                    48 | 1968 | US04          |
|                     7 | 1968 | US05          |
|                   147 | 1969 | US03          |
|                    65 | 1969 | US04          |
|                     6 | 1969 | US05          |
|                   307 | 1970 | US03          |
|                    94 | 1970 | US04          |
|                     8 | 1970 | US05          |
|                     1 | 1970 | US06          |
|                   745 | 1971 | US03          |
|                   159 | 1971 | US04          |
|                     1 | 1971 | US05          |
|                     2 | 1971 | US06          |
|                  2239 | 1972 | US03          |
|                   249 | 1972 | US04          |
|                     9 | 1972 | US05          |
|                     3 | 1972 | US06          |
|                  7543 | 1973 | US03          |
|                   512 | 1973 | US04          |
|                    10 | 1973 | US05          |
|                     1 | 1973 | US06          |
|                 10319 | 1974 | US03          |
|                  1501 | 1974 | US04          |
|                     9 | 1974 | US05          |
|                     2 | 1974 | US06          |
|                  4674 | 1975 | US03          |
|                  7593 | 1975 | US04          |
|                     8 | 1975 | US05          |
|                    10 | 1975 | US06          |
|                    11 | 1976 | US03          |
|                   717 | 1976 | US04          |
|                     1 | 1976 | US06          |
|                   728 | 1977 | US04          |
|                   642 | 1978 | US04          |
|                     1 | 1978 | US05          |
|                   628 | 1979 | US04          |
|                   718 | 1980 | US04          |
|                     1 | 1980 | US05          |
|                  1337 | 1981 | US04          |
|                  1341 | 1982 | US04          |
|                   557 | 1983 | US04          |
|                     1 | 1983 | US05          |
|                   556 | 1984 | US04          |
|                     3 | 1984 | US05          |
|                   531 | 1985 | US04          |
|                     8 | 1985 | US05          |
|                   469 | 1986 | US04          |
|                    20 | 1986 | US05          |
|                   509 | 1987 | US04          |
|                    60 | 1987 | US05          |
|                   449 | 1988 | US04          |
|                   159 | 1988 | US05          |
|                   297 | 1989 | US04          |
|                   402 | 1989 | US05          |
|                    34 | 1990 | US04          |
|                   667 | 1990 | US05          |
|                     7 | 1990 | US06          |
|                   675 | 1991 | US05          |
|                    10 | 1991 | US06          |
|                   686 | 1992 | US05          |
|                    19 | 1992 | US06          |
|                   827 | 1993 | US05          |
|                    24 | 1993 | US06          |
|                     1 | 1993 | US07          |
|                   994 | 1994 | US05          |
|                    61 | 1994 | US06          |
|                  1349 | 1995 | US05          |
|                   121 | 1995 | US06          |
|                     5 | 1995 | US07          |
|                  1023 | 1996 | US05          |
|                   140 | 1996 | US06          |
|                     1 | 1996 | US07          |
|                  1013 | 1997 | US05          |
|                   523 | 1997 | US06          |
|                    10 | 1997 | US07          |
|                   316 | 1998 | US05          |
|                  1027 | 1998 | US06          |
|                    10 | 1998 | US07          |
|                    16 | 1999 | US05          |
|                  1201 | 1999 | US06          |
|                    35 | 1999 | US07          |
|                  1157 | 2000 | US06          |
|                    95 | 2000 | US07          |
|                   913 | 2001 | US06          |
|                   243 | 2001 | US07          |
|                   481 | 2002 | US06          |
|                   370 | 2002 | US07          |
|                   227 | 2003 | US06          |
|                   587 | 2003 | US07          |
|                    47 | 2004 | US06          |
|                   612 | 2004 | US07          |
|                     1 | 2005 | US06          |
|                   547 | 2005 | US07          |
|                   449 | 2006 | US07          |
|                   292 | 2007 | US07          |
|                   139 | 2008 | US07          |
|                    37 | 2009 | US07          |
|                     5 | 2010 | US07          |
+-----------------------+------+---------------+
164 rows in set (1 min 29,78 sec)

*/

---------------------------------------------------------------------------------------------------
-- Table nonappid applicant type and appnumber
---------------------------------------------------------------------------------------------------


SELECT a.*, b.* 
  FROM riccaboni.t01_allclasses_us_nonappid a
  INNER JOIN li.patent b
  ON a.pat=CONCAT('US', b.Patent)
  WHERE b.AppNum!=''
  LIMIT 0,10;

SELECT * FROM patstat2016b.TLS201_APPLN a WHERE a.APPLN_NR='4612337' AND a.APPLN_AUTH='US';

---------------------------------------------------------------------------------------------------
-- Using PATSTAT and creating a new table riccaboni.t01_allclasses_us_appid
---------------------------------------------------------------------------------------------------

SELECT COUNT(c.pat)
    FROM riccaboni.t01_allclasses_us_appid a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pat
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pat;
/*
+--------------+
| COUNT(c.pat) |
+--------------+
|       980142 |
+--------------+
980142 Patstat vs 1044200 Riccaboni
*/

---------------------------------------------------------------------------------------------------
-- Using PVIEW and creating a new table riccaboni.t01_allclasses_us_appid
---------------------------------------------------------------------------------------------------
SELECT COUNT(c.pat)
    FROM riccaboni.t01_allclasses_us_appid a
    INNER JOIN (SELECT DISTINCT CONCAT('US', LPAD(b.number, 8, '0')) AS pat
                        FROM uspto.PVIEW b) c
    ON  a.pat=c.pat;
/*
+--------------+
| COUNT(c.pat) |
+--------------+
|       434703 |
+--------------+
1 row in set (1 min 24,12 sec)
*/
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- COUNTINGS
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Using US_CITATIONS
---------------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT c.pnumber)
    FROM riccaboni.t01_allclasses a
    INNER JOIN (SELECT DISTINCT b.Citing_pub_nbr AS pnumber
                        FROM oecd_citations.US_CITATIONS b) c 
    ON  a.pat=c.pnumber;  


/*

 MERGE  VS RICCABONNI
*/


---------------------------------------------------------------------------------------------------
-- Using new table riccaboni.t01_allclasses_us_appid
---------------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_us_appid a; 
/*

*/

SELECT COUNT(DISTINCT a.pat)
	FROM riccaboni.t01_allclasses_us_appid a; 
/*

*/

---------------------------------------------------------------------------------------------------
-- Using US_CITATIONS and PATSTAT
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t01_allclasses_us_appid;                                     
ALTER TABLE riccaboni.t01_allclasses_us_appid ADD PRIMARY KEY(APPLN_ID);

SELECT COUNT(DISTINCT a.APPLN_ID)
	FROM riccaboni.t01_allclasses_us_appid a
	INNER JOIN patstat2016b.TLS201_APPLN c
	ON a.APPLN_ID=c.APPLN_ID; 
/*

So all US APPLN_ID can be found in Patstat
*/  
