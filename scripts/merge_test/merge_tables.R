# Tables to export in latex


query.latex("SELECT COUNT(*) As 'Number of patents', CHAR_LENGTH(a.pat) AS 'Number of characters', LEFT(a.pat,2) AS 'Patent authority'
      FROM riccaboni.t01 a
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,2);", 
            0, 
            c("Table 1", "T1"), 
            "t1-sd")

query.latex("SELECT COUNT(*) As 'Number of patents', LEFT(a.pat,2) AS 'Patent authority'
      FROM riccaboni.t01 a
      GROUP BY LEFT(a.pat,2);", 
            0, 
            c("Number of patents by publication authority in Morrison2017 database", "Number of patents in Morrison2017 database"), 
            "table-ric-number-pat-by-aut")

query.latex("SELECT COUNT(*), LEFT(a.pat,2) AS Authority
      FROM riccaboni.t01 a
      WHERE a.yr>1977 AND a.yr<2010
      GROUP BY LEFT(a.pat,2);", 
            0, 
            c("Number of patents by publication authority in Morrison2017 database from 1978", "Number of patents in Morrison2017 database"), 
            "table-ric-number-pat-by-aut-1978")