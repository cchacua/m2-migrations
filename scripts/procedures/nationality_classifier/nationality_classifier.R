########################################
# Load data
########################################

# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# Get data

# Non repeated IDS, with almost clean strings
cleannames_one<-function(query, filename=NULL){
  namesone.df<-dbGetQuery(patstat, query)
  print(paste("Number of rows:", nrow(namesone.df)))
  print(paste("Distinct IDs:",length(unique(namesone.df$finalID))))
  
  namesone.df.m<-str_split(namesone.df$name, ", ",  simplify=TRUE)
  namesone.df.m<-as.data.frame(namesone.df.m)
  namesone.df$firstname<-as.character(namesone.df.m[,2])
  namesone.df$lastname<-as.character(namesone.df.m[,1])
  
  # Delete just one character first names
    print("********************************First Names********************************")
    #print(namesone.df[stri_length(namesone.df$firstname)<2, 3:4])
    namesone.df$firstname[stri_length(namesone.df$firstname)<2]<-""
    #print(namesone.df[stri_length(namesone.df$firstname)<2, 3:4])
    
  # Delete last names with just one character
    print("********************************Last Names********************************")
    #print(namesone.df[stri_length(namesone.df$lastname)<2, 3:4])
    namesone.df$lastname[stri_length(namesone.df$lastname)<2]<-""
    #print(namesone.df[stri_length(namesone.df$lastname)<2, 3:4])
  
  #print("********************************Parenthesis********************************")   
    #print(part1.df[grepl(")",part1.df$full),])
    
  namesone.df$full<-as.character(paste0(ifelse(namesone.df$firstname=="", "",paste0(namesone.df$firstname, " ")), namesone.df$lastname))

  #write.csv(namesone.df, paste0("../output/nationality/", filename))
  return(namesone.df)
}










###################

part1.df<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID",
                        filename = "part1.csv")
print(part1.df[grepl(")",part1.df$full),])
part1.df$full[part1.df$full=="Lihua(Lily) ZHANG"]<-"Lihua ZHANG"
part1.df$full[part1.df$full=="Chiakeng(jack) WU"]<-"Chiakeng WU"
write.csv(part1.df, paste0("../output/nationality/", "part1.csv"))
part1.df<-read.csv("../output/nationality/part1.csv")
dbWriteTable(christian, "idnames_part01", data.frame(finalID=part1.df$finalID), field.types=list(finalID="VARCHAR(15)"), row.names=FALSE)
"
DROP TABLE IF EXISTS christian.idnames_part01;
"

# Run on MySQL 
"
SHOW INDEX FROM christian.idnames_part01; 
ALTER TABLE christian.idnames_part01 ADD INDEX(finalID);

SHOW INDEX FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility; 
ALTER TABLE riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility ADD INDEX(finalID);

DROP TABLE IF EXISTS christian.idnames_a01;
CREATE TABLE christian.idnames_a01 AS
SELECT a.* 
FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a
LEFT JOIN christian.idnames_part01 b
ON a.finalID=b.finalID
WHERE b.finalID IS NULL;
SHOW INDEX FROM christian.idnames_a01; 
ALTER TABLE christian.idnames_a01 ADD INDEX(finalID);
"

################

part2.df<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots!='0'
                        ORDER BY a.finalID",
                         filename = "part2.csv")

part2.df.clean<-part2.df[toupper(part2.df$firstname)!='INC.' & toupper(part2.df$firstname)!='LLC.' & toupper(part2.df$firstname)!='LTD.',]
part2.df.clean<-part2.df.clean[toupper(part2.df.clean$lastname)!='INC.' & toupper(part2.df.clean$lastname)!='LLC.' & toupper(part2.df.clean$lastname)!='LTD.',]
# Delete When the number of points is half the lenght of the string
part2.df.clean$firstname[str_count(part2.df.clean$firstname, "\\.")/stri_length(part2.df.clean$firstname)>=.5]<-""
part2.df.clean$lastname[str_count(part2.df.clean$lastname, "\\.")/stri_length(part2.df.clean$lastname)>=.5]<-""
# Delete first character after a point
part2.df.clean$firstname<-sub("^.?\\.", "", part2.df.clean$firstname)
part2.df.clean$lastname<-sub("^.?\\.", "", part2.df.clean$lastname)
# Delete last character after a point if Upper Case
part2.df.clean$firstname<-sub("[[:upper:]]\\.$", "", part2.df.clean$firstname)
# Delete last point
part2.df.clean$firstname<-sub("\\.$", "", part2.df.clean$firstname)
# Delete last -
part2.df.clean$firstname<-sub("\\-$", "", part2.df.clean$firstname)
# Delete begining -
part2.df.clean$firstname<-sub("^\\-", "", part2.df.clean$firstname)
# Deleting again single characters

# All of this should be a function, and should be runed for first and last names

################


  
dictionaryupper<-c("INC", "LLC")



tt<-read.csv("../output/nationality/part1.csv")
print(tt[1,"full"])

print(namesone.df[grepl("\\.",namesone.df$full),])

# And also first names with one letter and a dot
View(namesone.df[grepl("\\.",namesone.df$firstname),])
View(namesone.df[stri_length(namesone.df$firstname)<=5 & grepl("\\.",namesone.df$firstname),])

#And also last names with one letter and a dot
View(namesone.df[grepl("\\.",namesone.df$lastname),])
View(namesone.df[stri_length(namesone.df$lastname)<=5 & grepl("\\.",namesone.df$lastname),])


namesone.df<-dbGetQuery(patstat, 
                         "SELECT DISTINCT a.name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0'
                        ORDER BY a.finalID")


namesone.df<-dbGetQuery(patstat, 
                        "SELECT MAX(a.name) AS name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0'
                        GROUP BY a.finalID 
                        HAVING COUNT(a.finalID)=1 
                        ORDER BY a.finalID")





















