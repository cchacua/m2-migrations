
-- Patents by year and authority 
SELECT COUNT(a.pat), a.yr, LEFT(a.pat,2)
    FROM riccaboni.t01 a
    GROUP BY a.yr, LEFT(a.pat,2);    