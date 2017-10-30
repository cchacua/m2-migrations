CREATE SCHEMA `oecd` DEFAULT CHARACTER SET utf8 ;

--
use oecd;
--

DROP TABLE IF EXISTS treg07;
CREATE TABLE IF NOT EXISTS treg07
(   PCT_Nbr CHAR(12) NOT NULL default '',
    PCT_App  VARCHAR(25) NOT NULL default '',
    Appln_id VARCHAR(15) NOT NULL default '',
    Inv_name VARCHAR(300),
    Address VARCHAR(500),  
    Reg_code VARCHAR(10),
    Ctry_code CHAR(2) default '', 
    Reg_share DOUBLE DEFAULT NULL,
    Inv_share DOUBLE DEFAULT NULL
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;