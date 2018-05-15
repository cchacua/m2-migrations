rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')


estimate_models("ctt")
estimate_models("pboc")

database_ctt<-as.data.table(read.csv("../output/final_tables/ctt_firstcoll.csv"))
database_ctt$geodis<-as.numeric(database_ctt$geodis)
database_ctt$EARLIEST_FILING_YEAR<-factor(database_ctt$EARLIEST_FILING_YEAR)
#database_ctt$finalID<-factor(database_ctt$finalID)
write.dta(database_ctt, "../output/final_tables/ctt_firstcoll.dta")

database_pboc<-as.data.table(read.csv("../output/final_tables/pboc_firstcoll.csv"))
database_pboc$geodis<-as.numeric(database_pboc$geodis)
database_pboc$EARLIEST_FILING_YEAR<-factor(database_pboc$EARLIEST_FILING_YEAR)
write.dta(database_pboc, "../output/final_tables/pboc_firstcoll.dta")

lreg_ctt<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, data = database_ctt)
lreg_t_ctt<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_ctt)
lreg_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, data = database_pboc)
lreg_t_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_pboc)

stargazer(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc, title="Linear Probability Models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity"),
          omit.stat=c("ser","f"), no.space=TRUE)
rm(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc)

logitmodel_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = database_ctt)
logitmodel_t_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_ctt)
logitmodel_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = database_pboc)
logitmodel_t_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_pboc)

stargazer(logitmodel_ctt, logitmodel_t_ctt, logitmodel_pboc, logitmodel_t_pboc, title="Logit models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity"),
          omit.stat=c("ser","f"), no.space=TRUE)

table(database_ctt$insprox)
table(database_pboc$insprox)

lreg_c_ctt<-miceadds::lm.cluster(data = database_ctt, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, cluster = "finalID")
summary(lreg_c_ctt) 
summary(lreg_ctt) 
se2<-sqrt(diag(as.matrix(lreg_c_ctt$vcov)))
lreg_c_ctt$lm_res$
  se1<-lreg_ctt$
  
  stargazer(lreg_ctt, lreg_ctt, title="Linear Probability Models, 1980-2012",
            align=TRUE, dep.var.labels="Co-invention",
            se=list(NULL, se2), 
            covariate.labels=c("Ethnic proximity",
                               "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                               , "Geographic distance", "Institutional proximity"),
            omit.stat=c("ser","f"), no.space=TRUE)

#summary(lreg_ctt, cluster=finalID) 
# summary(lreg_t_ctt) 
# summary(lreg_t_ctt, cluster="finalID") 

stargazer(lreg, lreg_t, logitmodel, logitmodel_t, title=paste0(tfield, " models including time fixed effects, 1980-2012"),
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity", "Priority year"),
          omit.stat=c("ser","f"), no.space=TRUE)
