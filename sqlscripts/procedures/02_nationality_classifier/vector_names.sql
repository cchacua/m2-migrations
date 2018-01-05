---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- TABLE WITH ALL NAMES
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
SHOW INDEX FROM riccaboni.t08;                                     


DROP TABLE IF EXISTS riccaboni.t08_allclasses;
CREATE TABLE riccaboni.t08_names_allclasses AS
SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat;
/*
Query OK, 7652380 rows affected (5 min 49,21 sec)
Records: 7652380  Duplicates: 0  Warnings: 0
*/
SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t08 a
      INNER JOIN riccaboni.t01_allclasses b
      ON a.pat=b.pat
      LIMIT 0,100;
      
SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t08 a
      INNER JOIN (SELECT DISTINCT c.pat FROM riccaboni.t01_allclasses c) b
      ON a.pat=b.pat
      LIMIT 0,100;

SELECT a.ID, a.pat, a.name, a.loc, a.qual, a.loctype
      FROM riccaboni.t01_allclasses b 
      INNER JOIN riccaboni.t08 a
      ON b.pat=a.pat
      LIMIT 0,100;

SELECT * FROM riccaboni.t08 a WHERE a.pat='EP1550317';

      
SELECT DISTINCT a.name, a.ID       
      FROM riccaboni.t08_allclasses a
      GROUP BY a.ID
      LIMIT 0,100;