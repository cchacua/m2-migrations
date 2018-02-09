CREATE SCHEMA `li` DEFAULT CHARACTER SET utf8 ;

--
use li;
--

---------------------------------------------------------------------------------------------------
--  invpat
---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS invpat;
CREATE TABLE IF NOT EXISTS invpat
( 
Firstname VARCHAR(300),
Lastname VARCHAR(300),
Street VARCHAR(500),
City VARCHAR(100),
State CHAR(2),
Country CHAR(2),
Zipcode VARCHAR(15),
Lat VARCHAR(20),
Lon VARCHAR(20),
InvSeq VARCHAR(20),
Patent VARCHAR(20),
GYear CHAR(4),
AppYearStr CHAR(4),
AppDateStr CHAR(10),
Assignee VARCHAR(500),
AsgNum VARCHAR(30),
Class VARCHAR(20),
Invnum VARCHAR(20),
lowerv VARCHAR(20),
upperv VARCHAR(20)
)
ENGINE=MyISAM
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
;


