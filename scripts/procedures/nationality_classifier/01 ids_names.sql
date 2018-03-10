---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- List of names and ids for the patents that have equal number of inventors in t01, t08 and patstat
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- t08
DROP TABLE IF EXISTS christian.inv_pat_allclasses_equalcounting_t08;
CREATE TABLE christian.inv_pat_allclasses_equalcounting_t08 AS
SELECT DISTINCT a.pat, a.ID, a.name
  FROM riccaboni.t08 a
  INNER JOIN christian.counting_invenbypatents_allclasses b
  ON a.pat=b.pat
  WHERE b.n01=b.npas AND b.n01=b.n08 AND b.npas=b.n08 AND a.pat NOT IN ('EP0643061', 'WO1997009333', 'WO2002026253','WO2011140681', 'WO2008154884', 'WO2010092450', 'WO2010128525');
/*
Query OK, 6697343 rows affected (3 min 45,41 sec)
Records: 6697343  Duplicates: 0  Warnings: 0
*/
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='EP1890392' AND ID='LX92961' AND name='Sung, Dan-Keun, c/o 103-1503, Hanwool Apt.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO1998006020' AND ID='HI1067148' AND name='Bartmann, Dieter Andreas';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO1998039462' AND ID='HX1265993' AND name='Harper, Stacy Maric'; 
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2001036676' AND ID='HX1272758' AND name='MAXWELL, Paula';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2001058964' AND ID='LX190722' AND name='SOGA Hisae(Heiress of Kazuo SOGA (deceased)';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2002099591' AND ID='HX46926' AND name='PARRELLA, Michael, J., Sr.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2002100117' AND ID='HX46926' AND name='PARRELLA, Michael, J., Sr.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2003057242' AND ID='HI272329' AND name='HENNING, Robert, Henk';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2003077940' AND ID='HI2584704' AND name LIKE '%S.,%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004064329' AND ID='HX33924' AND name LIKE '%Philips Intell. Pty%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004064329' AND ID='HX396188' AND name LIKE '%hilips Intell. Pty%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004069794' AND ID='HX165515' AND name='BAR-HAM, Shay' ;
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2007113836' AND ID='LX163423' AND name='SHARON, Carmel';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2006130170' AND ID='HI779631' AND name LIKE '%IBM United Kingdom%';

SHOW INDEX FROM christian.inv_pat_allclasses_equalcounting_t08;
ALTER TABLE christian.inv_pat_allclasses_equalcounting_t08 ADD INDEX(pat);

SELECT COUNT(*) FROM christian.inv_pat_allclasses_equalcounting_t08;
/*
+----------+
| COUNT(*) |
+----------+
|  6697272 |
+----------+
1 row in set (2,46 sec)
*/

SELECT COUNT(DISTINCT a.ID) FROM christian.inv_pat_allclasses_equalcounting_t08 a;
/*
+----------------------+
| COUNT(DISTINCT a.ID) |
+----------------------+
|              1665914 |
+----------------------+
1 row in set (21,14 sec)
*/

SELECT  * FROM riccaboni.t08 a WHERE a.pat='EP0012207';
SELECT  * FROM riccaboni.t08 a WHERE a.ID='HI1000251';
 
-- patstat
DROP TABLE IF EXISTS christian.inv_pat_allclasses_equalcounting_patstat;
CREATE TABLE christian.inv_pat_allclasses_equalcounting_patstat AS
SELECT DISTINCT a.pat, a.PERSON_ID, a.INVT_SEQ_NR, a.PERSON_CTRY_CODE, a.PERSON_NAME, a.HAN_NAME, a.PSN_NAME, a.DOC_STD_NAME
  FROM patstat2016b.TLS207_PERS_APPLN_allclasses_names_pat a
  INNER JOIN christian.counting_invenbypatents_allclasses b
  ON a.pat=b.pat
  WHERE b.n01=b.npas AND b.n01=b.n08 AND b.npas=b.n08 AND a.INVT_SEQ_NR>'0' AND a.pat NOT IN ('EP0643061', 'WO1997009333', 'WO2002026253','WO2011140681', 'WO2008154884', 'WO2010092450', 'WO2010128525');
/*
Query OK, 6697272 rows affected (5 min 43,24 sec)
Records: 6697272  Duplicates: 0  Warnings: 0
*/

SHOW INDEX FROM christian.inv_pat_allclasses_equalcounting_patstat;
ALTER TABLE christian.inv_pat_allclasses_equalcounting_patstat ADD INDEX(pat);


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
-- ANNEX: the old stuff 
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Although they are apparently distinct, when counting by ids they have equal numbers
SELECT COUNT(DISTINCT a.pat, a.ID) FROM christian.inv_pat_allclasses_equalcounting_t08 a;
/*
+-----------------------------+
| COUNT(DISTINCT a.pat, a.ID) |
+-----------------------------+
|                     6697321 |
+-----------------------------+
1 row in set (21,97 sec)
6697321-6697343=22 more names
*/

/*
SELECT a.pat, a.ID, COUNT(*) AS counting FROM christian.inv_pat_allclasses_equalcounting_t08 a GROUP BY a.pat, a.ID HAVING counting>1;
+--------------+-----------+----------+
| pat          | ID        | counting |
+--------------+-----------+----------+
| EP0643061    | LI1569    |        2 |
| EP1890392    | LX92961   |        2 |
| WO1997009333 | HX501916  |        2 |
| WO1998006020 | HI1067148 |        2 |
| WO1998039462 | HX1265993 |        2 |
| WO2001036676 | HX1272758 |        2 |
| WO2001058964 | LX190722  |        2 |
| WO2002026253 | UI4830715 |        2 |
| WO2002026253 | UI4830716 |        2 |
| WO2002099591 | HX46926   |        2 |
| WO2002100117 | HX46926   |        2 |
| WO2003057242 | HI272329  |        2 |
| WO2003077940 | HI2584704 |        2 |
| WO2004064329 | HX33924   |        2 |
| WO2004064329 | HX396188  |        2 |
| WO2004069794 | HX165515  |        2 |
| WO2006130170 | HI779631  |        2 |
| WO2007113836 | LX163423  |        2 |
| WO2008154884 | LI17078   |        2 |
| WO2010092450 | LX30595   |        2 |
| WO2010128525 | HX93309   |        2 |
| WO2011140681 | LX99972   |        2 |
+--------------+-----------+----------+
22 rows in set (1 min 14,41 sec)

*/

SELECT c.pat, c.ID, c.name
FROM (SELECT CONCAT(a.pat, a.ID) AS idn, COUNT(*) AS counting FROM christian.inv_pat_allclasses_equalcounting_t08 a GROUP BY a.pat, a.ID HAVING counting>1) b
INNER JOIN christian.inv_pat_allclasses_equalcounting_t08 c
ON b.idn=CONCAT(c.pat, c.ID);
/*
+--------------+-----------+--------------------------------------------------+
| pat          | ID        | name                                             |
+--------------+-----------+--------------------------------------------------+
Not the same
| EP0643061    | LI1569    | Kim, Mu Yong                                     |
| EP0643061    | LI1569    | Kim, Yong Zu                                     |

| WO1997009333 | HX501916  | KHOMUTOV, Alex R.                                |
| WO1997009333 | HX501916  | KHOMUTOV, Radii M.                               |

| WO2002026253 | UI4830715 | CHEN, Yinghua,	Dept. of Bio. Sciences & Biotech  |
| WO2002026253 | UI4830715 | CHEN, Yinghua,	Dept. of Bio. Sciences & Biotech. |
| WO2002026253 | UI4830716 | CHEN, Yinghua,	Dept. of Bio. Sciences & Biotech  |
| WO2002026253 | UI4830716 | CHEN, Yinghua,	Dept. of Bio. Sciences & Biotech. |

| WO2011140681 | LX99972   | TANG, Jie                                        |
| WO2011140681 | LX99972   | WANG, Jie                                        |

| WO2008154884 | LI17078   | WANG, Feng                                       |
| WO2008154884 | LI17078   | WANG, Geng                                       |

| WO2010092450 | LX30595   | MODI, Indravadan, Ambalal                        |
| WO2010092450 | LX30595   | MODI, Rajiv, Indravadan                          |

| WO2010128525 | HX93309   | Patel, Dinesh Shantilal                          |
| WO2010128525 | HX93309   | Patel, Sachin Dinesh      
                       |

------------------------------------------------------------------------------
('EP0643061', 'WO1997009333', 'WO2002026253','WO2011140681', 'WO2008154884', 'WO2010092450', 'WO2010128525')
------------------------------------------------------------------------------
The same                                     
| EP1890392    | LX92961   | Sung, Dan-Keun, c/o 103-1503, Hanwool Apt.       |X
| EP1890392    | LX92961   | Sung, Dan-Keun, c/o 107-1503, Hanwool Apt.       |

| WO1998006020 | HI1067148 | Bartmann, Dieter                                 |X
| WO1998006020 | HI1067148 | Bartmann, Dieter Andreas                         |

| WO1998039462 | HX1265993 | Harper, Stacy Maric                              |
| WO1998039462 | HX1265993 | HARPER, Stacy, Marie                             |X

| WO2001036676 | HX1272758 | MAXWELL, Paul                                    |X
| WO2001036676 | HX1272758 | MAXWELL, Paula                                   |

| WO2001058964 | LX190722  | SOGA Hisae(Heiress of Kazuo SOGA (deceased)      |
| WO2001058964 | LX190722  | SOGA, Kazuo                                      |X

| WO2002099591 | HX46926   | PARRELLA, Michael, J., Jr.                       |X
| WO2002099591 | HX46926   | PARRELLA, Michael, J., Sr.                       |

| WO2002100117 | HX46926   | PARRELLA, Michael, J., Jr.                       |X
| WO2002100117 | HX46926   | PARRELLA, Michael, J., Sr.                       |

| WO2003057242 | HI272329  | HENNING, Robert Henk                             |X
| WO2003057242 | HI272329  | HENNING, Robert, Henk                            |

| WO2003077940 | HI2584704 | TORRADO DURAN, J. J.,	Univ.Complutense de Madrid |X
| WO2003077940 | HI2584704 | TORRADO DURAN, S.,	Univ. Complutense de Madrid   |

| WO2004064329 | HX33924   | BUDDE, Wolfgang O.,	Philips Intell. Pty          |
| WO2004064329 | HX33924   | BUDDE, Wolfgang Otto                             |X

| WO2004064329 | HX396188  | HELBIG, Tobias                                   |X
| WO2004064329 | HX396188  | HELBIG, Tobias,	Philips Intell. Pty              |

| WO2004069794 | HX165515  | BAR-HAIM, Shay                                   |X
| WO2004069794 | HX165515  | BAR-HAM, Shay                                    |

| WO2006130170 | HI779631  | RAJAMANI, Nithya	c/o IBM United Kingdom Limited  |
| WO2006130170 | HI779631  | RAJAMANI, Nithya                                 |X

| WO2007113836 | LX163423  | CARMEL, Sharon                                   |X
| WO2007113836 | LX163423  | SHARON, Carmel                                   |


+--------------+-----------+--------------------------------------------------+
44 rows in set (1 min 31,20 sec)


 
*/

SELECT CONCAT('DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat="', c.pat,'" AND ID="', c.ID, ';" AND name="',c.name,'"') AS stringtodelete
FROM (SELECT CONCAT(a.pat, a.ID) AS idn, COUNT(*) AS counting FROM christian.inv_pat_allclasses_equalcounting_t08 a GROUP BY a.pat, a.ID HAVING counting>1) b
INNER JOIN christian.inv_pat_allclasses_equalcounting_t08 c
ON b.idn=CONCAT(c.pat, c.ID)
WHERE c.pat NOT IN ('EP0643061', 'WO1997009333', 'WO2002026253','WO2011140681', 'WO2008154884', 'WO2010092450', 'WO2010128525');
/*
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| stringtodelete                                                                                                                                                           |
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
No
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2007113836' AND a.ID='LX163423' AND a.name='CARMEL, Sharon'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2006130170' AND a.ID='HI779631' AND a.name='RAJAMANI, Nithya' 
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2004069794' AND a.ID='HX165515' AND a.name='BAR-HAIM, Shay'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2004064329' AND a.ID='HX396188' AND a.name='HELBIG, Tobias' 
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2004064329' AND a.ID='HX33924' AND a.name='BUDDE, Wolfgang Otto' 
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2003077940' AND a.ID='HI2584704' AND a.name='TORRADO DURAN, J. J.,Univ.Complutense de Madrid'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2003057242' AND a.ID='HI272329' AND a.name='HENNING, Robert Henk'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2001036676' AND a.ID='HX1272758' AND a.name='MAXWELL, Paul'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2001058964' AND a.ID='LX190722' AND a.name='SOGA, Kazuo' 
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2002099591' AND a.ID='HX46926' AND a.name='PARRELLA, Michael, J., Jr.'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO2002100117' AND a.ID='HX46926' AND a.name='PARRELLA, Michael, J., Jr.'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='EP1890392' AND a.ID='LX92961' AND a.name='Sung, Dan-Keun, c/o 107-1503, Hanwool Apt.'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO1998006020' AND a.ID='HI1067148' AND a.name='Bartmann, Dieter'
| DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE a.pat='WO1998039462' AND a.ID='HX1265993' AND a.name='HARPER, Stacy, Marie'
*/

YES
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='EP1890392' AND ID='LX92961' AND name='Sung, Dan-Keun, c/o 103-1503, Hanwool Apt.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO1998006020' AND ID='HI1067148' AND name='Bartmann, Dieter Andreas';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO1998039462' AND ID='HX1265993' AND name='Harper, Stacy Maric'; 
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2001036676' AND ID='HX1272758' AND name='MAXWELL, Paula';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2001058964' AND ID='LX190722' AND name='SOGA Hisae(Heiress of Kazuo SOGA (deceased)';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2002099591' AND ID='HX46926' AND name='PARRELLA, Michael, J., Sr.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2002100117' AND ID='HX46926' AND name='PARRELLA, Michael, J., Sr.';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2003057242' AND ID='HI272329' AND name='HENNING, Robert, Henk';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2003077940' AND ID='HI2584704' AND name LIKE '%S.,%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004064329' AND ID='HX33924' AND name LIKE '%Philips Intell. Pty%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004064329' AND ID='HX396188' AND name LIKE '%hilips Intell. Pty%';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2004069794' AND ID='HX165515' AND name='BAR-HAM, Shay' ;
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2007113836' AND ID='LX163423' AND name='SHARON, Carmel';
DELETE FROM christian.inv_pat_allclasses_equalcounting_t08 WHERE pat='WO2006130170' AND ID='HI779631' AND name LIKE '%IBM United Kingdom%';

/*+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
28 rows in set (1 min 33,97 sec)


So, to delete:
DELETE FROM orders where id_users = 1 and id_product = 2

*/

