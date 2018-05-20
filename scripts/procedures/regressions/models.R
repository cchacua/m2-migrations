rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

estimate_models<-function(tfield, naaszero=TRUE){
  tfield<-"ctt"
  naaszero<-FALSE
  file.df<-as.data.table(dbGetQuery(patstat, paste0(
    "SELECT linked, ethnic, socialdist, av_cent, absdif_cent, geodis, undid, EARLIEST_FILING_YEAR, insprox, techprox, counterof, CONCAT(EARLIEST_FILING_YEAR, finalID, IFNULL(counterof, ''), finalID_) AS undidcc, finalID, finalID_, nation, nation_
    FROM riccaboni.count_edges_",tfield,"_gsi
    WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';")))
  setkey(file.df,undid) 
  
  #####################
  # Delete when social distance is one, as to focus on first collaborations
  #####################
  
  file.df<-deletecounterofvar(dfcond=file.df[file.df$socialdist==1 & file.df$linked==1,], file.df, tfield)
    
  
  # Extract when social distance is equal one
  file_sd_1.df<-
  #table(file_sd_1.df$linked)
  setkey(file_sd_1.df,undid)
  # Identify the counterfactual pairs
  # ATTENTION: THE NAME OF THE COUNTERFACTUAL IS pat
  counter<-as.data.table(dbGetQuery(patstat, paste0(
                                    "SELECT finalID, finalID_, pat, undid, CONCAT(EARLIEST_FILING_YEAR, finalID, pat) AS undidc, CONCAT(EARLIEST_FILING_YEAR, finalID, pat, finalID_) AS undidcc
                                    FROM riccaboni.edges_dir_count_",tfield,"
                                    WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';")))
  
  setkey(counter,undidc)
  counter<-counter[file_sd_1.df, nomatch=0]
  delete<-rbind(counter[,"undidcc"],file_sd_1.df[,"undidcc"])
  setkey(delete,undidcc)
  
  # Delete when social distance is equal one
  setkey(file.df,undidcc)
  file.df<-file.df[!delete]
  table(file.df$linked)
  nrow(delete)
  nrow(file.df)
  rm(delete, file_sd_1.df, counter)
  
  #####################
  # Keep only first collaborations (create a new id without year and make the distribution of years)
  #####################
  file.df$idnodes<-substr(file.df$undid,5, nchar(file.df$undid))
  #file.df<-file.df[1:10,]
  file.df<-file.df[order(file.df$EARLIEST_FILING_YEAR),]
  file_fc.df<-reshape(transform(file.df[file.df$linked==1], time=ave(EARLIEST_FILING_YEAR, idnodes, FUN=seq_along)), idvar=c("idnodes"), direction="wide")
  #file_fc.df<-file_fc.df[order(file_fc.df$linked.2),]
  delete1<-rbind(data.frame(undidcc=unique(file_fc.df$undidcc.2)),data.frame(undidcc=unique(file_fc.df$undidcc.3)), data.frame(undidcc=unique(file_fc.df$undidcc.4)))
  delete1<-data.table(undidcc=delete1[complete.cases(delete1),"undidcc"])
  setkey(delete1,undidcc)
  
  counter<-as.data.table(dbGetQuery(patstat, 
                                    "SELECT finalID, finalID_, pat, undid, CONCAT(EARLIEST_FILING_YEAR, finalID, pat) AS undidc, CONCAT(EARLIEST_FILING_YEAR, finalID, pat, finalID_) AS undidcc
                                    FROM riccaboni.edges_dir_count_ctt
                                    WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';"))
  
  
  setkey(counter,undidc)
  counter<-counter[delete1, nomatch=0]
  
  delete<-rbind(counter[,"undidcc"],delete1[,"undidcc"])
  setkey(delete,undidcc)
  
  setkey(file.df,undidcc)
  file.df<-file.df[!delete]
  rm(delete, counter, delete1, file_fc.df)

  #table(file.df$insprox)
  if(naaszero==TRUE){
    file.df$insprox[is.na(file.df$insprox)]<-0
    file.df$techprox[is.na(file.df$techprox)]<-0
  }
  else{
    
    rm(delete, file_ins1.df, counter)
  }
  #####################
  # Create dummies of social distance
  #####################
  file.df$socialdist<-as.numeric(file.df$socialdist)
  # file.df$soc_1<-ifelse(file.df$socialdist<2, 1, 0)    
  # table(file.df$soc_1)
  # file.df[file.df$soc_1==1,]
  file.df$soc_2<-ifelse(file.df$socialdist==2, 1, 0)    
  file.df$soc_3<-ifelse(file.df$socialdist==3, 1, 0)    
  file.df$soc_4<-ifelse(file.df$socialdist==4, 1, 0)    
  file.df$soc_5m<-ifelse(file.df$socialdist>4, 1, 0)    

  # table(file.df$soc_2)
  # table(file.df$soc_3)
  # table(file.df$soc_4)
  # table(file.df$soc_5m)
  
  #####################
  # Recode geographic distance as a numeric and year as factor
  #####################    
  file.df$geodis<-as.numeric(file.df$geodis)
  file.df$EARLIEST_FILING_YEAR<-factor(file.df$EARLIEST_FILING_YEAR)
  
  #table(file.df$absdif_cent)
  fwrite(file.df, paste0("../output/final_tables/",tfield,"_na",naaszero, "_firstcoll.csv"))
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
  return("Done")
}





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

lreg_ctt<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox, data = database_ctt)
lreg_t_ctt<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_ctt)
lreg_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox, data = database_pboc)
lreg_t_pboc<-lm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = database_pboc)

stargazer(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc, title="Linear Probability Models, 1980-2012",
          align=TRUE, dep.var.labels="Co-invention",
          covariate.labels=c("Ethnic proximity",
                             "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
                             , "Geographic distance", "Institutional proximity"),
          omit.stat=c("ser","f"), no.space=TRUE)
rm(lreg_ctt, lreg_t_ctt, lreg_pboc, lreg_t_pboc)

logitmodel_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = database_ctt)
logitmodel_t_ctt<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_ctt)
logitmodel_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = database_pboc)
logitmodel_t_pboc<-glm(linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = database_pboc)

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
