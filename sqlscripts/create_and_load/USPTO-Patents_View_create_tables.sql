CREATE SCHEMA `uspto` DEFAULT CHARACTER SET utf8 ;

--
use uspto;
--


-----------------------------------------------------------------------------------------------
-- PVIEW
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS PVIEW;
CREATE TABLE IF NOT EXISTS PVIEW
(   
id VARCHAR(15),
patent_id VARCHAR(15),
series_code VARCHAR(2),
number VARCHAR(15),
country CHAR(2),
date CHAR(10)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;

-----------------------------------------------------------------------------------------------
-- PID
-----------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS PID;
CREATE TABLE IF NOT EXISTS PID
(   
patent_id VARCHAR(15),
APPLN_ID VARCHAR(15)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;
