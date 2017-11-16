-- https://stackoverflow.com/questions/978147/how-do-you-extract-a-numerical-value-from-a-string-in-a-mysql-query
SET GLOBAL log_bin_trust_function_creators=1;
DROP FUNCTION IF EXISTS digits;
DELIMITER |
CREATE FUNCTION digits( str CHAR(32) ) RETURNS CHAR(32)
BEGIN
  DECLARE i, len SMALLINT DEFAULT 1;
  DECLARE ret CHAR(32) DEFAULT '';
  DECLARE c CHAR(1);

  IF str IS NULL
  THEN 
    RETURN "";
  END IF;

  SET len = CHAR_LENGTH( str );
  REPEAT
    BEGIN
      SET c = MID( str, i, 1 );
      IF c BETWEEN '0' AND '9' THEN 
        SET ret=CONCAT(ret,c);
      END IF;
      SET i = i + 1;
    END;
  UNTIL i > len END REPEAT;
  RETURN ret;
END |
DELIMITER ;

-- SELECT digits('$10.00Fr'); 
-- #returns 1000


DELIMITER $$
 
DROP FUNCTION IF EXISTS `uReplaceNon_Numer`$$
 
CREATE FUNCTION `uReplaceNon_Numer`(in_phone varchar(50)) RETURNS varchar(50) CHARSET latin1
    NO SQL
BEGIN
DECLARE ctrNumber varchar(50);
DECLARE finNumber varchar(50) default ' ';
DECLARE sChar varchar(2);
DECLARE inti INTEGER default 1;
-- RETURN 'hello1';
    IF length(in_phone) > 0 THEN
-- RETURN 'hello2';
	WHILE(inti <= length(in_phone)) DO
-- RETURN 'hello3';
		SET sChar= SUBSTRING(in_phone,inti,1);
-- RETURN sChar;
                SET ctrNumber= FIND_IN_SET(sChar,'0,1,2,3,4,5,6,7,8,9');
-- RETURN ctrNumber;
		
                IF ctrNumber > 0 THEN
			SET finNumber=CONCAT(finNumber,sChar);
-- RETURN CONCAT('in if',finNumber);
                ELSE
			SET finNumber=CONCAT(finNumber,' ');
-- RETURN CONCAT('in else',finNumber);
                END IF;
		SET inti=inti+1;
	END WHILE;
	RETURN finNumber;
    ELSE
	RETURN 'Invalid';
    END IF;
	
END$$
 
DELIMITER ;