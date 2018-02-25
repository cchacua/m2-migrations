CREATE SCHEMA `li` DEFAULT CHARACTER SET utf8 ;

--
use li;
--

---------------------------------------------------------------------------------------------------
--  invpat invpat final (List of authors, dissambiguated)
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS li.invpat;
CREATE TABLE IF NOT EXISTS li.invpat
( 
Firstname VARCHAR(55),
Lastname VARCHAR(65),
Street VARCHAR(200),
City VARCHAR(40),
State CHAR(2),
Country CHAR(2),
Zipcode VARCHAR(15),
Lat VARCHAR(16),
Lon VARCHAR(16),
InvSeq VARCHAR(2),
Patent CHAR(8),
GYear CHAR(4),
AppYearStr CHAR(4),
AppDateStr CHAR(10),
Assignee VARCHAR(240),
AsgNum VARCHAR(13),
Class VARCHAR(15),
Invnum VARCHAR(11),
lowerv VARCHAR(11),
upperv VARCHAR(11)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;


---------------------------------------------------------------------------------------------------
--  patent
---------------------------------------------------------------------------------------------------
-- List of patents and basic identification information such as Application Date, Grant Date, etc. 
-- 1. Raw Patent Datasets (sqlite3, csv) 1975-2010
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS li.patent;
CREATE TABLE IF NOT EXISTS li.patent
( 
Patent CHAR(8),
Kind VARCHAR(2),  
Claims VARCHAR(4),
AppType VARCHAR(2),
AppNum VARCHAR(8),
GDate CHAR(10),
GYear CHAR(4),
AppDate CHAR(10),
AppYear CHAR(4)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

---------------------------------------------------------------------------------------------------
-- usreldoc
-- Related patent documents (continuations, etc)
---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS li.usreldoc;
CREATE TABLE IF NOT EXISTS li.usreldoc
(
Patent CHAR(8),    
DocType VARCHAR(26),   
OrderSeq VARCHAR(2),  
Country CHAR(2),   
RelPatent VARCHAR(17), 
Kind VARCHAR(2),
RelDate VARCHAR(8),   
Status VARCHAR(9)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;



