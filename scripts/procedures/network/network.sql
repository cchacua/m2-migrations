---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE OF EDGES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

--- ATTENTION: I HAVE TO TAKE INTO ACCOUNT THE MOBILITY LINK ID, AS HERE I AM USING THE SIMPLE ID

DROP TABLE IF EXISTS riccaboni.t_id_fam;
CREATE TABLE riccaboni.t_id_fam AS
SELECT DISTINCT a.ID AS ID, a.DOCDB_FAMILY_ID
      FROM riccaboni.t08_names_allclasses_us_mob a;
/*
Query OK, 2177813 rows affected (42,52 sec)
Records: 2177813  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM riccaboni.t_id_fam;                                     
ALTER TABLE riccaboni.t_id_fam ADD INDEX(ID);
--ALTER TABLE riccaboni.t_id_fam ADD INDEX(DOCDB_FAMILY_ID);

SELECT * FROM riccaboni.t_id_fam LIMIT 0,30;

---------------------------------------------------------------------------------------------------
-- DIRECTED EDGE LIST
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS riccaboni.edges_dir;
CREATE TABLE riccaboni.edges_dir AS
SELECT DISTINCT a.ID, b.ID AS ID_, a.DOCDB_FAMILY_ID
      FROM riccaboni.t_id_fam a
      INNER JOIN riccaboni.t_id_fam b
      ON a.DOCDB_FAMILY_ID=b.DOCDB_FAMILY_ID
      WHERE a.ID!=b.ID;
/*
WHERE a.ID!=b.ID IS TO AVOID LINKS TO THEMSELVES
*/

---------------------------------------------------------------------------------------------------
-- UNDIRECTED EDGE LIST
-- See: https://stackoverflow.com/questions/21800873/select-distinct-pair-values-mysql
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS riccaboni.edges_undir;
CREATE TABLE riccaboni.edges_undir AS
SELECT DISTINCT LEAST(a.ID, b.ID) AS ID_, GREATEST(a.ID, b.ID) AS ID__, a.DOCDB_FAMILY_ID
      FROM riccaboni.t_id_fam a
      INNER JOIN riccaboni.t_id_fam b
      ON a.DOCDB_FAMILY_ID=b.DOCDB_FAMILY_ID
      WHERE a.ID!=b.ID
      GROUP BY LEAST(a.ID, b.ID), GREATEST(a.ID, b.ID), a.DOCDB_FAMILY_ID;


SELECT * FROM riccaboni.edges_undir LIMIT 0,30;
