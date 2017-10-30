-- OECD PCT
SELECT * FROM oecd.treg07 LIMIT 0,10;

-- Verify number of characters
SELECT COUNT(DISTINCT CHAR_LENGTH(a.PCT_Nbr)), CHAR_LENGTH(a.PCT_Nbr)
      FROM oecd.treg07 a
      GROUP BY CHAR_LENGTH(a.PCT_Nbr);
  -- All have 12     

SELECT COUNT(CHAR_LENGTH(a.pat)), CHAR_LENGTH(a.pat)
      FROM riccaboni.t01 a
      WHERE LEFT(a.pat,2)='WO'
      GROUP BY CHAR_LENGTH(a.pat);
  -- All have 12
  
SELECT COUNT(CHAR_LENGTH(c.PUBLN_NR)), CHAR_LENGTH(c.PUBLN_NR)
      FROM patstat2016b.TLS211_PAT_PUBLN c
      WHERE c.PUBLN_AUTH='WO' 
      GROUP BY CHAR_LENGTH(c.PUBLN_NR);
  -- There are PUBLN_NR that have between 2-13 characters! Although most of them have 7,8 and 10
  /*
    +--------------------------------+-------------------------+
  | COUNT(CHAR_LENGTH(c.PUBLN_NR)) | CHAR_LENGTH(c.PUBLN_NR) |
  +--------------------------------+-------------------------+
  |                              4 |                       2 |
  |                              1 |                       5 |
  |                         775668 |                       7 |
  |                         220507 |                       8 |
  |                             17 |                       9 |
  |                        2569080 |                      10 |
  |                             38 |                      11 |
  |                              5 |                      12 |
  |                              1 |                      13 |
  +--------------------------------+-------------------------+
  */
  
-- Verify number of rows
SELECT COUNT(DISTINCT a.PCT_Nbr)
      FROM oecd.treg07 a;
--  2.669.516
SELECT COUNT(DISTINCT a.Appln_id)
      FROM oecd.treg07 a;
-- 2.623.156 

SELECT COUNT(DISTINCT a.pat)
      FROM riccaboni.t01 a
      WHERE LEFT(a.pat,2)='WO';
-- 2.361.535      

-- Merge
SELECT COUNT(DISTINCT b.PCT_Nbr)
    FROM riccaboni.t01 a
    INNER JOIN oecd.treg07 b ON  a.pat=b.PCT_Nbr;
-- 2.345.816 VS 2.361.535
--     INNER JOIN patstat2016b.TLS211_PAT_PUBLN c ON  b.Appln_id=c.APPLN_ID
--     WHERE c.PUBLN_AUTH='WO'


SELECT COUNT(DISTINCT b.PCT_Nbr)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT c.PCT_Nbr FROM oecd.treg07 c) b ON  a.pat=b.PCT_Nbr;
-- 2.345.816 

-- Almost all numbers can be matched with Patstat
SELECT COUNT(DISTINCT b.Appln_id)
    FROM oecd.treg07 b 
    INNER JOIN (SELECT DISTINCT d.APPLN_ID FROM patstat2016b.TLS211_PAT_PUBLN d WHERE d.PUBLN_AUTH='WO') c ON  b.Appln_id=c.APPLN_ID;
-- 2.623.154

SELECT COUNT(b.PCT_Nbr)
    FROM oecd.treg07 b 
    INNER JOIN (SELECT d.APPLN_ID 
                      FROM patstat2016b.TLS211_PAT_PUBLN d 
                      WHERE d.PUBLN_AUTH='WO'
                      GROUP BY d.APPLN_ID) c 
                ON  b.Appln_id=c.APPLN_ID;
-- 6998003 <- So, there are publication numbers with multiple Aplications ID

SELECT COUNT(DISTINCT b.PCT_Nbr)
    FROM oecd.treg07 b 
    INNER JOIN (SELECT d.APPLN_ID 
                      FROM patstat2016b.TLS211_PAT_PUBLN d 
                      WHERE d.PUBLN_AUTH='WO'
                      GROUP BY d.APPLN_ID) c 
                ON  b.Appln_id=c.APPLN_ID;
-- 2.623.154

-- Selecting those which can be merged
SELECT COUNT(DISTINCT a.pat)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT e.PCT_Nbr, e.Appln_id
                      FROM oecd.treg07 e) b 
                      ON  a.pat=b.PCT_Nbr
    INNER JOIN (SELECT DISTINCT d.APPLN_ID 
                      FROM patstat2016b.TLS211_PAT_PUBLN d 
                      WHERE d.PUBLN_AUTH='WO') c 
                ON  b.Appln_id=c.APPLN_ID;
-- 2.345.793

-- Store those values on a table
CREATE TABLE patstat2016b.t01r07t211 AS
SELECT DISTINCT a.pat, c.APPLN_ID
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT e.PCT_Nbr, e.Appln_id
                      FROM oecd.treg07 e) b 
                      ON  a.pat=b.PCT_Nbr
    INNER JOIN (SELECT DISTINCT d.APPLN_ID 
                      FROM patstat2016b.TLS211_PAT_PUBLN d 
                      WHERE d.PUBLN_AUTH='WO') c 
                ON  b.Appln_id=c.APPLN_ID;
-- 2345793

-- To allow nulls
ALTER TABLE riccaboni.t01 MODIFY pat VARCHAR(12);
ALTER TABLE oecd.treg07 MODIFY PCT_Nbr CHAR(12);
ALTER TABLE patstat2016b.TLS211_PAT_PUBLN MODIFY APPLN_ID int(10) unsigned;

-- Another table with the values of the join only using Patstat and Riccaboni's
CREATE TABLE patstat2016b.t01t211wo AS
SELECT DISTINCT b.pat, c.APPLN_ID
    FROM riccaboni.t01 b
    INNER JOIN (SELECT DISTINCT CONCAT(a.PUBLN_AUTH,
                              LEFT(a.PUBLN_NR,4),
                              LPAD(RIGHT(a.PUBLN_NR, CHAR_LENGTH(a.PUBLN_NR)-4), 6, '0')
                              ) AS pat, a.APPLN_ID 
                FROM patstat2016b.TLS211_PAT_PUBLN a
                WHERE a.PUBLN_AUTH='WO') c
    ON  b.pat=c.pat;  

SELECT COUNT(DISTINCT a.pat) FROM patstat2016b.t01t211wo a;     
    
-- 1.568.587 rows but only 1.568.014 different pub numbers 

SELECT COUNT(DISTINCT a.pat)
  FROM riccaboni.t01 a
  LEFT JOIN (SELECT DISTINCT c.pat FROM patstat2016b.t01t211wo c) b
  ON a.pat=b.pat
  LEFT JOIN (SELECT DISTINCT e.pat FROM patstat2016b.t01r07t211 e) d
  ON a.pat=d.pat
  ;
-- 1552380  
-- (1568014-1552380)+2345793-2361535 = -108 With Patstat ID
-- (1568014-1552380)+2345816-2361535 = -85 Without Patstat ID

    
    
