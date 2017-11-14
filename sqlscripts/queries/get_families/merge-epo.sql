-- Count merge EPO
SELECT COUNT(DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0')))
    FROM riccaboni.t01 a 
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0'))
    WHERE b.PUBLN_AUTH='EP' ;

SELECT COUNT(c.pubnumber)
    FROM riccaboni.t01 a 
    INNER JOIN (SELECT  DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0')) AS pubnumber
                        FROM patstat2016b.TLS211_PAT_PUBLN b
                        WHERE b.PUBLN_AUTH='EP') c
    ON  a.pat=c.pubnumber;
-- 2.684.757 and there should be  2.684.761, so there are 4 missing patents

    
-- Create table with the merge for the EPO data
CREATE TABLE patstat2016b.mergeepo AS
SELECT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0')) AS pubnumber, b.PUBLN_KIND, b.PAT_PUBLN_ID, b.APPLN_ID
    FROM riccaboni.t01 a 
    INNER JOIN patstat2016b.TLS211_PAT_PUBLN b
    ON  a.pat=CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0'))
    WHERE b.PUBLN_AUTH='EP' ;
-- There are 5.118.953 rows as there are publication numbers with other publication kinds, etc    

-- Export EPO publication numbers to CSV
  -- Those from riccaboni
  SELECT a.pat AS pubnumber
        FROM riccaboni.t01 a
        WHERE LEFT(a.pat,2)='EP'
        INTO OUTFILE '/var/lib/mysql-files/epo-pubnumber-riccaboni.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n';
  -- Those from the merge
    -- Method 1
      SELECT c.pubnumber AS pubnumber
        FROM riccaboni.t01 a 
        INNER JOIN (SELECT  DISTINCT CONCAT(b.PUBLN_AUTH, LPAD(b.PUBLN_NR, 7, '0')) AS pubnumber
                            FROM patstat2016b.TLS211_PAT_PUBLN b
                            WHERE b.PUBLN_AUTH='EP') c
        ON  a.pat=c.pubnumber
        INTO OUTFILE '/var/lib/mysql-files/epo-pubnumber-merge.csv'
            FIELDS TERMINATED BY ','
            ENCLOSED BY '"'
            LINES TERMINATED BY '\n';
     -- Method 2 (Faster, but requires the table from the merge)
     SELECT DISTINCT a.pubnumber
        FROM patstat2016b.mergeepo a
        INTO OUTFILE '/var/lib/mysql-files/epo-pubnumber-merge2.csv'
        FIELDS TERMINATED BY ','
        ENCLOSED BY '"'
        LINES TERMINATED BY '\n';
        
        
-- Analize non-joint rows
  /* Those are the non-joint rows
  1 EP0691026
  2 EP2578407
  3 EP2600934
  4 EP2679627
  */    
  SELECT a.pat, a.yr
        FROM riccaboni.t01 a
        WHERE a.pat IN  ('EP0691026','EP2578407','EP2600934','EP2679627');
  /*
  +-----------+------+
  | pat       | yr   |
  +-----------+------+
  | EP0691026 | 1994 |
  | EP2578407 | 2011 |
  | EP2600934 | 2011 |
  | EP2679627 | 2012 |
  +-----------+------+
  */
  
  -- Search in Patstat
  SELECT a.PUBLN_AUTH, a.PUBLN_NR, a.PUBLN_KIND, a.PUBLN_DATE
        FROM patstat2016b.TLS211_PAT_PUBLN a
        WHERE a.PUBLN_AUTH='EP' AND a.PUBLN_NR LIKE '%691026%';
      /*  
      +------------+----------+------------+------------+
      | PUBLN_AUTH | PUBLN_NR | PUBLN_KIND | PUBLN_DATE |
      +------------+----------+------------+------------+
      | EP         | 1691026  | A1         | 2006-08-16 |
      | EP         | 2691026  | A2         | 2014-02-05 |
      | EP         | 2691026  | A4         | 2014-08-20 |
      +------------+----------+------------+------------+
      */
      SELECT a.pat, a.yr
        FROM riccaboni.t01 a
        WHERE a.pat IN  ('EP1691026','2691026');
      -- Only EP1691026 exists and it is from 2015

-----------------------------------------------------------------------------------
-- Merge with REGPAT

SELECT COUNT(CHAR_LENGTH(a.Pub_nbr)), CHAR_LENGTH(a.Pub_nbr)
      FROM oecd.treg03 a
      GROUP BY CHAR_LENGTH(a.Pub_nbr);
  -- All publication numbers from regpat also have 9 characters    

SELECT COUNT(DISTINCT b.Pub_nbr)
    FROM riccaboni.t01 a
    INNER JOIN (SELECT DISTINCT c.Pub_nbr FROM oecd.treg03 c) b ON  a.pat=b.Pub_nbr;
  -- There are 2.672.608 patents using the merge from RegPat, so it's better to use Patstat
  
SELECT a.Pub_nbr
        FROM oecd.treg03 a
        WHERE a.Pub_nbr IN  ('EP0691026','EP2578407','EP2600934','EP2679627');
    -- And even the four patents are also missing in the Regpat dataset