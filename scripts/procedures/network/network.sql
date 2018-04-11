---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.t_id_pat;
CREATE TABLE riccaboni.t_id_pat AS
SELECT DISTINCT a.finalID, a.pat
      FROM riccaboni.t08_names_allclasses_us_mob_atleastone a;
/*
Query OK, 3039315 rows affected (56,10 sec)
Records: 3039315  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t_id_pat;                                     
ALTER TABLE riccaboni.t_id_pat ADD INDEX(finalID);
ALTER TABLE riccaboni.t_id_pat ADD INDEX(pat);

SELECT * FROM riccaboni.t_id_pat LIMIT 0,30;

---------------------------------------------------------------------------------------------------
-- DIRECTED EDGE LIST
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.edges_dir;
CREATE TABLE riccaboni.edges_dir AS
SELECT DISTINCT a.finalID, b.finalID AS finalID_, a.pat
      FROM riccaboni.t_id_pat a
      INNER JOIN riccaboni.t_id_pat b
      ON a.pat=b.pat
      WHERE a.finalID!=b.finalID;
/*
WHERE a.ID!=b.ID IS TO AVOID LINKS TO THEMSELVES
Query OK, 10711564 rows affected (6 min 32,06 sec)
Records: 10.711.564  Duplicates: 0  Warnings: 0
*/

SELECT * FROM riccaboni.edges_dir LIMIT 0,30;

---------------------------------------------------------------------------------------------------
-- UNDIRECTED EDGE LIST
-- See: https://stackoverflow.com/questions/21800873/select-distinct-pair-values-mysql
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.edges_undir;
CREATE TABLE riccaboni.edges_undir AS
SELECT DISTINCT LEAST(a.finalID, b.finalID) AS finalID_, GREATEST(a.finalID, b.finalID) AS finalID__, a.pat
      FROM riccaboni.t_id_pat a
      INNER JOIN riccaboni.t_id_pat b
      ON a.pat=b.pat
      WHERE a.finalID!=b.finalID
      GROUP BY LEAST(a.finalID, b.finalID), GREATEST(a.finalID, b.finalID), a.pat;


SELECT * FROM riccaboni.edges_undir LIMIT 0,30;
/*
*/
