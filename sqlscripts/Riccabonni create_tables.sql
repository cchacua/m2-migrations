-- This script allows to generate the schema and all the tables for the Patent Disambiguation Data:
-- https://figshare.com/projects/Patent_Disambiguation_and_Geolocation/15080
-- ATTENTION: SOME TABLES DO NOT HAVE A PRIMARY KEY


-- This script was created by Christian Chacua Delgado
-- cchacua@gmail.com

-- Create Schema
CREATE SCHEMA `riccaboni` DEFAULT CHARACTER SET utf8 ;

--
use riccaboni;
--

DROP TABLE IF EXISTS t01;
CREATE TABLE IF NOT EXISTS t01
(
    pat VARCHAR(15) NOT NULL default '',
    invs VARCHAR(2000) default '',
    localInvs VARCHAR(2000) default '',
    apps VARCHAR(2000) default '',
    yr INT(4) NOT NULL default '9999',
    classes VARCHAR(300) default '',
    wasComplete CHAR(1) default '',
    PRIMARY KEY(pat)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;

-- 
DROP TABLE IF EXISTS t02;
CREATE TABLE IF NOT EXISTS t02
(
    ID int NOT NULL AUTO_INCREMENT,
    citing VARCHAR(15) NOT NULL default '',
    cited VARCHAR(15) NOT NULL default '',
    cite_origin CHARACTER(1) NOT NULL default '',
    data_source CHARACTER(1) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;



--
DROP TABLE IF EXISTS t06;
CREATE TABLE IF NOT EXISTS t06
(
    IPC_code VARCHAR(50) NOT NULL default '',
    Sector_en VARCHAR(200) NOT NULL default '',
    Field_en VARCHAR(500) NOT NULL default '',
    PRIMARY KEY(IPC_code)
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;

--
DROP TABLE IF EXISTS t07;
CREATE TABLE IF NOT EXISTS t07
(
    ID VARCHAR(15) NOT NULL default '',
    pat VARCHAR(15) NOT NULL default '',
    name VARCHAR(500) NOT NULL default '',
    loc VARCHAR(25) NOT NULL default '',
    qual INT,
    loctype VARCHAR(10) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;

-- t08
DROP TABLE IF EXISTS t08;
CREATE TABLE IF NOT EXISTS t08
(
    ID VARCHAR(15) NOT NULL default '',
    pat VARCHAR(15) NOT NULL default '',
    name VARCHAR(500) NOT NULL default '',
    loc VARCHAR(25) NOT NULL default '',
    qual INT,
    loctype VARCHAR(10) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;

--
DROP TABLE IF EXISTS t09;
CREATE TABLE IF NOT EXISTS t09
(
    localID VARCHAR(15) NOT NULL default '',
    mobileID VARCHAR(15) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;


--
DROP TABLE IF EXISTS t10;
CREATE TABLE IF NOT EXISTS t10
(
    Pub_number VARCHAR(15) NOT NULL default '',
    class VARCHAR(200) NOT NULL default '',
    class_type CHARACTER(1) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;


--
DROP TABLE IF EXISTS t11;
CREATE TABLE IF NOT EXISTS t11
(
    Pub_number VARCHAR(15) NOT NULL default '',
    Triadic_Family VARCHAR(15) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;


--
DROP TABLE IF EXISTS t12;
CREATE TABLE IF NOT EXISTS t12
(
    USPC VARCHAR(15) NOT NULL default '',
    IPC VARCHAR(500) NOT NULL default ''
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;

--
DROP TABLE IF EXISTS t13;
CREATE TABLE IF NOT EXISTS t13
(
    wipoClass VARCHAR(50),
    ID CHARACTER(2) NOT NULL default '',
    PRIMARY KEY(ID)
) ENGINE=MyISAM CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci ;



