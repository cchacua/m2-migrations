----------------------------------------------------------------------------------------------
-- Merge NAT TLS201_APPLN
----------------------------------------------------------------------------------------------
SELECT COUNT(DISTINCT a.APPLN_ID)
  FROM patstat2016b.twopt a
  INNER JOIN (SELECT DISTINCT c.APPLN_ID
                      FROM pct.NAT b
                      INNER JOIN patstat2016b.TLS201_APPLN c
                      ON  b.appln_id=c.APPLN_ID) d
  ON a.APPLN_ID=d.APPLN_ID;

/*
+----------------------------+
| COUNT(DISTINCT a.APPLN_ID) |
+----------------------------+
|                    2040285 |
+----------------------------+
1 row in set (41,68 sec)
2.040.285 FINAL vs 2.363.210 twopt vs 2.078.988 NAT 
*/

----------------------------------------------------------------------------------------------
-- Merge NAT two_cit_ric
----------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT a.Citing_appln_id)
  FROM patstat2016b.two_cit_ric a
  INNER JOIN (SELECT DISTINCT c.APPLN_ID
                      FROM pct.NAT b
                      INNER JOIN patstat2016b.TLS201_APPLN c
                      ON  b.appln_id=c.APPLN_ID) d
  ON a.Citing_appln_id=d.APPLN_ID;
/*  
+-----------------------------------+
| COUNT(DISTINCT a.Citing_appln_id) |
+-----------------------------------+
|                           2040285 |
+-----------------------------------+
1 row in set (46,91 sec)

2.040.285 FINAL vs 2.361.517 two_cit_ric vs 2.078.988 NAT 
*/

