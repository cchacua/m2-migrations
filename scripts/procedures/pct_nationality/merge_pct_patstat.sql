-- Number of inventors: 5.472.804
SELECT COUNT(a.appln_id)
    FROM pct.NAT a;

-- Number of distinct patents: 2078988 
SELECT COUNT(DISTINCT a.appln_id)
    FROM pct.NAT a;

----------------------------------------------------------------------------------------------
-- Merge NAT TLS201_APPLN
----------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT c.APPLN_ID)
    FROM pct.NAT a
    INNER JOIN patstat2016b.TLS201_APPLN c
    ON  a.appln_id=c.APPLN_ID;

/*
+----------------------------+
| COUNT(DISTINCT c.APPLN_ID) |
+----------------------------+
|                    2078972 |
+----------------------------+
1 row in set (9,80 sec)

*/    

SELECT DISTINCT a.appln_id
    FROM pct.NAT a
    LEFT JOIN patstat2016b.TLS201_APPLN c
    ON  a.appln_id=c.APPLN_ID
    WHERE c.APPLN_ID IS NULL;
/*
+-----------+
| appln_id  |
+-----------+
| 909014158 |
| 909013706 |
| 909014033 |
| 909011116 |
| 909011115 |
| 909013155 |
| 909010180 |
| 909013636 |
| 909013635 |
| 909000069 |
| 909008912 |
| 909008911 |
| 909012072 |
| 54580143  |
| 909008917 |
| 909000543 |
+-----------+
16 rows in set (13,06 sec)
*/    

SELECT a.APPLN_ID
    FROM patstat2016b.TLS201_APPLN a
    WHERE a.APPLN_ID LIKE '9090141%';    

SELECT a.APPLN_ID, a.NB_INVENTORS, a.APPLN_NR
    FROM patstat2016b.TLS201_APPLN a
    WHERE a.APPLN_ID='468373';      

SELECT a.APPLN_ID, a.NB_INVENTORS, a.APPLN_NR
    FROM patstat2016b.TLS201_APPLN a
    WHERE a.APPLN_NR='2005009967';

SELECT a.appln_id, a.appln_nr, a.RELATION_TYPE_ID, a.NAME, a.NATIONALITY_STATE_CODE, a.STATE_OF_RESIDENCE_CODE
    FROM pct.NAT a
    LEFT JOIN patstat2016b.TLS201_APPLN c
    ON  a.appln_id=c.APPLN_ID
    WHERE c.APPLN_ID IS NULL;
/*
+-----------+-----------------+------------------+--------------------------------+------------------------+-------------------------+
| appln_id  | appln_nr        | RELATION_TYPE_ID | NAME                           | NATIONALITY_STATE_CODE | STATE_OF_RESIDENCE_CODE |
+-----------+-----------------+------------------+--------------------------------+------------------------+-------------------------+
| 909014158 |         0100098 | 6                | BAUDIER, Philippe              | FR                     | BE                      |
| 909014158 |         0100098 | 6                | SERENO, Antonio                | BE                     | BE                      |
| 909014158 |         0100098 | 6                | VANDERBIST, Francis            | BE                     | BE                      |
| 909013706 |         9908315 | 6                | RUELLE, Jean-Louis             | BE                     | BE                      |
| 909014033 |         0005441 | 6                | SPEER, Ulrich                  | DE                     | DE                      |
| 909014033 |         0005441 | 6                | LIEDTKE, BjOrn                 | DE                     | DE                      |
| 909014033 |         0005441 | 6                | GORDT, Joachim                 | DE                     | DE                      |
| 909014033 |         0005441 | 6                | WISE, James                    | DE                     | DE                      |
| 909014033 |         0005441 | 6                | ESSER, Hans-Gerd               | DE                     | DE                      |
| 909011116 |         0309956 | 6                | VORBACH, Martin                | DE                     | DE                      |
| 909011115 |      2005001211 | 6                | VORBACH, Martin                | DE                     | DE                      |
| 909013155 |      2005005726 | 6                | DAFLER, Peter                  | DE                     | DE                      |
| 909013155 |      2005005726 | 6                | EITEL, Gunter                  | DE                     | DE                      |
| 909013155 |      2005005726 | 6                | SCHULZ, Thorsten               | DE                     | DE                      |
| 909010180 |      2005009967 | 6                | SCHNELL, Christian             | FR                     | FR                      |
| 909010180 |      2005009967 | 6                | LITTLEWOOD-EVANS, Amanda, Jane | GB                     | CH                      |
| 909010180 |      2005009967 | 6                | KAPA, Prasad, Koteswara        | US                     | US                      |
| 909010180 |      2005009967 | 6                | BAJWA, Joginder, Singh         | US                     | US                      |
| 909010180 |      2005009967 | 6                | JIANG, Xinglong                | US                     | US                      |
| 909010180 |      2005009967 | 6                | BOLD, Guido                    | CH                     | CH                      |
| 909010180 |      2005009967 | 6                | CAPRARO, Hans-Georg            | CH                     | CH                      |
| 909010180 |      2005009967 | 6                | CARAVATTI, Giorgio             | CH                     | CH                      |
| 909010180 |      2005009967 | 6                | FLOERSHEIMER, Andreas          | DE                     | CH                      |
| 909010180 |      2005009967 | 6                | FURET, Pascal                  | FR                     | FR                      |
| 909010180 |      2005009967 | 6                | MANLEY, Paul, W.               | GB                     | CH                      |
| 909010180 |      2005009967 | 6                | VAUPEL, Andrea                 | DE                     | CH                      |
| 909010180 |      2005009967 | 6                | PISSOT SOLDERMANN, Carole      | FR                     | FR                      |
| 909010180 |      2005009967 | 6                | GESSIER, FranCois              | FR                     | FR                      |
| 909013636 |      2007064362 | 6                | DE MEUTTER, Stefaan            | BE                     | BE                      |
| 909013635 |      2007064363 | 6                | DE MEUTTER, Stefaan            | BE                     | BE                      |
| 909000069 |      2011000021 | 6                | DERMITZAKIS, Emmanuil          | GR                     | GR                      |
| 909000069 |      2011000021 | 6                | DERMITZAKIS, Aristeidis        | GR                     | GR                      |
| 909008912 |         0112047 | 6                | HRUSCHKA, Steffen, M.          | DE                     | DE                      |
| 909008912 |         0112047 | 6                | KIRCHNER, Stefan               | DE                     | DE                      |
| 909008912 |         0112047 | 6                | RASSENHOVEL, Jurgen            | DE                     | DE                      |
| 909008912 |         0112047 | 6                | WITT, Willi                    | DE                     | DE                      |
| 909008911 |         0112049 | 6                | HRUSCHKA, Steffen, M.          | DE                     | DE                      |
| 909008911 |         0112049 | 6                | KIRCHNER, Stefan               | DE                     | DE                      |
| 909008911 |         0112049 | 6                | RASSENHOVEL, JUrgen            | DE                     | DE                      |
| 909008911 |         0112049 | 6                | WITT, Willi                    | DE                     | DE                      |
| 909008911 |         0112049 | 6                | BEST, Bernd                    | DE                     | DE                      |
| 909012072 |      2004010055 | 6                | HAZELTON, Andrew, J.           | US                     | US                      |
| 909012072 |      2004010055 | 6                | SOGARD, Michael                | US                     | US                      |
| 54580143  |      2006000182 | 4                | SAINT VINCENT, Stephen         |                        |                         |
| 54580143  |      2006000182 | 4                | KATZ, Robert                   |                        |                         |
| 909008917 |      2008000621 | 6                | ZEPPI, Augusto                 | IT                     | IT                      |
| 909008917 |      2008000621 | 6                | ZAMBONI, Paolo                 | IT                     | IT                      |
| 909000543 |      2009052520 | 6                | FIGGE, Rainer                  | DE                     | FR                      |
| 909000543 |      2009052520 | 6                | VASSEUR, Perrine               | FR                     | FR                      |
+-----------+-----------------+------------------+--------------------------------+------------------------+-------------------------+
49 rows in set (12,74 sec)

*/

----------------------------------------------------------------------------------------------
-- Merge NAT TLS211_PAT_PUBLN
----------------------------------------------------------------------------------------------

SELECT COUNT(DISTINCT c.APPLN_ID)
    FROM pct.NAT a
    INNER JOIN (SELECT DISTINCT b.APPLN_ID 
                        FROM patstat2016b.TLS211_PAT_PUBLN b  
                        WHERE b.PUBLN_AUTH='WO' ) c
    ON  a.appln_id=c.APPLN_ID
   ;

/*
+----------------------------+
| COUNT(DISTINCT c.APPLN_ID) |
+----------------------------+
|                    2074651 |
+----------------------------+
1 row in set (1 min 23,11 sec)

*/



SELECT a.APPLN_ID
    FROM patstat2016b.TLS211_PAT_PUBLN a
    WHERE a.APPLN_ID LIKE '%54580143%';    
    
  
    
SELECT COUNT(DISTINCT d.APPLN_ID)
    FROM patstat2016b.TLS211_PAT_PUBLN d  
    INNER JOIN (SELECT DISTINCT a.appln_id
                  FROM pct.NAT a
                  LEFT JOIN patstat2016b.TLS201_APPLN c
                  ON  a.appln_id=c.APPLN_ID
                  WHERE c.APPLN_ID IS NULL) b
    ON  d.APPLN_ID=b.appln_id
    WHERE d.PUBLN_AUTH='WO';    

--
SELECT COUNT(DISTINCT d.APPLN_ID)
    FROM patstat2016b.TLS211_PAT_PUBLN d  
    WHERE d.PUBLN_AUTH='WO';   
/*    
+----------------------------+
| COUNT(DISTINCT d.APPLN_ID) |
+----------------------------+
|                    2893633 |
+----------------------------+
1 row in set (35,65 sec)
There are 2.893.633 WO patents in patstat2016b
*/  

SELECT COUNT(DISTINCT d.APPLN_ID)
    FROM patstat2016b.TLS211_PAT_PUBLN d  
    WHERE d.PUBLN_AUTH='WO' AND LEFT(d.PUBLN_DATE,4)<='2013';
/*
+----------------------------+
| COUNT(DISTINCT d.APPLN_ID) |
+----------------------------+
|                    2360336 |
+----------------------------+
1 row in set (32,26 sec)

*/    
    
----------------------------------------------------------------------------------------------
-- Merge REG TLS201_APPLN, so there are less patents
----------------------------------------------------------------------------------------------
-- Number of rows REG 5391520
  
-- Number of distinct patents: 2.018.294
SELECT COUNT(DISTINCT a.Appln_id)
    FROM pct.REG a;
    
    
----------------------------------------------------------------------------------------------
-- Merge REG with REGPAT
----------------------------------------------------------------------------------------------
--    

SELECT COUNT(DISTINCT c.Appln_id)
    FROM pct.NAT a
    INNER JOIN (SELECT DISTINCT b.Appln_id FROM oecd.treg07 b) c
    ON  a.appln_id=c.Appln_id;

/*
+----------------------------+
| COUNT(DISTINCT c.Appln_id) |
+----------------------------+
|                    2032451 |
+----------------------------+
1 row in set (1 min 22,60 sec)
*/  