-- SECTOR OF THE APLICANTS FOR THE CONSIDERED PATENTS

-- PSN by pat, for the sample of relevant patents

DROP TABLE IF EXISTS christian.pat_institu;
CREATE TABLE christian.pat_institu AS
SELECT DISTINCT a.pat, b.PSN_SECTOR
  FROM christian.pat_nceltic_allus a
  INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat b
  ON a.pat=b.pat
  WHERE b.INVT_SEQ_NR='0' AND b.APPLT_SEQ_NR>0;
/*
Query OK, 528471 rows affected (40,28 sec)
Records: 528471  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.pat_institu;                                     
ALTER TABLE christian.pat_institu ADD INDEX(pat);

SELECT * FROM christian.pat_institu LIMIT 0,10;

-- PSN by finalID and Year
DROP TABLE IF EXISTS christian.inv_institu;
CREATE TABLE christian.inv_institu AS
SELECT DISTINCT a.finalID, a.EARLIEST_FILING_YEAR, CONCAT(a.EARLIEST_FILING_YEAR, a.finalID) AS yfinalID, b.PSN_SECTOR
  FROM christian.t08_class_at1us_date_fam_for a
  INNER JOIN christian.pat_institu b
  ON a.pat=b.pat;
/*
Query OK, 752828 rows affected (41,21 sec)
Records: 752828  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.inv_institu;                                     
ALTER TABLE christian.inv_institu ADD INDEX(yfinalID);
ALTER TABLE christian.inv_institu ADD INDEX(finalID);

SELECT * FROM christian.inv_institu LIMIT 0,10;
SELECT DISTINCT PSN_SECTOR  FROM christian.inv_institu LIMIT 0,10;

