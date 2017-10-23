use patstat2016b;
SELECT APPLN_ID FROM TLS201_APPLN  LIMIT 0, 10 INTO OUTFILE '/media/christian/Server/Github/m2-migrations/output/table1.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';