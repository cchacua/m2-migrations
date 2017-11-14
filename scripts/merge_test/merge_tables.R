# Tables to export in latex


query.latex("SELECT COUNT(*) As 'Number of patents', CHAR_LENGTH(a.pat) AS 'Number of characters', LEFT(a.pat,2) AS 'Patent authority'
      FROM riccaboni.t01 a
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,2);", 
            0, 
            c("Table 1", "T1"), 
            "t1-sd")
