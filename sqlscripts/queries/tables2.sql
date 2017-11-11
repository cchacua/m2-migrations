-----------------------------------------------------------------------------------------
-- To only retrieve the publication agency
USE riccaboni patstat2016b;
SELECT        LEFT(riccaboni.t01.pat,5) AS pat
              FROM riccaboni.t01
INTO OUTFILE '/var/lib/mysql-files/riccaboni-pubnumber-agency.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


SELECT DISTINCT patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH
              FROM patstat2016b.TLS211_PAT_PUBLN 
INTO OUTFILE '/var/lib/mysql-files/211-pubnumber-agency.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-----------------------------------------------------------------------------------------
-- t211 only for EP, US, WO
USE patstat2016b;
CREATE TABLE TLS211_SAMPLE AS
SELECT * FROM patstat2016b.TLS211_PAT_PUBLN 
WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH IN ('EP', 'WO', 'US');
-- Number of patents 23.802.901
-- to verify that there are only patents from those three agencies
SELECT DISTINCT patstat2016b.TLS211_SAMPLE.PUBLN_AUTH
              FROM patstat2016b.TLS211_SAMPLE;

-- To verify number of characters of number
SELECT CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR)
      FROM TLS211_SAMPLE
      GROUP BY CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR);

SELECT COUNT(*), LEFT(TLS211_SAMPLE.PUBLN_NR,2)
      FROM TLS211_SAMPLE
      GROUP BY LEFT(TLS211_SAMPLE.PUBLN_NR,2);




-- Concatenate
ALTER TABLE TLS211_SAMPLE ADD COLUMN pat VARCHAR(15);
UPDATE TLS211_SAMPLE SET pat = CONCAT(PUBLN_AUTH, PUBLN_NR);


SELECT DISTINCT pat
      FROM TLS211_SAMPLE
INTO OUTFILE '/var/lib/mysql-files/211-pat.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- see patents per year
SELECT COUNT(*), LEFT(TLS211_SAMPLE.PUBLN_DATE,4)
      FROM TLS211_SAMPLE
      GROUP BY LEFT(TLS211_SAMPLE.PUBLN_DATE,4);

-- Patents before 1901 or after 2013
SELECT COUNT(*)
      FROM TLS211_SAMPLE
      WHERE LEFT(TLS211_SAMPLE.PUBLN_DATE,4)<'1901' OR LEFT(TLS211_SAMPLE.PUBLN_DATE,4)>'2013';
      /*
      +----------+
      | COUNT(*) |
      +----------+
      |  4097419 |
      +----------+
      
      */
      
SELECT COUNT(*)
      FROM TLS211_SAMPLE
      WHERE LEFT(TLS211_SAMPLE.PUBLN_DATE,4)>'2013' AND LEFT(TLS211_SAMPLE.PUBLN_DATE,4)<'9999';
-- So, delete those rows
-- DELETE FROM TLS211_SAMPLE WHERE LEFT(TLS211_SAMPLE.PUBLN_DATE,4)<'1901';
-- DELETE FROM TLS211_SAMPLE WHERE LEFT(TLS211_SAMPLE.PUBLN_DATE,4)>'2013' AND LEFT(TLS211_SAMPLE.PUBLN_DATE,4)<'9999';

-- Count patents
SELECT COUNT(*) 
      FROM TLS211_SAMPLE; 
--  19988674 

-- See if patents have repeated codes
SELECT COUNT(DISTINCT pat) 
      FROM TLS211_SAMPLE;   
--  17020192

-- There are publications numbers with 1-13 characters. However, not all the sample is four our interest, as we have not yet selected the especific years
SELECT COUNT(*), CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR)
      FROM TLS211_SAMPLE
      GROUP BY CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR);
      /*
      +----------+-------------------------------------+
      | COUNT(*) | CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR) |
      +----------+-------------------------------------+
      |        3 |                                   1 |
      |       30 |                                   2 |
      |      183 |                                   3 |
      |     7453 |                                   4 |
      |     4514 |                                   5 |
      |   343816 |                                   6 |
      | 13796047 |                                   7 |
      |   222927 |                                   8 |
      |      855 |                                   9 |
      |  5612739 |                                  10 |
      |       79 |                                  11 |
      |       27 |                                  12 |
      |        1 |                                  13 |
      +----------+-------------------------------------+
      13 rows in set (1 min 3,00 sec)

      */



-- Create primary key
ALTER TABLE TLS211_SAMPLE ADD INDEX pat_index (pat);

-- Only take rows published       
-----------------------------------------------------------------------------------------
-- To account for the problem Of having USD, USH, USPP, USRE
USE riccaboni;
SELECT COUNT(*) FROM riccaboni.t01
      WHERE LEFT(riccaboni.t01.pat,3) IN ('USD', 'USH');
      
-- 241.547 PATENTS      
SELECT COUNT(*) FROM riccaboni.t01
      WHERE LEFT(riccaboni.t01.pat,4) IN ('USPP', 'USRE');  
--  17.654 PATENTS       

-- To verify the number of characters
SELECT CHAR_LENGTH(riccaboni.t01.pat)
      FROM riccaboni.t01
      GROUP BY CHAR_LENGTH(riccaboni.t01.pat);
-- There are codes with 9, 10 and 12 characters

SELECT COUNT(*), CHAR_LENGTH(riccaboni.t01.pat)
      FROM riccaboni.t01
      GROUP BY CHAR_LENGTH(riccaboni.t01.pat);
      /*
      +----------+--------------------------------+
      | COUNT(*) | CHAR_LENGTH(riccaboni.t01.pat) |
      +----------+--------------------------------+
      |  2684761 |                              9 | EP
      |  4243972 |                             10 | US
      |  2361535 |                             12 | WO
      +----------+--------------------------------+
      */
      
-- Riccaboni      
SELECT COUNT(*), CHAR_LENGTH(riccaboni.t01.pat)
      FROM riccaboni.t01
      WHERE LEFT(riccaboni.t01.pat,2)='EP'
      GROUP BY CHAR_LENGTH(riccaboni.t01.pat);
      
-- To identify observations per year
SELECT COUNT(*), riccaboni.t01.yr
      FROM riccaboni.t01
      GROUP BY riccaboni.t01.yr;
      /*      
      +----------+------+
      | COUNT(*) | yr   |
      +----------+------+
      |       12 |    0 |
      |        3 | 1901 |
      |        1 | 1902 |
      |        4 | 1903 |
      |        4 | 1904 |
      |        1 | 1905 |
      |        1 | 1908 |
      |        1 | 1909 |
      |        1 | 1915 |
      |        1 | 1918 |
      |        1 | 1921 |
      |        1 | 1922 |
      |        1 | 1925 |
      |        1 | 1929 |
      |        2 | 1930 |
      |        2 | 1931 |
      |        1 | 1933 |
      |        2 | 1936 |
      |        4 | 1938 |
      |        1 | 1939 |
      |        3 | 1940 |
      |        3 | 1941 |
      |        1 | 1942 |
      |        4 | 1943 |
      |       19 | 1944 |
      |       18 | 1945 |
      |       11 | 1946 |
      |        4 | 1947 |
      |        8 | 1948 |
      |       10 | 1949 |
      |        9 | 1950 |
      |       11 | 1951 |
      |       17 | 1952 |
      |       12 | 1953 |
      |       30 | 1954 |
      |       33 | 1955 |
      |       33 | 1956 |
      |       32 | 1957 |
      |       39 | 1958 |
      |       56 | 1959 |
      |       73 | 1960 |
      |       85 | 1961 |
      |      111 | 1962 |
      |      110 | 1963 |
      |      147 | 1964 |
      |      167 | 1965 |
      |      193 | 1966 |
      |      230 | 1967 |
      |      337 | 1968 |
      |      584 | 1969 |
      |     1161 | 1970 |
      |     2658 | 1971 |
      |     9418 | 1972 |
      |    41655 | 1973 |
      |    65683 | 1974 |
      |    65902 | 1975 | OK
      |    65813 | 1976 |
      |    65999 | 1977 |
      |    69550 | 1978 |
      |    78843 | 1979 |
      |    88978 | 1980 |
      |    92510 | 1981 |
      |    96984 | 1982 |
      |    96936 | 1983 |
      |   108197 | 1984 |
      |   116758 | 1985 |
      |   125112 | 1986 |
      |   135120 | 1987 |
      |   152916 | 1988 |
      |   166637 | 1989 |
      |   181240 | 1990 |
      |   181153 | 1991 |
      |   188377 | 1992 |
      |   196102 | 1993 |
      |   217841 | 1994 |
      |   249074 | 1995 |
      |   268572 | 1996 |
      |   318778 | 1997 |
      |   338753 | 1998 |
      |   368780 | 1999 |
      |   413132 | 2000 |
      |   446475 | 2001 |
      |   446341 | 2002 |
      |   441321 | 2003 |
      |   449087 | 2004 |
      |   456054 | 2005 |
      |   444907 | 2006 |
      |   413061 | 2007 |
      |   362656 | 2008 |
      |   306506 | 2009 |
      |   294102 | 2010 |
      |   303189 | 2011 |
      |   233747 | 2012 |
      |   121754 | 2013 |
      |        1 | 2014 |
      +----------+------+
       */
 
SELECT *  FROM riccaboni.t01
      WHERE riccaboni.t01.yr='2014';
      
/*
The only patent for 2014
+--------------+-----------+-----------+----------+------+---------+-------------+
| pat          | invs      | localInvs | apps     | yr   | classes | wasComplete |
+--------------+-----------+-----------+----------+------+---------+-------------+
| WO2014044926 | LI4643783 | LI4643783 | LA338998 | 2014 | 33      | 1           |
+--------------+-----------+-----------+----------+------+---------+-------------+
*/      
       
----------------------------------------------------------------------------------------
-- So, let's make the join and save it in riccaboni.TLS211_MERGE
USE patstat2016b;
SELECT patstat2016b.TLS211_SAMPLE.pat FROM patstat2016b.TLS211_SAMPLE limit 0,10;

SELECT t01.pat, TLS211_SAMPLE.pat
FROM t01 
LEFT JOIN TLS211_SAMPLE 
ON t01.pat = TLS211_SAMPLE.pat
INTO OUTFILE '/var/lib/mysql-files/ric-211-left2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';




----------------------------------------------------------------------------------------
-- Counting matches
SELECT COUNT(DISTINCT t01.pat)
FROM t01
INNER JOIN TLS211_SAMPLE 
ON t01.pat = TLS211_SAMPLE.pat;
-- 4.194.654

-- Counting matches
SELECT COUNT(DISTINCT TLS211_SAMPLE.pat), TLS211_SAMPLE.PUBLN_AUTH
FROM TLS211_SAMPLE 
INNER JOIN t01 
ON TLS211_SAMPLE.pat=t01.pat
GROUP BY TLS211_SAMPLE.PUBLN_AUTH;
-- 4.194.654

/*
+-----------------------------------+------------+
| COUNT(DISTINCT TLS211_SAMPLE.pat) | PUBLN_AUTH |
+-----------------------------------+------------+
|                           2671687 | EP         |
|                                 3 | US         |
|                           1522964 | WO         |
+-----------------------------------+------------+
*/

-- Counting Riccaboni
SELECT COUNT(DISTINCT t01.pat) FROM t01;
SELECT COUNT(DISTINCT t01.pat), LEFT(t01.pat, 2)
FROM t01
GROUP BY LEFT(t01.pat, 2), t01.yr;
/*
+-------------------------+------------------+
| COUNT(DISTINCT t01.pat) | LEFT(t01.pat, 2) |
+-------------------------+------------------+
|                 2.684.761 | EP               | 2.684.757
|                 4243972 | US               |
|                 2361535 | WO               |
+-------------------------+------------------+
 Total rows 9.290.268
*/

-- Counting if the original pub number could work
SELECT COUNT(DISTINCT TLS211_SAMPLE.publn_nr_original) FROM TLS211_SAMPLE;
-- 2.698.611

SELECT t01.pat FROM t01 WHERE LEFT(t01.pat,2)='US' ORDER BY t01.pat LIMIT 0,50;
SELECT TLS211_SAMPLE.pat FROM TLS211_SAMPLE WHERE TLS211_SAMPLE.PUBLN_AUTH='US' ORDER BY TLS211_SAMPLE.pat LIMIT 0,50;
----------------------------------------------------------------------------------------

SELECT t01.pat, TLS211_SAMPLE.APPLN_ID
FROM t01 
INNER JOIN TLS211_SAMPLE 
ON t01.pat = TLS211_SAMPLE.pat
INTO OUTFILE '/var/lib/mysql-files/ric-211-inner.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT riccaboni.t01.pat, patstat2016b.TLS211_SAMPLE.pat
FROM riccaboni.t01 
INNER JOIN patstat2016b.TLS211_SAMPLE 
ON riccaboni.t01.pat = patstat2016b.TLS211_SAMPLE.pat
INTO OUTFILE '/var/lib/mysql-files/ric-211-inner2.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';


WHERE patstat2016b.TLS211_SAMPLE.pat IS NULL


SELECT patstat2016b.TLS211_SAMPLE.pat FROM patstat2016b.TLS211_SAMPLE
LEFT JOIN riccaboni.t01 ON patstat2016b.TLS211_SAMPLE.pat = riccaboni.t01.pat
UNION ALL
SELECT patstat2016b.TLS211_SAMPLE.pat FROM patstat2016b.TLS211_SAMPLE
RIGHT JOIN riccaboni.t01 ON patstat2016b.TLS211_SAMPLE.pat = riccaboni.t01.pat
WHERE patstat2016b.TLS211_SAMPLE.pat IS NULL
limit 0,100;
