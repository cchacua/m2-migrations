CREATE SCHEMA `pct` DEFAULT CHARACTER SET utf8mb4 ;

--
use pct;
--


-----------------------------------------------------------------------------------------------
-- NAT
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS NAT;
CREATE TABLE IF NOT EXISTS NAT
(   
appln_id VARCHAR(9),
appln_nr VARCHAR(15),
RELATION_TYPE_ID CHAR(1),
NAME VARCHAR(220),
NATIONALITY_STATE_CODE CHAR(2),
STATE_OF_RESIDENCE_CODE CHAR(2)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;


-----------------------------------------------------------------------------------------------
-- REG
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS REG;
CREATE TABLE IF NOT EXISTS REG
( 
PCT_Nbr VARCHAR(15),
PCT_App VARCHAR(15),
Appln_id VARCHAR(9),
Inv_name VARCHAR(220),
Address VARCHAR(500),
Reg_code VARCHAR(15),
Ctry_code CHAR(2),
Reg_share INT,
Inv_share INT,
Reg_type INT,
LEGAL_ENTITY_ID  VARCHAR(15),
NATIONALITY_STATE_CODE VARCHAR(15)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;
