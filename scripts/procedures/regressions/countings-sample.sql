-- ATTENTION: CHANGE TO 2012

---------------------------------------------------------------------------------------------------
-- Counting number of inventors by ethnic group, of the patents that are in the network, using the full-US-based sample
---------------------------------------------------------------------------------------------------

SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;

/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                    175112 |
| European.German              |                     44536 |
| EastAsian.Chinese            |                     41307 |
| SouthAsian                   |                     33580 |
| European.French              |                     19709 |
| Hispanic.Spanish             |                     10249 |
| European.Italian.Italy       |                      7655 |
| Hispanic.Philippines         |                      4784 |
| EastAsian.Indochina.Vietnam  |                      4703 |
| EastAsian.South.Korea        |                      4510 |
| Hispanic.Portuguese          |                      4489 |
| Muslim.Persian               |                      3701 |
| European.Russian             |                      3627 |
| EastAsian.Malay.Indonesia    |                      3322 |
| EastAsian.Japan              |                      2683 |
| Muslim.Nubian                |                      1792 |
| European.EastEuropean        |                      1579 |
| Greek                        |                      1269 |
| Nordic.Scandinavian.Sweden   |                      1195 |
| Jewish                       |                      1135 |
| Nordic.Scandavian.Denmark    |                      1096 |
| Muslim.Turkic.Turkey         |                      1025 |
| European.Italian.Romania     |                       970 |
| European.SouthSlavs          |                       888 |
| Muslim.Pakistanis.Pakistan   |                       839 |
| African.EastAfrican          |                       642 |
| African.WestAfrican          |                       628 |
| Nordic.Scandinavian.Norway   |                       605 |
| Muslim.Pakistanis.Bangladesh |                       387 |
| Nordic.Finland               |                       312 |
| EastAsian.Indochina.Thailand |                       193 |
| EastAsian.Malay.Malaysia     |                       154 |
| African.SouthAfrican         |                       137 |
| Muslim.ArabianPeninsula      |                       130 |
| EastAsian.Indochina.Myanmar  |                       105 |
| European.Baltics             |                        79 |
| Muslim.Maghreb               |                        21 |
| EastAsian.Indochina.Cambodia |                        12 |
| Muslim.Turkic.CentralAsian   |                         7 |
+------------------------------+---------------------------+
39 rows in set (1 min 4,09 sec)
*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                436566 |
+-----------------------+
1 row in set (1 min 28,40 sec)

*/


-- Distribution of inventors by CEL group PBOC
SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;
/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                     72787 |
| EastAsian.Chinese            |                     20533 |
| European.German              |                     18453 |
| SouthAsian                   |                     11479 |
| European.French              |                      8281 |
| Hispanic.Spanish             |                      4955 |
| European.Italian.Italy       |                      3438 |
| EastAsian.South.Korea        |                      2389 |
| Hispanic.Portuguese          |                      2155 |
| Hispanic.Philippines         |                      2155 |
| EastAsian.Indochina.Vietnam  |                      1772 |
| European.Russian             |                      1561 |
| EastAsian.Japan              |                      1426 |
| EastAsian.Malay.Indonesia    |                      1420 |
| Muslim.Persian               |                      1215 |
| European.EastEuropean        |                       882 |
| Muslim.Nubian                |                       718 |
| Greek                        |                       573 |
| Nordic.Scandinavian.Sweden   |                       446 |
| Nordic.Scandavian.Denmark    |                       395 |
| European.Italian.Romania     |                       352 |
| European.SouthSlavs          |                       348 |
| African.EastAfrican          |                       320 |
| African.WestAfrican          |                       315 |
| Jewish                       |                       313 |
| Muslim.Turkic.Turkey         |                       307 |
| Muslim.Pakistanis.Pakistan   |                       285 |
| Nordic.Scandinavian.Norway   |                       243 |
| Muslim.Pakistanis.Bangladesh |                       142 |
| Nordic.Finland               |                       119 |
| EastAsian.Indochina.Thailand |                        95 |
| EastAsian.Malay.Malaysia     |                        74 |
| African.SouthAfrican         |                        61 |
| EastAsian.Indochina.Myanmar  |                        48 |
| Muslim.ArabianPeninsula      |                        46 |
| European.Baltics             |                        44 |
| Muslim.Maghreb               |                         8 |
| Muslim.Turkic.CentralAsian   |                         6 |
| EastAsian.Indochina.Cambodia |                         4 |
+------------------------------+---------------------------+
39 rows in set (1 min 8,16 sec)

*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                222655 |
+-----------------------+
1 row in set (1 min 32,34 sec)

*/


-- Distribution of inventors by CEL group CTT
SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;
/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                    105561 |
| European.German              |                     26945 |
| SouthAsian                   |                     22568 |
| EastAsian.Chinese            |                     21900 |
| European.French              |                     11814 |
| Hispanic.Spanish             |                      5465 |
| European.Italian.Italy       |                      4359 |
| EastAsian.Indochina.Vietnam  |                      3015 |
| Hispanic.Philippines         |                      2700 |
| Muslim.Persian               |                      2550 |
| Hispanic.Portuguese          |                      2407 |
| EastAsian.South.Korea        |                      2199 |
| European.Russian             |                      2169 |
| EastAsian.Malay.Indonesia    |                      1962 |
| EastAsian.Japan              |                      1302 |
| Muslim.Nubian                |                      1096 |
| Jewish                       |                       839 |
| Nordic.Scandinavian.Sweden   |                       768 |
| European.EastEuropean        |                       738 |
| Muslim.Turkic.Turkey         |                       734 |
| Greek                        |                       729 |
| Nordic.Scandavian.Denmark    |                       720 |
| European.Italian.Romania     |                       639 |
| Muslim.Pakistanis.Pakistan   |                       561 |
| European.SouthSlavs          |                       558 |
| Nordic.Scandinavian.Norway   |                       373 |
| African.EastAfrican          |                       330 |
| African.WestAfrican          |                       318 |
| Muslim.Pakistanis.Bangladesh |                       248 |
| Nordic.Finland               |                       199 |
| EastAsian.Indochina.Thailand |                        99 |
| EastAsian.Malay.Malaysia     |                        84 |
| Muslim.ArabianPeninsula      |                        84 |
| African.SouthAfrican         |                        77 |
| EastAsian.Indochina.Myanmar  |                        57 |
| European.Baltics             |                        35 |
| Muslim.Maghreb               |                        13 |
| EastAsian.Indochina.Cambodia |                         8 |
| Muslim.Turkic.CentralAsian   |                         1 |
+------------------------------+---------------------------+
39 rows in set (59,79 sec)
*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2012';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                215656 |
+-----------------------+
1 row in set (50,71 sec)
*/

