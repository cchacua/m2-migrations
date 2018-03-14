########################################
# Load data
########################################

# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# Get data

# Non repeated IDS, with almost clean strings

namesone.df<-dbGetQuery(patstat, 
                        "SELECT DISTINCT a.name, a.finalID 
                        FROM (SELECT MAX(b.name) AS name, b.finalID, MAX(b.ncommas) AS ncommas, MAX(b.ncharac) AS ncharac, MAX(b.nblanks) AS nblanks, MAX(b.ncommasblanksright) AS ncommasblanksright, MAX(b.hnumber) AS hnumber, MAX(b.ndots) AS ndots FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility b GROUP BY b.finalID HAVING COUNT(b.finalID)=1 ) a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID")
length(unique(namesone.df$finalID))
nrow(namesone.df)
# Attention: to delete special characters

namesone.df.m<-str_split(namesone.df$name, ", ",  simplify=TRUE)
namesone.df.m<-as.data.frame(namesone.df.m)
namesone.df$firstname<-as.character(namesone.df.m[,2])
namesone.df$lastname<-as.character(namesone.df.m[,1])

dictionaryupper<-c("INC", "LLC")
namesone.df[toupper(namesone.df$firstname)=='INC',]
namesone.df[toupper(namesone.df$lastname)=='INC',]
# Delete just one character first names
View(namesone.df[stri_length(namesone.df$firstname)<2,])
namesone.df$firstname[stri_length(namesone.df$firstname)<2]<-""
View(namesone.df$firstname[stri_length(namesone.df$firstname)<2])
# Delete last names with just one character
View(namesone.df[stri_length(namesone.df$lastname)<2,])
namesone.df$lastname[stri_length(namesone.df$lastname)<2]<-""
View(namesone.df$lastname[stri_length(namesone.df$lastname)<2])

namesone.df$full<-as.character(paste0(ifelse(namesone.df$firstname=="", "",paste0(namesone.df$firstname, " ")), namesone.df$lastname))
print(namesone.df[grepl(")",namesone.df$full),])
namesone.df$full[namesone.df$full=="Lihua(Lily) ZHANG"]<-"Lihua ZHANG"
namesone.df$full[namesone.df$full=="Chiakeng(jack) WU"]<-"Chiakeng WU"

write.csv(namesone.df, "../output/nationality/part1.csv")




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





















