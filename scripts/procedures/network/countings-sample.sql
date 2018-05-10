

---------------------------------------------------------------------------------------------------
-- Counting number of inventors by ethnic group, of the patents that are in the network, using the full-US-based sample
---------------------------------------------------------------------------------------------------

SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;

/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                    171584 |
| European.German              |                     44536 |
| EastAsian.Chinese            |                     41307 |
| SouthAsian                   |                     33583 |
| European.French              |                     19709 |
| Hispanic.Spanish             |                     10052 |
| European.Italian.Italy       |                      7655 |
| Hispanic.Philippines         |                      4677 |
| EastAsian.South.Korea        |                      4510 |
| Hispanic.Portuguese          |                      4385 |
| Muslim.Persian               |                      3701 |
| European.Russian             |                      3627 |
| EastAsian.Indochina.Vietnam  |                      3573 |
| EastAsian.Japan              |                      2683 |
| EastAsian.Malay.Indonesia    |                      2352 |
| Muslim.Nubian                |                      1756 |
| European.EastEuropean        |                      1579 |
| Greek                        |                      1249 |
| Nordic.Scandinavian.Sweden   |                      1170 |
| Jewish                       |                      1110 |
| Nordic.Scandavian.Denmark    |                      1083 |
| Muslim.Turkic.Turkey         |                      1001 |
| European.Italian.Romania     |                       954 |
| European.SouthSlavs          |                       872 |
| Muslim.Pakistanis.Pakistan   |                       823 |
| African.EastAfrican          |                       629 |
| African.WestAfrican          |                       620 |
| Nordic.Scandinavian.Norway   |                       593 |
| Muslim.Pakistanis.Bangladesh |                       382 |
| Nordic.Finland               |                       304 |
| EastAsian.Indochina.Thailand |                       191 |
| EastAsian.Malay.Malaysia     |                       150 |
| African.SouthAfrican         |                       133 |
| Muslim.ArabianPeninsula      |                       128 |
| EastAsian.Indochina.Myanmar  |                       101 |
| European.Baltics             |                        77 |
| Muslim.Maghreb               |                        21 |
| EastAsian.Indochina.Cambodia |                        12 |
| Muslim.Turkic.CentralAsian   |                         7 |
+------------------------------+---------------------------+
39 rows in set (1 min 3,26 sec)
*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                426731 |
+-----------------------+
1 row in set (1 min 25,10 sec)
*/


-- Distribution of inventors by CEL group PBOC
SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;
/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                     71684 |
| EastAsian.Chinese            |                     20533 |
| European.German              |                     18453 |
| SouthAsian                   |                     11480 |
| European.French              |                      8281 |
| Hispanic.Spanish             |                      4874 |
| European.Italian.Italy       |                      3438 |
| EastAsian.South.Korea        |                      2389 |
| Hispanic.Philippines         |                      2117 |
| Hispanic.Portuguese          |                      2108 |
| European.Russian             |                      1561 |
| EastAsian.Indochina.Vietnam  |                      1430 |
| EastAsian.Japan              |                      1426 |
| Muslim.Persian               |                      1215 |
| EastAsian.Malay.Indonesia    |                      1055 |
| European.EastEuropean        |                       882 |
| Muslim.Nubian                |                       708 |
| Greek                        |                       567 |
| Nordic.Scandinavian.Sweden   |                       438 |
| Nordic.Scandavian.Denmark    |                       388 |
| European.Italian.Romania     |                       347 |
| European.SouthSlavs          |                       340 |
| African.EastAfrican          |                       317 |
| African.WestAfrican          |                       312 |
| Jewish                       |                       308 |
| Muslim.Turkic.Turkey         |                       298 |
| Muslim.Pakistanis.Pakistan   |                       278 |
| Nordic.Scandinavian.Norway   |                       240 |
| Muslim.Pakistanis.Bangladesh |                       140 |
| Nordic.Finland               |                       117 |
| EastAsian.Indochina.Thailand |                        94 |
| EastAsian.Malay.Malaysia     |                        72 |
| African.SouthAfrican         |                        59 |
| EastAsian.Indochina.Myanmar  |                        48 |
| Muslim.ArabianPeninsula      |                        46 |
| European.Baltics             |                        43 |
| Muslim.Maghreb               |                         8 |
| Muslim.Turkic.CentralAsian   |                         6 |
| EastAsian.Indochina.Cambodia |                         4 |
+------------------------------+---------------------------+
39 rows in set (48,45 sec)
*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_pboc_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                218281 |
+-----------------------+
1 row in set (1 min 5,45 sec)
*/


-- Distribution of inventors by CEL group CTT
SELECT a.nation, COUNT(DISTINCT a.finalID) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013' 
GROUP BY a.nation
ORDER BY COUNT(DISTINCT a.finalID) DESC;
/*
+------------------------------+---------------------------+
| nation                       | COUNT(DISTINCT a.finalID) |
+------------------------------+---------------------------+
| CelticEnglish                |                    103072 |
| European.German              |                     26945 |
| SouthAsian                   |                     22570 |
| EastAsian.Chinese            |                     21900 |
| European.French              |                     11814 |
| Hispanic.Spanish             |                      5343 |
| European.Italian.Italy       |                      4359 |
| Hispanic.Philippines         |                      2628 |
| Muslim.Persian               |                      2550 |
| Hispanic.Portuguese          |                      2348 |
| EastAsian.Indochina.Vietnam  |                      2203 |
| EastAsian.South.Korea        |                      2199 |
| European.Russian             |                      2169 |
| EastAsian.Malay.Indonesia    |                      1340 |
| EastAsian.Japan              |                      1302 |
| Muslim.Nubian                |                      1070 |
| Jewish                       |                       819 |
| Nordic.Scandinavian.Sweden   |                       751 |
| European.EastEuropean        |                       738 |
| Muslim.Turkic.Turkey         |                       718 |
| Greek                        |                       715 |
| Nordic.Scandavian.Denmark    |                       714 |
| European.Italian.Romania     |                       628 |
| Muslim.Pakistanis.Pakistan   |                       551 |
| European.SouthSlavs          |                       550 |
| Nordic.Scandinavian.Norway   |                       362 |
| African.EastAfrican          |                       320 |
| African.WestAfrican          |                       313 |
| Muslim.Pakistanis.Bangladesh |                       245 |
| Nordic.Finland               |                       193 |
| EastAsian.Indochina.Thailand |                        98 |
| Muslim.ArabianPeninsula      |                        82 |
| EastAsian.Malay.Malaysia     |                        82 |
| African.SouthAfrican         |                        75 |
| EastAsian.Indochina.Myanmar  |                        53 |
| European.Baltics             |                        34 |
| Muslim.Maghreb               |                        13 |
| EastAsian.Indochina.Cambodia |                         8 |
| Muslim.Turkic.CentralAsian   |                         1 |
+------------------------------+---------------------------+
39 rows in set (35,19 sec)
*/

SELECT COUNT(DISTINCT a.pat) 
FROM christian.t08_class_at1us_date_fam_for a 
INNER JOIN riccaboni.edges_undir_pat b
ON a.pat=b.pat
INNER JOIN riccaboni.t01_ctt_class d
      ON a.pat=d.pat
WHERE a.EARLIEST_FILING_YEAR>='1975' AND a.EARLIEST_FILING_YEAR<='2013';
/*
+-----------------------+
| COUNT(DISTINCT a.pat) |
+-----------------------+
|                210163 |
+-----------------------+
1 row in set (36,85 sec)
*/

