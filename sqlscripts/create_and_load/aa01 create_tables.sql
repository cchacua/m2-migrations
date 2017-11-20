-- This script uses a MySQL database named patstat
-- by defining a new set of tables and indexes.  
-- If you want to keep older patstat extract versions, 
-- you should rename them. 

-- code by Gianluca Tarasconi under CC3.0 license Attribution-NonCommercial-ShareAlike Unported 
-- http://rawpatentdata.blogspot.com for more info

-- 2016a version

use patstat2016b;

DROP TABLE IF EXISTS TLS201_APPLN;

-- *******************************


CREATE TABLE TLS201_APPLN (
APPLN_ID int(10) unsigned NOT NULL,
APPLN_AUTH char(2) NOT NULL default '',
APPLN_NR varchar(20) NOT NULL default '',
APPLN_KIND char(2) default '',
APPLN_FILING_DATE date default NULL,
APPLN_FILING_YEAR int(4) default NULL,
APPLN_NR_EPODOC varchar(15) NOT NULL default '',
appln_nr_original varchar(100) NOT NULL default '',
IPR_TYPE char(2) default '',
INTERNAT_APPLN_ID int(11) default NULL,
int_phase char(1) NOT NULL DEFAULT 'N',
reg_phase char(1) NOT NULL DEFAULT 'N',
nat_phase char(1) NOT NULL DEFAULT 'N',
EARLIEST_FILING_DATE date NOT NULL DEFAULT '9999-12-31',
EARLIEST_FILING_YEAR int(4) NOT NULL DEFAULT '9999',
EARLIEST_FILING_ID	int(11) NOT NULL DEFAULT '0',
EARLIEST_PUBLN_DATE	date NOT NULL DEFAULT '9999-12-31',
EARLIEST_PUBLN_YEAR int(4) NOT NULL DEFAULT '9999',
EARLIEST_PAT_PUBLN_ID	int(11) NOT NULL DEFAULT '0',
GRANTED int(4) NOT NULL default '0',
DOCDB_FAMILY_ID int(11) NOT NULL DEFAULT '0',
INPADOC_FAMILY_ID int(11) NOT NULL DEFAULT '0',
DOCDB_FAMILY_SIZE int(4) NOT NULL default '0',
NB_CITING_DOCDB_FAM int(4) NOT NULL default '0',
NB_APPLICANTS int(4) NOT NULL default '0',
NB_INVENTORS int(4) NOT NULL default '0',
PRIMARY KEY  (APPLN_ID)
) ENGINE=MyISAM 
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS202_APPLN_TITLE;
--
CREATE TABLE TLS202_APPLN_TITLE (
  APPLN_ID int(10) unsigned NOT NULL,
  APPLN_TITLE_LG VARCHAR(2) not null default '',
  APPLN_TITLE       VARCHAR(3000)		NOT NULL,
 PRIMARY KEY (APPLN_ID)
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS203_APPLN_ABSTR;
--
CREATE TABLE TLS203_APPLN_ABSTR(
  APPLN_ID int(10) unsigned NOT NULL,
  APPLN_ABSTRACT_LG VARCHAR(2) not null default '',
  APPLN_ABSTRACT   VARCHAR(10000)		NOT NULL
)
MAX_ROWS = 60000000
AVG_ROW_LENGTH=900
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS204_APPLN_PRIOR;
--
CREATE TABLE TLS204_APPLN_PRIOR (
  APPLN_ID int(10) unsigned NOT NULL,
  PRIOR_APPLN_ID int(10) unsigned NOT NULL,
  PRIOR_APPLN_SEQ_NR smallint(4) unsigned default NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS205_TECH_REL;
--
CREATE TABLE TLS205_TECH_REL (
  APPLN_ID  int(10) unsigned NOT NULL,
  TECH_REL_APPLN_ID int(10) unsigned NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--	
DROP TABLE IF EXISTS TLS206_PERSON;
-- NOTE I DO NOT USE TLS906 I PUT TLS 206 with 906 data

CREATE TABLE TLS206_PERSON (
  PERSON_ID int(10) unsigned NOT NULL,
  PERSON_NAME          VARCHAR(300),
  PERSON_ADDRESS       VARCHAR(500),
  PERSON_CTRY_CODE     CHAR(2) NOT NULL,
  DOC_STD_NAME_ID  int(10) unsigned NOT NULL,
  DOC_STD_NAME     VARCHAR(500),
  psn_id        int(10) unsigned NOT NULL,
  psn_name           VARCHAR(500),
  psn_level        int(3) unsigned NOT NULL,
  psn_sector           VARCHAR(50),
  HAN_ID           int(10) unsigned NOT NULL,
  HAN_NAME         VARCHAR(500),
  HAN_HARMONIZED   int(3) unsigned NOT NULL) 
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS207_PERS_APPLN;
--
CREATE TABLE TLS207_PERS_APPLN (
  PERSON_ID int(10) unsigned NOT NULL,
  APPLN_ID  int(10) unsigned NOT NULL,
  APPLT_SEQ_NR smallint(4) unsigned default NULL,
  INVT_SEQ_NR smallint(4) unsigned default NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS208_DOC_STD_NMS;
--
-- TLS208 removed since 2015a version
--
-- CREATE TABLE TLS208_DOC_STD_NMS (
--  DOC_STD_NAME_ID int(10) unsigned NOT NULL,
--  DOC_STD_NAME         VARCHAR(100) NOT NULL
-- )
-- ENGINE = MyISAM
-- CHARACTER SET utf8 COLLATE utf8_general_ci;
--
DROP TABLE IF EXISTS TLS209_APPLN_IPC;
--

 CREATE TABLE TLS209_APPLN_IPC (
  APPLN_ID  int(10) unsigned NOT NULL,
  IPC_CLASS_SYMBOL   VARCHAR(16) NOT NULL,
  IPC_CLASS_LEVEL    CHAR(1),
  IPC_VERSION        DATE,
  IPC_VALUE          CHAR(1),
  IPC_POSITION       CHAR(1),
  IPC_GENER_AUTH     CHAR(2)
 )
 ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS210_APPLN_N_CLS;
--
CREATE TABLE TLS210_APPLN_N_CLS (
  APPLN_ID  int(10) unsigned NOT NULL,
  NAT_CLASS_SYMBOL   VARCHAR(16) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS211_PAT_PUBLN;
--
CREATE TABLE TLS211_PAT_PUBLN (
  PAT_PUBLN_ID int(10) unsigned NOT NULL,
  PUBLN_AUTH             CHAR(2) NOT NULL,
  PUBLN_NR               VARCHAR(15) NOT NULL,
  publn_nr_original varchar(100) NOT NULL DEFAULT '',
  PUBLN_KIND             CHAR(2),
  APPLN_ID int(10) unsigned NOT NULL,
  PUBLN_DATE             DATE,
  PUBLN_LG               CHAR(2),
  PUBLN_FIRST_GRANT      SMALLINT(4),
  PUBLN_CLAIMS       VARCHAR(4) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS212_CITATION;
--
CREATE TABLE TLS212_CITATION (
  PAT_PUBLN_ID int(10) unsigned NOT NULL,
  CITN_ID  smallint(4) unsigned NOT NULL,
  CITN_ORIGIN VARCHAR(5),
  CITED_PAT_PUBLN_ID int(10) unsigned default NULL,
  CITED_APPLN_ID int(10) unsigned NOT NULL,
  PAT_CITN_SEQ_NR  smallint(4) unsigned default NULL,
  CITED_NPL_PUBLN_ID  int(10) unsigned NOT NULL,
  NPL_CITN_SEQ_NR smallint(4) unsigned default NULL,
  CITN_GENER_AUTH  CHAR(2) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS214_NPL_PUBLN;
--
CREATE TABLE TLS214_NPL_PUBLN (
  NPL_PUBLN_ID int(10) unsigned NOT NULL,
  npl_type char(1) NOT NULL DEFAULT '',
  NPL_BIBLIO          VARCHAR(3000)
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS215_CITN_CATEG;
--
CREATE TABLE TLS215_CITN_CATEG (
  PAT_PUBLN_ID  int(10) unsigned NOT NULL,
  CITN_ID smallint(4) unsigned NOT NULL,
  CITN_CATEG          CHAR(1) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
--
DROP TABLE IF EXISTS TLS216_APPLN_CONTN;
--
CREATE TABLE TLS216_APPLN_CONTN (
  APPLN_ID  int(10) unsigned NOT NULL,
  PARENT_APPLN_ID  int(10) unsigned NOT NULL,
  CONTN_TYPE      CHAR(3)
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


DROP TABLE IF EXISTS TLS217_APPLN_ECLA;
-- no longer available replaced by CPC
--
-- CREATE TABLE TLS217_APPLN_ECLA (
--   APPLN_ID  int(10) unsigned NOT NULL,
--   EPO_CLASS_AUTH VARCHAR(2) NOT NULL
-- ,EPO_CLASS_SCHEME VARCHAR(4) NOT NULL
-- ,EPO_CLASS_SYMBOL VARCHAR(50) NOT NULL
-- )
-- ENGINE = MyISAM
-- CHARACTER SET utf8 COLLATE utf8_general_ci;


DROP TABLE IF EXISTS TLS218_DOCDB_FAM;
--
-- CREATE TABLE TLS218_DOCDB_FAM (
--   APPLN_ID  int(10) unsigned NOT NULL,
--   DOCDB_FAMILY_ID   int(10) unsigned NOT NULL
-- )
-- ENGINE = MyISAM
-- CHARACTER SET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS TLS219_INPADOC_FAM;
--
-- CREATE TABLE TLS219_INPADOC_FAM (
--   APPLN_ID  int(10) unsigned NOT NULL,
--   INPADOC_FAMILY_ID   int(10) unsigned NOT NULL
-- )
-- ENGINE = MyISAM
-- CHARACTER SET utf8 COLLATE utf8_general_ci;

--

DROP TABLE IF EXISTS TLS222_APPLN_JP_CLASS;
--
CREATE TABLE TLS222_APPLN_JP_CLASS (
  APPLN_ID  int(10) unsigned NOT NULL,
  JP_CLASS_SCHEME VARCHAR(6) NOT NULL,  
  JP_CLASS_SYMBOL VARCHAR(50) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


--

DROP TABLE IF EXISTS TLS223_APPLN_DOCUS;
--
CREATE TABLE TLS223_APPLN_DOCUS (
  APPLN_ID  int(10) unsigned NOT NULL,
  docus_class_symbol VARCHAR(50) NOT NULL
)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


-- TLS224

DROP TABLE IF EXISTS tls224_appln_cpc;


CREATE TABLE tls224_appln_cpc(
	appln_id int(10) unsigned NOT NULL,
	cpc_class_symbol varchar(19) NOT NULL DEFAULT '',
	cpc_scheme varchar(5) NOT NULL DEFAULT '',
	cpc_version date NOT NULL DEFAULT '9999-12-31',
	cpc_value char(1) NOT NULL DEFAULT '',
	cpc_position char(1) NOT NULL DEFAULT '',
	cpc_gener_auth char(2) NOT NULL DEFAULT '')
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

DROP TABLE IF EXISTS tls226_person_orig;

CREATE TABLE tls226_person_orig(
	person_orig_id int(10) unsigned NOT NULL,
	person_id int(10) unsigned NOT NULL,
	source char(5) NOT NULL DEFAULT '',
	source_version varchar(10) NOT NULL DEFAULT '',
	name_freeform varchar(500) NOT NULL DEFAULT '',
	last_name varchar(400) NOT NULL DEFAULT '',
	first_name varchar(200) NOT NULL DEFAULT '',
	middle_name varchar(50) NOT NULL DEFAULT '',
	address_freeform varchar(1000) NOT NULL DEFAULT '',
	address_1 varchar(500) NOT NULL DEFAULT '',
	address_2 varchar(500) NOT NULL DEFAULT '',
	address_3 varchar(500) NOT NULL DEFAULT '',
	address_4 varchar(500) NOT NULL DEFAULT '',
	address_5 varchar(500) NOT NULL DEFAULT '',
	street varchar(500) NOT NULL DEFAULT '',
	city varchar(200) NOT NULL DEFAULT '',
  	zip_code varchar(30) NOT NULL DEFAULT '',
	state char(2) NOT NULL DEFAULT '',
	person_ctry_code char(2) NOT NULL DEFAULT '',
	residence_ctry_code char(2) NOT NULL DEFAULT '',
	role varchar(2) NOT NULL DEFAULT '')
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


-- 227

DROP TABLE IF EXISTS tls227_pers_publn;


CREATE TABLE tls227_pers_publn(
	person_id int(10) unsigned NOT NULL,
	pat_publn_id int(10) unsigned NOT NULL,
	applt_seq_nr smallint NOT NULL,
	invt_seq_nr smallint NOT NULL)
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- 228

DROP TABLE IF EXISTS tls228_docdb_fam_citn;

CREATE TABLE tls228_docdb_fam_citn(
	docdb_family_id int(11) NOT NULL DEFAULT 0,
	cited_docdb_family_id int(1) NOT NULL DEFAULT 0)
ENGINE = MyISAM;

-- 229

DROP TABLE IF EXISTS tls229_appln_nace2;


CREATE TABLE tls229_appln_nace2(
	appln_id int(11) NOT NULL DEFAULT 0,
	nace2_code varchar(5) NOT NULL DEFAULT '',
	weight real NOT NULL DEFAULT 1)
ENGINE = MyISAM;


-- 230

DROP TABLE IF EXISTS tls230_appln_techn_field;

CREATE TABLE tls230_appln_techn_field(
	appln_id int(11) NOT NULL DEFAULT 0,
	techn_field_nr int(4) NOT NULL DEFAULT 0,
	weight real NOT NULL DEFAULT 1)
ENGINE = MyISAM;


-- tls902_ipc_nace2

DROP TABLE IF EXISTS tls902_ipc_nace2;


CREATE TABLE tls902_ipc_nace2(
	ipc varchar(8) NOT NULL DEFAULT '',
	not_with_ipc varchar(8) NOT NULL DEFAULT '',
	unless_with_ipc varchar(8) NOT NULL DEFAULT '',
	nace2_code varchar(5) NOT NULL DEFAULT '',
	nace2_weight real NOT NULL DEFAULT 1,
	nace2_descr varchar(150) NOT NULL DEFAULT '')
ENGINE = MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;





