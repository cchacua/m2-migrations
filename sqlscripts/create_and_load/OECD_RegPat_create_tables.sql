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

DROP TABLE IF EXISTS treg03;
CREATE TABLE IF NOT EXISTS treg03
(   App_nbr VARCHAR(20) NOT NULL default '',
    Appln_id VARCHAR(15) NOT NULL default '',
    Pub_nbr CHAR(9),
    Person_id VARCHAR(20),
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

-- HERE THERE ARE TRUNCATED DATA, BUT WE ARE ONLY INTERESTED IN THE FIRST TWO COLUMNS
DROP TABLE IF EXISTS tqual03;
CREATE TABLE IF NOT EXISTS tqual03
(   appln_id VARCHAR(15) NOT NULL default '',
    Pub_nbr VARCHAR(20),
    filing CHAR(4),
    tech_field VARCHAR(3),
    many_field CHAR(1),
    patent_scope VARCHAR(3),
    family_size VARCHAR(3),
    grant_lag INT,
    bwd_cits INT,
    npl_cits INT,
    claims INT,
    claims_bwd DOUBLE DEFAULT NULL,
    fwd_cits5 VARCHAR(3),
    fwd_cits7 VARCHAR(3),
    breakthrough CHAR(1),
    generality DOUBLE DEFAULT NULL,
    originality DOUBLE DEFAULT NULL,
    radicalness DOUBLE DEFAULT NULL,
    renewal VARCHAR(3),
    quality_index_4 DOUBLE DEFAULT NULL,
    quality_index_6 DOUBLE DEFAULT NULL
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;