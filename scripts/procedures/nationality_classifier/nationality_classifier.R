
# Load data
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