CREATE SCHEMA `oecd_citations` DEFAULT CHARACTER SET utf8 ;

--
use oecd_citations;
--

-----------------------------------------------------------------------------------------------
-- US_CITATIONS
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS US_CITATIONS;
CREATE TABLE IF NOT EXISTS US_CITATIONS
(   
Citing_pub_nbr VARCHAR(15),
Citing_pub_date CHAR(8),
Citing_app_nbr VARCHAR(20),
Citing_appln_id int(10) unsigned, 
Cited_pub_nbr VARCHAR(20),
Cited_pub_date CHAR(8),
Cited_App_auth CHAR(2),
Cited_App_nbr VARCHAR(20),
Cited_Appln_id int(10) unsigned, 
Cit_Total int(10) unsigned, 
Citn_origin CHAR(3),
Citn_category VARCHAR(3),
Citn_lag_year VARCHAR(3), 
Citn_lag_month VARCHAR(4)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;

-----------------------------------------------------------------------------------------------
-- US_CIT_COUNTS
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS US_CIT_COUNTS;
CREATE TABLE IF NOT EXISTS US_CIT_COUNTS
(
US_Pub_nbr VARCHAR(15),
US_Pub_date CHAR(8),
US_Appln_id int(10) unsigned,
US_Grant CHAR(8),
US_Pat_Cits int(10) unsigned,
US_NPL_Cits int(10) unsigned,
Total_Cits int(10) unsigned,
Direct_cits_Recd int(10) unsigned,
Recd_asEQV int(10) unsigned,
Total_cits_Recd int(10) unsigned,
Direct_cits_Recd_in3 int(10) unsigned,
Recd_in3_asEQV int(10) unsigned,
Total_cits_Recd_in3 int(10) unsigned
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;


-----------------------------------------------------------------------------------------------
-- WO_CITATIONS
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS WO_CITATIONS;
CREATE TABLE IF NOT EXISTS WO_CITATIONS
(
Citing_pub_nbr VARCHAR(15),
Citing_pub_date CHAR(8),
Citing_app_nbr VARCHAR(20),
Citing_appln_id VARCHAR(15),
Cited_pub_nbr VARCHAR(20),
Cited_pub_date CHAR(8),
Cited_App_auth CHAR(2),
Cited_App_nbr VARCHAR(20),
Cited_Appln_id VARCHAR(15),
Cit_Total int(10) unsigned, 
Citn_origin CHAR(3),
Citn_category VARCHAR(5),
Citn_lag_year VARCHAR(3), 
Citn_lag_month VARCHAR(4),
ISA CHAR(2)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;

