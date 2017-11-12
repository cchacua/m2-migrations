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

SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 8, '0'))
    WHERE b.PUBLN_AUTH='US'
    AND LEFT(b.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R') ;
--  3.983.470 vs 3.984.771

SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,1), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-1), 7, '0'))
    WHERE b.PUBLN_AUTH='US' 
          AND LEFT(b.PUBLN_NR,1) IN ('D', 'H') ;     
-- 214.624  VS 241.547

SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0'))
    WHERE b.PUBLN_AUTH='US' 
          AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE') ;
          
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0')))
    FROM riccaboni.t01 a
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LEFT(b.PUBLN_NR,2), LPAD(RIGHT(b.PUBLN_NR, CHAR_LENGTH(b.PUBLN_NR)-2), 6, '0'))
    WHERE b.PUBLN_AUTH='US' 
          AND LEFT(b.PUBLN_NR,2) IN ('PP', 'RE') ;          
-- 14.886 VS 17.654          
 
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
      