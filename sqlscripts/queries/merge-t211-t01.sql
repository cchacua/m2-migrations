-- MERGE TESTS

-- Table only wih EP, WO, US
USE patstat2016b;

-- See if the publication number original works
SELECT COUNT(DISTINCT patstat2016b.TLS211_PAT_PUBLN.publn_nr_original), patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH 
      FROM patstat2016b.TLS211_PAT_PUBLN 
      WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH IN ('EP', 'US', 'WO')
      GROUP BY patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH;
--  5.600.620 

SELECT COUNT(t01.pat) AS Frequency, LEFT(t01.pat,3) AS US_Char 
      FROM t01
      WHERE LEFT(t01.pat,2)='US'
      GROUP BY LEFT(t01.pat,3);
      /*
      +-----------+---------+
      | Frequency | US_Char |
      +-----------+---------+
      |   3984771 | US0     |
      |    241012 | USD     |
      |       535 | USH     |
      |     11404 | USP     |
      |      6250 | USR     |
      +-----------+---------+
      */      
      

SELECT COUNT(t01.pat) AS Frequency, LEFT(t01.pat,8) AS WO_Char 
      FROM t01
      WHERE LEFT(t01.pat,2)='WO'
      GROUP BY LEFT(t01.pat,8);

SELECT t01.pat
      FROM t01
      WHERE LEFT(t01.pat,2)='WO'
      LIMIT 10000,10050;
      
SELECT patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR
      FROM patstat2016b.TLS211_PAT_PUBLN
      WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='WO'
      AND CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)<10
      LIMIT 100000,100500;      
      /*

      */

SELECT COUNT(t01.pat) AS Frequency
      FROM t01
      WHERE LEFT(t01.pat,3) IN ('USD', 'USH', 'USP', 'USR');   

SELECT COUNT(CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)) AS Frequency, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR) AS N_char, LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1) AS US_Char 
      FROM patstat2016b.TLS211_PAT_PUBLN
      WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US' AND LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1) IN ('D', 'H', 'P', 'R')
      GROUP BY CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR), LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1);
    /*
        +-----------+--------+---------+
    | Frequency | N_char | US_Char |
    +-----------+--------+---------+
    |         9 |      2 | H       |
    |         1 |      3 | D       |
    |        90 |      3 | H       |
    |         1 |      3 | R       |
    |        18 |      4 | D       |
    |       907 |      4 | H       |
    |         8 |      4 | R       |
    |       160 |      5 | D       |
    |      1396 |      5 | H       |
    |         1 |      5 | P       |
    |       106 |      5 | R       |
    |      5457 |      6 | D       |
    |         6 |      6 | H       |
    |         2 |      6 | P       |
    |      1291 |      6 | R       |
    |    432115 |      7 | D       |
    |        62 |      7 | H       |
    |     15280 |      7 | P       |
    |     32744 |      7 | R       |
    |         2 |      8 | D       |
    |         8 |      8 | H       |
    |         1 |      8 | P       |
    |       103 |      8 | R       |
    |         8 |      9 | R       |
    +-----------+--------+---------+
    */      
      
-- Test fill with 0's
SELECT LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 8, '0') AS pnumber FROM patstat2016b.TLS211_PAT_PUBLN 
WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US' LIMIT 0,10;
  -- For the US there are some problems because letters are before the numbers
SELECT LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 10, '0') AS pnumber FROM patstat2016b.TLS211_PAT_PUBLN 
WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='WO' LIMIT 0,10;

SELECT LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 7, '0') AS pnumber FROM patstat2016b.TLS211_PAT_PUBLN 
WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='EP' LIMIT 0,10;


-- Merge by publication authority 
----------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
              LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 7, '0')))
    FROM t01 
    INNER JOIN TLS211_PAT_PUBLN
    ON  t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
              LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 7, '0'))
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='EP' ;
-- 2.684.757 and there should be  2.684.761, so there are 4 missing patents  

---
SELECT COUNT(DISTINCT CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
              LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 8, '0')))
    FROM t01 
    INNER JOIN TLS211_PAT_PUBLN
    ON  t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH, 
              LPAD(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, 8, '0'))
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US'
    AND LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1) NOT IN ('D', 'H', 'P', 'R') ; 
--  3.983.470 vs 3.984.771

SELECT COUNT(DISTINCT CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-1), 7, '0')))
    FROM t01 
    INNER JOIN TLS211_PAT_PUBLN
    ON  t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-1), 7, '0'))
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US' 
          AND LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1) IN ('D', 'H') ;     
-- 214.624  VS 241.547

SELECT COUNT(DISTINCT CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,1),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-2), 6, '0')))
    FROM t01 
    INNER JOIN TLS211_PAT_PUBLN
    ON  t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,2),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-2), 6, '0'))
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='US' 
          AND LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,2) IN ('PP', 'RE') ;
-- 14.886 VS 17.654          
    
--
SELECT COUNT(DISTINCT CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,4),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-4), 6, '0')))
    FROM riccaboni.t01 
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN
    ON  t01.pat=CONCAT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH,
              LEFT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR,4),
              LPAD(RIGHT(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR, CHAR_LENGTH(patstat2016b.TLS211_PAT_PUBLN.PUBLN_NR)-4), 6, '0'))
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH='WO' ;    
-- 1568014 VS 2361535


SELECT COUNT(DISTINCT patstat2016b.TLS211_PAT_PUBLN.publn_nr_original)
    FROM t01 
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN
    ON  t01.pat=patstat2016b.TLS211_PAT_PUBLN.publn_nr_original
    WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH IN ('EP', 'US', 'WO') ;