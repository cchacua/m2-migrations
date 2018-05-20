-- SECTOR OF THE APLICANTS FOR THE CONSIDERED PATENTS
-- Requires: get_techclasses_proxi 
-- So, run first

-- PSN by pat, for the sample of relevant patents

DROP TABLE IF EXISTS christian.pat_institu;
CREATE TABLE christian.pat_institu AS
SELECT DISTINCT a.pat, b.PSN_SECTOR, a.EARLIEST_FILING_YEAR
  FROM christian.nodes_counter_allsamples_dis_pat2 a
  INNER JOIN patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat b
  ON a.pat=b.pat
  WHERE b.INVT_SEQ_NR='0' AND b.APPLT_SEQ_NR>0;
/*
Query OK, 970194 rows affected (1 min 5,04 sec)
Records: 970194  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM  christian.pat_institu;                                     
ALTER TABLE christian.pat_institu ADD INDEX(pat);

SELECT * FROM christian.pat_institu LIMIT 0,10;

SELECT COUNT(DISTINCT pat) FROM christian.pat_institu;



