rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
rs <- dbSendQuery(christian, 'SET CHARACTER SET "UTF8"')

eqpat.df<-dbGetQuery(christian, "SELECT * FROM christian.inv_pat_allclasses_equalcounting_patstat;")
eq08.df<-dbGetQuery(christian, "SELECT * FROM christian.inv_pat_allclasses_equalcounting_t08;")

patnumber<-unique(eqpat.df$pat)


cc<-lapply(patnumber[1:100],mergeinvpat)

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
# one.df<-eqpat.df[eqpat.df$pat=="EP0000060",]
# two.df<-eq08.df[eq08.df$pat=="EP0000060", ]
# one.df$PERSON_NAME<-toupper(one.df$PERSON_NAME)
# two.df$name<-toupper(two.df$name)
# result<-partialMatch(one.df$PERSON_NAME, two.df$name, levDist=0.1)
# 
# 
# 
# 
# eqpat.df[1:10,]
# eq08.df[1:10,]
# eq08.df[eq08.df$ID=="LI4045889",]
# eqpat.df[eqpat.df$pat=="WO2003035845",]


