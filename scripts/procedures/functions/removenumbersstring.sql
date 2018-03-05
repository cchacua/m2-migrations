-- THIS IS A FUNCTION TO REMOVE THE NUMBERS FOR THE NAME STRING OF THE T08 TABLE

DELIMITER $$ 

DROP FUNCTION IF EXISTS `uExtractNumberFromString`$$
CREATE FUNCTION `uExtractNumberFromString`(in_string varchar(500)) 
RETURNS INT
NO SQL

BEGIN

    DECLARE ctrNumber varchar(500);
    DECLARE finNumber varchar(500) default ' ';
    DECLARE sChar varchar(2);
    DECLARE inti INTEGER default 1;

    IF length(in_string) > 0 THEN

        WHILE(inti <= length(in_string)) DO
            SET sChar= SUBSTRING(in_string,inti,1);
            SET ctrNumber= FIND_IN_SET(sChar,'0,1,2,3,4,5,6,7,8,9');

            IF ctrNumber > 0 THEN
               SET finNumber=CONCAT(finNumber,sChar);
            ELSE
               SET finNumber=CONCAT(finNumber,'');
            END IF;
            SET inti=inti+1;
        END WHILE;
        RETURN CAST(finNumber AS SIGNED INTEGER) ;
    ELSE
        RETURN 0;
    END IF;

END$$

DELIMITER ;
