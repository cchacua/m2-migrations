-- USPTO merge

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
-- Here we can see that all USPTO patents have 10 characters in Riccaboni's dataset
-- They may have followed the 8-character legnth proposed by USPTO https://www.uspto.gov/patents-application-process/applying-online/patent-number

SELECT COUNT(a.pat) AS Frequency, LEFT(a.pat,4) AS US_Char 
      FROM riccaboni.t01 a
      WHERE LEFT(a.pat,2)='US'
      GROUP BY LEFT(a.pat,4);
      /*
      +-----------+---------+
      | Frequency | US_Char |
      +-----------+---------+
      |    141708 | US03    |
      |    998600 | US04    |
      |    989630 | US05    |
      |    996719 | US06    |
      |    858114 | US07    |
      |    241012 | USD0    |
      |       535 | USH0    |
      |     11404 | USPP    |
      |      6250 | USRE    |
      +-----------+---------+
      */      
      
-- Patstat
-- There are publications numbers with 1-12 characters. However, not all the sample is four our interest, as we have not yet selected the especific years
SELECT COUNT(*), CHAR_LENGTH(a.PUBLN_NR)
      FROM patstat2016b.TLS211_PAT_PUBLN a
      WHERE a.PUBLN_AUTH='US'
      GROUP BY CHAR_LENGTH(a.PUBLN_NR);
      /*
      +----------+-------------------------+
      | COUNT(*) | CHAR_LENGTH(a.PUBLN_NR) |
      +----------+-------------------------+
      |       12 |                       1 |
      |      116 |                       2 |
      |     1080 |                       3 |
      |    16432 |                       4 |
      |    94283 |                       5 |
      |   907694 |                       6 |
      |  9002595 |                       7 |
      |     2371 |                       8 |
      |      822 |                       9 |
      |  4616754 |                      10 |
      |       39 |                      11 |
      |       22 |                      12 |
      +----------+-------------------------+
      */

SELECT COUNT(*), CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_NR,1) AS US_Char 
      FROM patstat2016b.TLS211_PAT_PUBLN a
      WHERE a.PUBLN_AUTH='US'
      GROUP BY CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_NR,1);

SELECT COUNT(*), CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_DATE,4) AS Year, LEFT(a.PUBLN_NR,1) AS US_Char
      FROM patstat2016b.TLS211_PAT_PUBLN a
      WHERE a.PUBLN_AUTH='US'
      GROUP BY CHAR_LENGTH(a.PUBLN_NR), LEFT(a.PUBLN_DATE,4), LEFT(a.PUBLN_NR,1);
      
---------------------------------------------------------------------------------------
-- Merge 

-----------------------
-- 
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0'))) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R');
-- So, there are 9.425.619 patents not begining with 'D', 'H', 'P', 'R'

      -- To see the number of characters of the pnumber. The max should be equal to 8, in order to have the specific length
      SELECT COUNT(DISTINCT b.PUBLN_NR) AS pnumber, CHAR_LENGTH(b.PUBLN_NR) AS Nchar
                              FROM patstat2016b.TLS211_PAT_PUBLN b
                              WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')
                              GROUP BY CHAR_LENGTH(b.PUBLN_NR);
      /*
      +---------+-------+
      | pnumber | Nchar |
      +---------+-------+
      |      11 |     1 |
      |      94 |     2 |
      |     901 |     3 |
      |    9003 |     4 |
      |   89848 |     5 |
      |  899057 |     6 |
      | 8372222 |     7 |
      |    2247 |     8 |
      |     814 |     9 |
      | 4615698 |    10 |
      |      39 |    11 |
      |      22 |    12 |
      +---------+-------+
      12 rows in set (1 min 14,79 sec)
      So, there are a lot of patents with 10 char, which is a problem
      */
      
-- Make the merge      
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0'))
    WHERE b.PUBLN_AUTH='US'
    AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R') ;


SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pnumber;
--  3.983.470 vs 3.984.771

SELECT c.pnumber
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pnumber
    LIMIT 0,10;


-- Extract only those that were not matched
SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,2)='US' AND LEFT(a.pat,3) NOT IN ('USD', 'USH', 'USP', 'USR') AND c.pnumber IS NULL
    INTO OUTFILE '/var/lib/mysql-files/non-matched-us-num.csv'
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n';
  --  1.301 non-matched rows

-- Analyze years for those non-matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,2)='US' AND LEFT(a.pat,3) NOT IN ('USD', 'USH', 'USP', 'USR') AND c.pnumber IS NULL
    GROUP BY a.yr;
    
/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|            1 | 1992 |
|            2 | 1995 |
|           14 | 1996 |
|           21 | 1997 |
|           46 | 1998 |
|           37 | 1999 |
|           80 | 2000 |
|           81 | 2001 |
|          160 | 2002 |
|          156 | 2003 |
|          179 | 2004 |
|          202 | 2005 |
|          159 | 2006 |
|          102 | 2007 |
|           41 | 2008 |
|           19 | 2009 |
|            1 | 2010 |
+--------------+------+
17 rows in set (3 min 21,88 sec)
Here the problem persists even for patents after 2001
*/    
-----------------------
-- D, H

SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0'))) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H');
-- So, there are 425.829 patents begining with D, H

      -- To see the number of characters of the pnumber. The max should be equal to 8, in order to have the specific length
      SELECT COUNT(DISTINCT b.PUBLN_NR) AS pnumber, CHAR_LENGTH(b.PUBLN_NR) AS Nchar
                              FROM patstat2016b.TLS211_PAT_PUBLN b
                              WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')
                              GROUP BY CHAR_LENGTH(b.PUBLN_NR);
          /*
          +---------+-------+
          | pnumber | Nchar |
          +---------+-------+
          |       9 |     2 |
          |      91 |     3 |
          |     915 |     4 |
          |    1421 |     5 |
          |    5091 |     6 |
          |  418292 |     7 |
          |      10 |     8 |
          +---------+-------+
          This is ok
          */

-- Make the merge
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0'))
    WHERE b.PUBLN_AUTH='US' 
          AND LEFT(b.PUBLN_NR,1) IN ('D', 'H') ;
          
SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber;
    
-- 214.624  VS 241.547

-- Those that were matched
SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,3) IN ('USD','USH')
    LIMIT 0,10;

-- Year for those that were matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber
    GROUP BY a.yr;
/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|            1 | 1983 |
|            2 | 1984 |
|            2 | 1985 |
|            6 | 1986 |
|            2 | 1988 |
|            3 | 1989 |
|            5 | 1990 |
|           24 | 1991 |
|           23 | 1992 |
|           43 | 1993 |
|          170 | 1994 |
|          516 | 1995 |
|         2763 | 1996 |
|         6190 | 1997 |
|         6725 | 1998 |
|         8462 | 1999 |
|        14694 | 2000 |
|        15612 | 2001 |
|        17231 | 2002 |
|        18676 | 2003 |
|        19679 | 2004 |
|        20942 | 2005 |
|        20412 | 2006 |
|        21486 | 2007 |
|        20479 | 2008 |
|        16665 | 2009 |
|         3811 | 2010 |
+--------------+------+
*/

    
-- Extract only those that were not matched
SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,3) IN ('USD','USH') AND c.pnumber IS NULL
    INTO OUTFILE '/var/lib/mysql-files/non-matched-us-d,h.csv'
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n';
  -- 26.923 non-matched rows
  
-- Analyze years for those non-matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,3) IN ('USD','USH') AND c.pnumber IS NULL
    GROUP BY a.yr;
    /*
    +--------------+------+
    | COUNT(a.pat) | yr   |
    +--------------+------+
    |            1 | 1988 |
    |            1 | 1989 |
    |            8 | 1990 |
    |           19 | 1991 |
    |           23 | 1992 |
    |           29 | 1993 |
    |          165 | 1994 |
    |          612 | 1995 |
    |         3353 | 1996 |
    |         7270 | 1997 |
    |         7659 | 1998 |
    |         6568 | 1999 |
    |         1175 | 2000 |
    |            1 | 2002 |
    |            2 | 2003 |
    |            5 | 2004 |
    |            2 | 2005 |
    |           13 | 2006 |
    |            7 | 2007 |
    |            6 | 2008 |
    |            4 | 2009 |
    +--------------+------+
    */
    
    
    
-----------------------
-- PP AND PR

-- 
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0'))) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE');
-- There are 48.964 US patents begining with PP or RE 

      -- To see the number of characters of the pnumber. The max should be equal to 8, in order to have the specific length
      SELECT COUNT(DISTINCT b.PUBLN_NR) AS pnumber, CHAR_LENGTH(b.PUBLN_NR) AS Nchar
                              FROM patstat2016b.TLS211_PAT_PUBLN b
                              WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')
                              GROUP BY CHAR_LENGTH(b.PUBLN_NR);
             /*
              +---------+-------+
              | pnumber | Nchar |
              +---------+-------+
              |       1 |     3 |
              |       7 |     4 |
              |     106 |     5 |
              |    1291 |     6 |
              |   47451 |     7 |
              |     100 |     8 |
              |       8 |     9 |
              +---------+-------+
              7 rows in set (31,90 sec)
            
             */

      SELECT RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2) AS 'Only number'
                              FROM patstat2016b.TLS211_PAT_PUBLN b
                              WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE') AND CHAR_LENGTH(b.PUBLN_NR)='6'
                              LIMIT 0,100;

-- To verify that all have 10 characters after the transformation
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0'))) AS pnumber, CHAR_LENGTH(CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0'))) AS Nchar
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')
                        GROUP BY CHAR_LENGTH(CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')));
-- Make the merge
SELECT COUNT(c.pnumber)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber;
-- 14.886 VS 17.654          

-- Example merged
SELECT c.pnumber, a.yr
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber
    LIMIT 0,10;



SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    WHERE LEFT(a.pat, 4)='USPP'
    LIMIT 0,10;

-- Year of the matched patents
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber
    GROUP BY a.yr;

/*
+--------------+------+
| COUNT(a.pat) | yr   |
+--------------+------+
|            3 | 1988 |
|            2 | 1989 |
|            5 | 1990 |
|            7 | 1991 |
|           18 | 1992 |
|           26 | 1993 |
|           47 | 1994 |
|           85 | 1995 |
|          126 | 1996 |
|          209 | 1997 |
|          365 | 1998 |
|         1045 | 1999 |
|         1228 | 2000 |
|         1450 | 2001 |
|         1442 | 2002 |
|         1345 | 2003 |
|         1540 | 2004 |
|         1619 | 2005 |
|         1362 | 2006 |
|         1146 | 2007 |
|         1239 | 2008 |
|          569 | 2009 |
|            8 | 2010 |
+--------------+------+

*/

-- Extract only those that were not matched
SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,4) IN ('USPP','USRE') AND c.pnumber IS NULL
    INTO OUTFILE '/var/lib/mysql-files/non-matched-us-pp,re.csv'
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n';
-- 2.768 non-matched rows

-- Analyze years for those non-matched
SELECT COUNT(a.pat), a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,4) IN ('USPP','USRE') AND c.pnumber IS NULL 
    GROUP BY a.yr;
    /*
    +--------------+------+
    | COUNT(a.pat) | yr   |
    +--------------+------+
    |            1 | 1988 |
    |            3 | 1989 |
    |            3 | 1990 |
    |            9 | 1991 |
    |           19 | 1992 |
    |           35 | 1993 |
    |          101 | 1994 |
    |          205 | 1995 |
    |          681 | 1996 |
    |          882 | 1997 |
    |          711 | 1998 |
    |          114 | 1999 |
    |            1 | 2000 |
    |            1 | 2002 |
    |            2 | 2008 |
    +--------------+------+
    This confirm the hypothesis that most of the non-matched values correspond to observations before 2000, because in 2001 there was a change in USPTO patent structure 
    */
    

-- Only first 100 rows to make some tests, and selecting patents published from 2001
SELECT a.pat, a.yr
    FROM riccaboni.t01 a
    LEFT JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber
    WHERE LEFT(a.pat,4) IN ('USPP','USRE') AND c.pnumber IS NULL
    LIMIT 0,100;
    
  -- Search in Patstat some as a test
  SELECT a.PUBLN_AUTH, a.PUBLN_NR, a.PUBLN_KIND, a.PUBLN_DATE
        FROM patstat2016b.TLS211_PAT_PUBLN a
        WHERE a.PUBLN_AUTH='US' AND a.PUBLN_NR LIKE '%11149%' AND LEFT(a.PUBLN_DATE,4)='1998';   
  
  SELECT a.PUBLN_AUTH, a.PUBLN_NR, a.PUBLN_KIND, a.PUBLN_DATE
      FROM patstat2016b.TLS211_PAT_PUBLN a
      WHERE a.PUBLN_AUTH='US' AND a.PUBLN_NR LIKE '%101753%';   
          
        
-----------------------------------------------------------------------------------
-- Merge with REGPAT

SELECT COUNT(CHAR_LENGTH(a.Pub_nbr)), CHAR_LENGTH(a.Pub_nbr)
      FROM oecd.tqual03 a
      GROUP BY CHAR_LENGTH(a.Pub_nbr);
      /*
      +-------------------------------+------------------------+
      | COUNT(CHAR_LENGTH(a.Pub_nbr)) | CHAR_LENGTH(a.Pub_nbr) |
      +-------------------------------+------------------------+
      |                       5470745 |                     10 |
      |                       2092096 |                     12 |
      +-------------------------------+------------------------+
      */
      -- All publication numbers from regpat have 10 or 12 characters
      -- Total rows: 7562841
      
-- This is just to verify that there is not truncated data for the first column
SELECT COUNT(CHAR_LENGTH(a.appln_id)), CHAR_LENGTH(a.appln_id)
      FROM oecd.tqual03 a
      GROUP BY CHAR_LENGTH(a.appln_id);  
      /*
      +--------------------------------+-------------------------+
      | COUNT(CHAR_LENGTH(a.appln_id)) | CHAR_LENGTH(a.appln_id) |
      +--------------------------------+-------------------------+
      |                           5943 |                       6 |
      |                        4794232 |                       8 |
      |                        2762666 |                       9 |
      +--------------------------------+-------------------------+
      */
      
SELECT COUNT(a.Pub_nbr) AS Frequency, LEFT(a.Pub_nbr,5) AS US_Char 
      FROM oecd.tqual03 a
      GROUP BY LEFT(a.Pub_nbr,5); 
  -- It does not work, because it doest not have the same structure for the publication number    


------------------------------------------------------------------------------------

CREATE TABLE patstat2016b.tusptest AS
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')) AS pnumber, b.PUBLN_KIND, b.PAT_PUBLN_ID, b.APPLN_ID 
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R')) c
    ON  a.pat=c.pnumber
UNION ALL   
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')) AS pnumber, b.PUBLN_KIND, b.PAT_PUBLN_ID, b.APPLN_ID 
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,1) IN ('D', 'H')) c
    ON  a.pat=c.pnumber
UNION ALL   
SELECT c.pnumber, c.PUBLN_KIND, c.PAT_PUBLN_ID, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')) AS pnumber, b.PUBLN_KIND, b.PAT_PUBLN_ID, b.APPLN_ID 
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='US' AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE')) c
    ON  a.pat=c.pnumber;
    
    
-----------------------------------------------------------------------------------------------
-- Merge with US_CIT_COUNTS
-----------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT b.US_Pub_nbr), CHAR_LENGTH(b.US_Pub_nbr) AS Nchar
                              FROM oecd_citations.US_CIT_COUNTS b
                              GROUP BY CHAR_LENGTH(b.US_Pub_nbr);
/*                              
+------------------------------+-------+
| COUNT(DISTINCT b.US_Pub_nbr) | Nchar |
+------------------------------+-------+
|                      5438536 |     9 |
|                      1559533 |    12 |
+------------------------------+-------+
*/

SELECT COUNT(a.US_Pub_nbr) AS Frequency, LEFT(a.US_Pub_nbr,4) AS US_Char 
      FROM oecd_citations.US_CIT_COUNTS a
      GROUP BY LEFT(a.US_Pub_nbr,4);
      
/*
+-----------+---------+
| Frequency | US_Char |
+-----------+---------+
|   1559533 | US20    |
|      1031 | US39    |
|     56767 | US40    |
|     94618 | US41    |
|     97552 | US42    |
|     98276 | US43    |
|     86526 | US44    |
|     98897 | US45    |
|     98568 | US46    |
|     98981 | US47    |
|     98909 | US48    |
|     98678 | US49    |
|     98532 | US50    |
|     98326 | US51    |
|     98302 | US52    |
|     98334 | US53    |
|     98179 | US54    |
|     97936 | US55    |
|     97254 | US56    |
|     96571 | US57    |
|     96607 | US58    |
|     98344 | US59    |
|     98532 | US60    |
|     98629 | US61    |
|     98733 | US62    |
|     98606 | US63    |
|     98866 | US64    |
|     98902 | US65    |
|     99071 | US66    |
|     98987 | US67    |
|     98954 | US68    |
|     99094 | US69    |
|     98618 | US70    |
|     99067 | US71    |
|     98968 | US72    |
|     99027 | US73    |
|     99022 | US74    |
|     99059 | US75    |
|     99183 | US76    |
|     99050 | US77    |
|     99126 | US78    |
|     99005 | US79    |
|     99049 | US80    |
|     99039 | US81    |
|     98928 | US82    |
|     98862 | US83    |
|     98781 | US84    |
|     98866 | US85    |
|     98674 | US86    |
|     98841 | US87    |
|     97348 | US88    |
|     98724 | US89    |
|     98687 | US90    |
|     98666 | US91    |
|     98642 | US92    |
|     98690 | US93    |
|     98631 | US94    |
|     53599 | US95    |
|         2 | USD6    |
|      2241 | USPP    |
|     16579 | USRE    |
+-----------+---------+
*/      

SELECT COUNT(a.US_Pub_nbr) AS Frequency, LEFT(a.US_Pub_nbr,4) AS US_Char 
      FROM oecd_citations.US_CIT_COUNTS a
      WHERE CHAR_LENGTH(a.US_Pub_nbr)=12
      GROUP BY LEFT(a.US_Pub_nbr,4);
/*
+-----------+---------+
| Frequency | US_Char |
+-----------+---------+
|   1559533 | US20    |
+-----------+---------+
All pnumbers with 12 characters beging with US20
*/      

SELECT COUNT(a.US_Pub_nbr) AS Frequency, LEFT(a.US_Pub_nbr,8) AS US_Char 
      FROM oecd_citations.US_CIT_COUNTS a
      WHERE CHAR_LENGTH(a.US_Pub_nbr)=12
      GROUP BY LEFT(a.US_Pub_nbr,8);
/*
It begings with 200100
+-----------+----------+
| Frequency | US_Char  |
+-----------+----------+
|       379 | US200100 |
|       494 | US200101 |
*/
      
-----------------------------------------------------------------------------------------------
-- Merge with Patents view
-----------------------------------------------------------------------------------------------

-- Types of codes
SELECT COUNT(b.series_code), b.series_code
                              FROM uspto.PVIEW b
                              GROUP BY b.series_code;

/*
+----------------------+-------------+
| COUNT(b.series_code) | series_code |
+----------------------+-------------+
|                    1 | 00          |
|                  157 | 02          |
|                  367 | 03          |
|                 1294 | 04          |
|               332437 | 05          |
|               585256 | 06          |
|               623526 | 07          |
|               697928 | 08          |
|               715810 | 09          |
|               649741 | 10          |
|               594300 | 11          |
|               636545 | 12          |
|               631662 | 13          |
|               421245 | 14          |
|                32016 | 15          |
|               424390 | 29          |
|                  339 | 35          |
|                19650 | D           |
+----------------------+-------------+
18 rows in set (4,67 sec)

*/

SELECT COUNT(DISTINCT b.number), CHAR_LENGTH(b.number) AS Nchar
                              FROM uspto.PVIEW b
                              GROUP BY CHAR_LENGTH(b.number);
/*
+--------------------------+-------+
| COUNT(DISTINCT b.number) | Nchar |
+--------------------------+-------+
|                    19648 |     7 |
|                  6337820 |     8 |
+--------------------------+-------+
*/    


SELECT COUNT(a.number) AS Frequency, LEFT(a.number,4) AS US_Char 
      FROM uspto.PVIEW a
      WHERE CHAR_LENGTH(a.number)=8
      GROUP BY LEFT(a.number,4);
      
SELECT COUNT(a.number) AS Frequency, RIGHT(a.number,2) AS US_Char 
      FROM uspto.PVIEW a
      WHERE CHAR_LENGTH(a.number)=8
      GROUP BY RIGHT(a.number,2);      
