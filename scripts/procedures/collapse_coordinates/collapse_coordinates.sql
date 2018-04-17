---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Split loc in lati and longi
-- TABLE T08, only selected classes, at least one inventor in US, mobility links, only inventors, no firms
-- riccaboni.t08_cla_aous_mob_coor
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


DROP TABLE IF EXISTS riccaboni.t08_cla_aous_mob_coor;
CREATE TABLE riccaboni.t08_cla_aous_mob_coor AS
SELECT DISTINCT a.*, substring_index(a.loc,',',1) as lati, substring_index(a.loc,',',-1) as longi
    FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
Query OK, 3121736 rows affected (1 min 33,05 sec)
Records: 3121736  Duplicates: 0  Warnings: 0
*/

SELECT * FROM riccaboni.t08_cla_aous_mob_coor LIMIT 0,100;

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- Table with collapsed lati and longi
-- TABLE T08, only selected classes, at least one inventor in US, mobility links, only inventors, no firms
-- riccaboni.t08_cla_aous_mob_coor
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.t08_idpat_lcoll;
CREATE TABLE riccaboni.t08_idpat_lcoll AS
SELECT a.ID, a.finalID, a.pat, AVG(a.lati) AS clati, AVG(a.longi) AS clongi
    FROM riccaboni.t08_cla_aous_mob_coor a
    GROUP BY a.ID, a.finalID, a.pat;
/*
Query OK, 3038846 rows affected (1 min 19,76 sec)
Records: 3038846  Duplicates: 0  Warnings: 0
*/

SELECT * FROM riccaboni.t08_idpat_lcoll LIMIT 0,100;

-- Problems
/*
- Omit unlocated patents
- Put year, instead of patent number
- Select only one address, and do not compute average

- Work with families or select the smallest distance
*/
