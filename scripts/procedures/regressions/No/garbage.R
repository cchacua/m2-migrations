
lreg_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + techprox, data = database_pboc)
summary(lreg_pboc)
lreg_t_ctt<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_ctt)
lreg_t_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_pboc)

stargazer(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc, title="Linear Probability Models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity"),
          omit.stat=c("ser","f"), no.space=TRUE)
rm(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc)

logitmodel_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + techprox, family=binomial(link='logit'),data = database_ctt)
summary(logitmodel_ctt)
logitmodel_t_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_ctt)
logitmodel_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = database_pboc)
logitmodel_t_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_pboc)

stargazer(logitmodel_ctt, logitmodel_t_ctt, logitmodel_pboc, logitmodel_t_pboc, title="Logit models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity"),
          omit.stat=c("ser","f"), no.space=TRUE)


stargazer(logitmodel_ctt2, title="Logit models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          omit.stat=c("f"), no.space=TRUE)














table(database_ctt$insprox)
table(database_pboc$insprox)

summary(lreg_c_ctt) 

stargazer(lreg_c_ctt$lm_res, title="Logit models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          omit.stat=c("f"), no.space=TRUE)


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




#####################
# Estimation
##################### 
# # Basic model
# gc()
# # + geodis + insprox + degreecenboth
# 
# lreg<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, data = file.df)
# #summary(lreg)  
# logitmodel<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = file.df)
# 
# #summary(logitmodel)
# 
# # stargazer(lreg, logitmodel, title=paste0(tfield, " basic models, 1980-2012"),
# #           align=TRUE, dep.var.labels="Co-invention",
# #           covariate.labels=c("Ethnic proximity",
# #                              "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
# #                              , "Geographic distance", "Institutional proximity"),
# #           omit.stat=c("ser","f"), no.space=TRUE)
# 
# lreg_t<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = file.df)
# #summary(lreg_t) 
#   
# # What should I do with the missings
# 
# logitmodel_t<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = file.df)
# #summary(logitmodel_t)
# 
# # 
# lreg_c<-miceadds::lm.cluster(data = file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, cluster = "finalID")
# logitmodelc_<-  miceadds::glm.cluster(data = file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, cluster = "finalID",family=binomial(link='logit'))
# 
# logitmodel_tc<-miceadds::glm.cluster(data=file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, cluster = "finalID",family=binomial(link='logit'))
# #summary(logitmodel_tc)
# lreg_tc<-miceadds::lm.cluster(data=file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, cluster = "finalID")
# #summary(lreg_tc)
# return(list(ols1=lreg, ols2=lreg_t, ols3=lreg_c, ols4=lreg_tc, logit1=logitmodel, logit2=logitmodel_t,logit3=logitmodelc_,logit4=logitmodel_tc))


