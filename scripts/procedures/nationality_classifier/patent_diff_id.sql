SELECT COUNT(DISTINCT a.pat, a.ID)       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;

SELECT COUNT(DISTINCT a.pat, a.ID, a.loc)       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;

SELECT COUNT(*)       
      FROM riccaboni.t08_names_allclasses_us_atleastone a;

SELECT a.pat, a.ID, COUNT(a.loc)        
      FROM riccaboni.t08_names_allclasses_us_atleastone a GROUP BY a.pat, a.ID HAVING COUNT(a.loc)>1 LIMIT 0,10;

SELECT *      
      FROM riccaboni.t08_names_allclasses_us_atleastone a where a.pat='EP0003262';

SELECT *      
      FROM oecd.treg03 a where a.Pub_nbr='EP0003262';
