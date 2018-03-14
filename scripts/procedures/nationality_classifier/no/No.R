
# Select patents with only one author (easiest to merge)
names_oneinv.df<-dbGetQuery(patstat, 
                            "SELECT a.pat, c.PERSON_ID, c.INVT_SEQ_NR, a.ID, a.name, c.PERSON_NAME, c.HAN_NAME, c.PSN_NAME, c.DOC_STD_NAME ,c.PERSON_CTRY_CODE
                            FROM christian.inv_pat_allclasses_equalcounting_t08 a 
                            INNER JOIN christian.counting_invenbypatents_allclasses b
                            ON a.pat=b.pat
                            INNER JOIN christian.inv_pat_allclasses_equalcounting_patstat c
                            ON a.pat=c.pat
                            WHERE b.n01='1'
                            ORDER BY a.pat")

# names.one.df<-dbGetQuery(patstat, "SELECT DISTINCT MAX(a.name) AS name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames_us_atleastone_mobility a GROUP BY a.finalID HAVING COUNT(a.finalID)=1 ORDER BY a.finalID")
#names.one.df<-dbGetQuery(patstat, "SELECT DISTINCT MAX(a.name) AS name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a GROUP BY a.finalID HAVING COUNT(a.finalID)=1 ORDER BY a.finalID")
names.one.df<-names_oneinv.df


nrow(names.one.df)
#names.one.df<-dbGetQuery(patstat, "SELECT DISTINCT MIN(a.name) AS name, a.finalID FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a GROUP BY a.finalID HAVING COUNT(a.finalID)=1 ORDER BY a.finalID")

# There are 1.080.746 of single names id. So there are 431.030 ids to identify,  which have 1.100.369 different spellings

#names.one.df.copy<-names.one.df
#names.one.df<-names.one.df[1:10000,]


########################################
# Cleaning process
########################################

# 1. Get the number of comas
names.one.df$ncommas<-str_count(names.one.df$name, ",")
table(names.one.df$ncommas)

names.one.df$npncommas<-str_count(nnames.one.df$PERSON_NAME, ",")
table(names.one.df$npncommas)

# 1.1 Get the number of comas with blanks (both)
names.one.df$ncommasblanksboth<-str_count(names.one.df$name, " , ")
table(names.one.df$ncommasblanksboth)

names.one.df$ncommasblanksleft<-str_count(names.one.df$name, " ,")
table(names.one.df$ncommasblanksleft)

names.one.df$ncommasblanksright<-str_count(names.one.df$name, ", ")
table(names.one.df$ncommasblanksright)

# 2. Get precision: First 2 character 
# High quality IDs:
# HA: High-resolution assignee (linked in step 1)
# HI: High-resolution inventor (linked in step 1)
# HX: High-resolution cross-linked inventor (linked in step 5)
# HM: High-resolution mobile inventor (linked in step 5)
# LX: Low-resolution cross-linked inventor (linked in step 5)
# LM: Low-resolution mobile inventor (linked in step 5)
# 
# Low quality IDs:
# LA: Low-resolution assignee
# HS: High-resolution split inventor
# LI: Low-resolution inventor
# LS: Low-resolution split inventor
# UI: Unlocated inventor
# UX: Unlocated cross-linked inventor
# US: Unlocated split inventor

names.one.df$qualid<-substr(names.one.df$finalID, 0, 2)
table(names.one.df$qualid)


# 3. Binary if at least one number in the string
names.one.df$number<-grepl("[[:digit:]]", names.one.df$name)
table(names.one.df$number)
View(names.one.df[names.one.df$number==TRUE,])
# This allows to see that the name disambiguation is not that good. For most of the cases when there is a number, it is possible to see that it is part of the address and we are referring to the same inventor
# To substitute number by nothig gsub('[[:digit:]]+', '', names.one.df$number)

# 4. Char lenght
names.one.df$nchar<-nchar(names.one.df$name)
table(names.one.df$nchar)
View(names.one.df[names.one.df$nchar>=54,])

names.one.df$nchar<-nchar(names.one.df$PERSON_NAME)
table(names.one.df$nchar)

# 5 Get the number of blanks
names.one.df$nblanks<-str_count(names.one.df$name, " ")
table(names.one.df$nblanks)
View(names.one.df[names.one.df$nblanks==0,])
# To add spaces between commas if commas =1




tric_names_id<-read.csv(files.sql[2], header = FALSE)
colnames(tric_names_id)<-c("ID", "name")

########################################
# Number of times an id appears
########################################
idrep<-as.data.frame(table(tric_names_id$ID))
colnames(idrep)<-c("ID", "freq")
View(idrep[1:100,])
table(idrep$freq)

#       1       2       3       4       5       6       7       8       9      10      11 
# 1331428  236913   80515   31708   14225    6525    3469    1876    1119     718     445 

#      12      13      14      15      16      17      18      19      20      21      22 
#     298     260     170     133      86      88      63      45      28      30      19 

#      23      24      25      26      27      28      29      30      31      32      33 
#      18       9       3      10       6       4       6       8       2       1       4 

#      36      37      40      41      43      44      45      48      52      57 
#       2       2       3       1       1       2       1       1       1       1 
# Attention, this is the number of different spellings for a name, and IT IS NOT THE NUMBER OF COLLABORATIONS, 
# As a DISTINCT select was conducted to create this sample. The number of collaborations can be got by looking at the mysql table by id and pat, although families should be considered

unique(idrep$freq)
# Merge ATTENTION, BAD RESULT
# idrep<-{ 
#   dt1 <- data.table(tric_names_id, key = "ID")
#   dt2 <- data.table(idrep, key = "ID")
#   data.frame( dt1[dt2,list(ID,name,freq=dt2$freq)] )
# }

table(idrep$freq)



########################################
# Number of commas
########################################
tric_names_id$ncommas<-str_count(tric_names_id$name, ",")
table(tric_names_id$ncommas)
#     0       1       2       3       4       5       6 
# 18675 1853276  421784   66093    5547     255      32


# Split according to commas
namesmatrix<-str_split(tric_names_id, ",",  simplify=TRUE)
View(namesmatrix[1:100,])