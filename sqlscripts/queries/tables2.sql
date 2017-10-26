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
WHERE patstat2016b.TLS211_PAT_PUBLN.PUBLN_AUTH IN ('EP', 'WO', 'US') ;
-- Number of patents 23.802.901
-- to verify that there are only patents from those three agencies
SELECT DISTINCT patstat2016b.TLS211_SAMPLE.PUBLN_AUTH
              FROM patstat2016b.TLS211_SAMPLE;

-- To verify number of characters of number
SELECT CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR)
      FROM TLS211_SAMPLE
      GROUP BY CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR);
-- There are publications numbers with 1-13 characters. However, not all the sample is four our interest, as we have not yet selected the especific years
SELECT COUNT(*), CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR)
      FROM TLS211_SAMPLE
      GROUP BY CHAR_LENGTH(TLS211_SAMPLE.PUBLN_NR);
      /*
      +----------+
      | COUNT(*) |
      +----------+
      |       12 |1
      |      120 |2
      |     1082 |3
      |    16433 |4
      |    94306 |5
      |   907847 |6
      | 15373341 |7
      |   222937 |8
      |      855 |9
      |  7185861 |10
      |       79 |11
      |       27 |12
      |        1 |13
      +----------+
      */
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
      |  2684761 |                              9 |
      |  4243972 |                             10 |
      |  2361535 |                             12 |
      +----------+--------------------------------+
      */

