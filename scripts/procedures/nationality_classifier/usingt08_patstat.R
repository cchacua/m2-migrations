rs <- dbSendQuery(christian, 'SET CHARACTER SET "UTF8"')

eqpat.df<-dbGetQuery(christian, "SELECT * FROM christian.inv_pat_allclasses_equalcounting_patstat;")
eq08.df<-dbGetQuery(christian, "SELECT * FROM christian.inv_pat_allclasses_equalcounting_t08;")

patnumber<-dbGetQuery(christian, "SELECT DISTINCT a.pat FROM riccaboni.t01_allclasses_as_t08_us_atleastone a;")
patnumber<-as.character(patnumber$pat)
#patnumber<-unique(eqpat.df$pat)

log<-lapply(patnumber[1:10000],function(x){tryCatch(mergeinvpat(x),error=function(e) print("Error") )})
# Last: EP0226734
cc.df<-merge.csv("../output/matched_names/")

#patnumber<-unique(eqpat.df$pat)
patnumber<-as.data.frame(table(eqpat.df$pat))
patnumber2<-patnumber[patnumber$Freq>1,]
patnumber2<-as.character(unique(patnumber2$Var1))  
match1<-lapply(patnumber2[1:1000],mergeinvpat)
match1<-merge.list(match1)
write.csv(match1, "../output/nationality/output/match1.csv")



# 
# 
# cc.df<-merge.list(cc)
#   
#   do.call(rbind, unname(Map(cbind, colour = names(my.list), my.list))) (cc)
# 
# one.df<-eqpat.df[eqpat.df$pat=="WO2003035845",]
# two.df<-eq08.df[eq08.df$pat=="WO2003035845", ]
# one.df$PERSON_NAME<-toupper(one.df$PERSON_NAME)
# two.df$name<-toupper(two.df$name)
# result<-partialMatch(one.df$PERSON_NAME, two.df$name, levDist=0.1)
# 
# cc<-mergeinvpat("WO2003035845")
# 
one.df<-eqpat.df[eqpat.df$pat=="EP0000152",]
two.df<-eq08.df[eq08.df$pat=="EP0000152", ]
one.df$PERSON_NAME<-toupper(one.df$PERSON_NAME)
two.df$name<-toupper(two.df$name)
result<-partialMatch(one.df$PERSON_NAME, two.df$name, levDist=0.1)
# 
# 
# 
# 
# eqpat.df[1:10,]
# eq08.df[1:10,]
# eq08.df[eq08.df$ID=="LI4045889",]
# eqpat.df[eqpat.df$pat=="WO2003035845",]


