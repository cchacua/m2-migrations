---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH AUTHORS' NAMES FOR THE SELECTED CLASSES USING REGPAT
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t08_names_allclasses_regpat;
CREATE TABLE riccaboni.t08_names_allclasses_regpat AS
SELECT a.Appln_id a.Inv_name a.Address a.Reg_code a.Ctry_code
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg07 a
      ON b.APPLN_ID=a.Appln_id
UNION
SELECT a.Appln_id a.Inv_name a.Address a.Reg_code a.Ctry_code
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg03 a
      ON b.APPLN_ID=a.Appln_id
UNION
SELECT a.Appln_id a.Inv_name a.Address a.Reg_code a.Ctry_code
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg03 a
      ON b.APPLN_ID=a.Appln_id
;

SELECT COUNT(DISTINCT a.Appln_id)
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg07 a
      ON b.pat=a.PCT_Nbr;
/*705032 vs 705.255*/

SELECT COUNT(DISTINCT b.pat)
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg07 a
      ON b.APPLN_ID=a.Appln_id;

SELECT COUNT(DISTINCT a.Appln_id)
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg03 a
      ON b.pat=a.Pub_nbr;
/*
689952 vs 693.716
*/



SELECT COUNT(DISTINCT a.Appln_id)
      FROM riccaboni.t01_allclasses_appid_patstat b 
      INNER JOIN oecd.treg07 a
      ON b.APPLN_ID=a.Appln_id
      WHERE LEFT(b.pat,2)='WO';
