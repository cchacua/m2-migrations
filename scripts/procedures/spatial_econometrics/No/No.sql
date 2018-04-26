-- Example if not using riccaboni.t08_allclasses_t01_loc_allteam
SELECT a.* FROM christian.t08_class_at1us_date_fam_nceltic a INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat WHERE a.loc='-15.79153,-47.885907';
SELECT * FROM  patstat2016b.TLS206_PERSON_APPLNID_COUNTRY_ATLEASTONEUSA_F WHERE pat='WO1986007479';
SELECT * FROM riccaboni.t08 WHERE pat='WO1986007479';

SELECT * FROM christian.t08_class_at1us_date_fam_nceltic WHERE ID='LI3909816';
SELECT * FROM pct.NAT WHERE appln_id='47045313';
/*
+----------+-----------------+------------------+----------------------+------------------------+-------------------------+
| appln_id | appln_nr        | RELATION_TYPE_ID | NAME                 | NATIONALITY_STATE_CODE | STATE_OF_RESIDENCE_CODE |
+----------+-----------------+------------------+----------------------+------------------------+-------------------------+
| 47045313 |         8601212 | 4                | MALVAR, Henrique, S. |                        |                         |
+----------+-----------------+------------------+----------------------+------------------------+-------------------------+
1 row in set (1,47 sec)
*/
SELECT * FROM oecd.treg07 WHERE Appln_id='47045313';
