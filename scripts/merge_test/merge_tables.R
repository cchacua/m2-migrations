# Tables to export in latex


query.latex("SELECT COUNT(*), CHAR_LENGTH(a.pat), LEFT(a.pat,2) AS Authority
      FROM riccaboni.t01 a
      GROUP BY CHAR_LENGTH(a.pat),  LEFT(a.pat,2);", 0)
