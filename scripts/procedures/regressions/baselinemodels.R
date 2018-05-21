rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

estimate_models("ctt", TRUE)
estimate_models("pboc", TRUE)
estimate_models("ctt", FALSE)
estimate_models("pboc", FALSE)

files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases

runmodels<-function(sformula, labels_cov, includenas=TRUE, logit=FALSE, clustered=TRUE, flist=files.databases){
  if(includenas==TRUE){
    database_ctt<-as.data.table(read.csv(flist[2]))
    database_pboc<-as.data.table(read.csv(flist[4]))
  }
    else{
    database_ctt<-as.data.table(read.csv(flist[1]))
    database_pboc<-as.data.table(read.csv(flist[3]))
    }
  
  # if(includenas==TRUE){
  #   database_ctt<-read.csv(flist[2])
  #   database_pboc<-read.csv(flist[4])
  # }
  # else{
  #   database_ctt<-read.csv(flist[1])
  #   database_pboc<-read.csv(flist[3])
  # }
  
  database_ctt$geodis<-as.numeric(database_ctt$geodis)
  database_ctt$EARLIEST_FILING_YEAR<-factor(database_ctt$EARLIEST_FILING_YEAR)
  #write.dta(database_ctt, paste0("../output/final_tables/ctt_na",includenas,".dta"))
  
  database_pboc$geodis<-as.numeric(database_pboc$geodis)
  database_pboc$EARLIEST_FILING_YEAR<-factor(database_pboc$EARLIEST_FILING_YEAR)
  #write.dta(database_pboc, paste0("../output/final_tables/pboc_na",includenas,".dta"))

  # Attention: sformula should be a string
  sformula_t<-as.formula(paste0(sformula, " + EARLIEST_FILING_YEAR"))
  sformula<-as.formula(sformula)
  
  if(logit==TRUE){
    tittle_table<-"Logit Models, 1980-2012"
    reg_ctt<-glm(sformula, family=binomial(link='logit'), data = database_ctt)
    reg_pboc<-glm(sformula, family=binomial(link='logit'), data = database_pboc)
    reg_t_ctt<-glm(sformula_t, family=binomial(link='logit'), data = database_ctt)
    reg_t_pboc<-glm(sformula_t, family=binomial(link='logit'), data = database_pboc)
    
    
    # print((reg_ctt$null.deviance - reg_ctt$deviance)/reg_ctt$null.deviance)
    # 
    # print(paste("McFadden Pseudo-R2", reg_ctt_r2, reg_pboc_r2, reg_t_ctt_r2, paste0(reg_t_pboc_r2, " \\"), sep = " & "))
    # 
    # https://mgimond.github.io/Stats-in-R/Logistic.html
    
    # nagelkerke(reg_ctt)
    # reg_ctt_r2<-DescTools::PseudoR2(reg_ctt, which ="McFadden")
    # reg_pboc_r2<-DescTools::PseudoR2(reg_pboc, which ="McFadden")
    # reg_t_ctt_r2<-DescTools::PseudoR2(reg_t_ctt, which ="McFadden")
    # reg_t_pboc_r2<-DescTools::PseudoR2(reg_t_pboc, which ="McFadden")
    # print(paste("McFadden Pseudo-R2", reg_ctt_r2, reg_pboc_r2, reg_t_ctt_r2, paste0(reg_t_pboc_r2, " \\"), sep = " & "))
    
    #reg_ctt<-rms::lrm(sformula, data = database_ctt)
    #reg_pboc<-rms::lrm(sformula, data = database_pboc)
    #reg_t_ctt<-rms::lrm(sformula_t, data = database_ctt)
    #reg_t_pboc<-rms::lrm(sformula_t, data = database_pboc)
    

    if(clustered==TRUE){
      reg_ctt_c<-miceadds::glm.cluster(data = database_ctt, sformula, cluster = "finalID", family=binomial(link='logit'))
      reg_pboc_c<-miceadds::glm.cluster(data = database_pboc, sformula, cluster = "finalID", family=binomial(link='logit'))
      reg_t_ctt_c<-miceadds::glm.cluster(data = database_ctt, sformula_t, cluster = "finalID", family=binomial(link='logit'))
      reg_t_pboc_c<-miceadds::glm.cluster(data = database_pboc, sformula_t, cluster = "finalID", family=binomial(link='logit'))
      
      reg_ctt_c_s<-sqrt(diag(as.matrix(reg_ctt_c$vcov)))
      reg_pboc_c_s<-sqrt(diag(as.matrix(reg_pboc_c$vcov)))
      reg_t_ctt_c_s<-sqrt(diag(as.matrix(reg_t_ctt_c$vcov)))
      reg_t_pboc_c_s<-sqrt(diag(as.matrix(reg_t_pboc_c$vcov)))
      }
  }
  else{
    tittle_table<-"Linear Probability Models, 1980-2012"
    reg_ctt<-lm(formula=sformula, data = database_ctt)
    reg_pboc<-lm(formula=sformula, data = database_pboc)
    reg_t_ctt<-lm(sformula_t, data = database_ctt)
    reg_t_pboc<-lm(sformula_t, data = database_pboc)
    if(clustered==TRUE){
      reg_ctt_c<-miceadds::lm.cluster(data = database_ctt, sformula, cluster = "finalID")
      reg_pboc_c<-miceadds::lm.cluster(data = database_pboc, sformula, cluster = "finalID")
      reg_t_ctt_c<-miceadds::lm.cluster(data = database_ctt, sformula_t, cluster = "finalID")
      reg_t_pboc_c<-miceadds::lm.cluster(data = database_pboc, sformula_t, cluster = "finalID")
    
      reg_ctt_c_s<-sqrt(diag(as.matrix(reg_ctt_c$vcov)))
      reg_pboc_c_s<-sqrt(diag(as.matrix(reg_pboc_c$vcov)))
      reg_t_ctt_c_s<-sqrt(diag(as.matrix(reg_t_ctt_c$vcov)))
      reg_t_pboc_c_s<-sqrt(diag(as.matrix(reg_t_pboc_c$vcov)))
      }
  }
  
  # print(summary(reg_ctt))
  # print(summary(reg_pboc))
  # print(summary(reg_t_ctt))
  # print(summary(reg_t_pboc))
  # if(clustered==TRUE){
  #   print(summary(reg_ctt_c))
  #   print(summary(reg_pboc_c))
  #   print(summary(reg_t_ctt_c))
  #   print(summary(reg_t_pboc_c))
  # }

  print("Don't forget to change Yes, No, fot the time fixed effects")  
  if(clustered==TRUE){
  stargazer(reg_ctt, reg_t_ctt, reg_pboc, reg_t_pboc, title=tittle_table,
            align=TRUE, column.labels=c("CTT", "PBOC"), column.separate=c(2,2),
            column.sep.width="-20pt", digits=4,
            notes.label="", header=FALSE,
            omit        = "EARLIEST_FILING_YEAR",
            omit.labels = "Time fixed effects",
            omit.yes.no = c("Yes","No"),
            dep.var.labels=" ",
            dep.var.labels.include=TRUE,
            dep.var.caption="Co-invention",
            se=list(reg_ctt_c_s,reg_pboc_c_s,reg_t_ctt_c_s,reg_t_pboc_c_s),
            covariate.labels=labels_cov,
            omit.stat=c("ser","f"), no.space=TRUE)
  }
  else{
    stargazer(reg_ctt, reg_t_ctt, reg_pboc, reg_t_pboc, title=tittle_table,
              align=TRUE, column.labels=c("CTT", "PBOC"), column.separate=c(2,2),
              column.sep.width="-20pt", digits=4,
              notes.label="", header=FALSE,
              omit        = "EARLIEST_FILING_YEAR",
              omit.labels = "Time fixed effects",
              omit.yes.no = c("Yes","No"),
              dep.var.labels=" ",
              dep.var.labels.include=TRUE,
              dep.var.caption="Co-invention",
              covariate.labels=labels_cov,
              omit.stat=c("ser","f"), no.space=TRUE)
  }
  
}

formulaone<-"linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + insprox + techprox"  
labels_one<-c("Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Average centrality",
              "Abs. diff. centrality",
              "Geographic distance", 
              "Institutional proximity",
              "Technological proximity")
# Logit with clustered errors, only for the small sample
runmodels(sformula=formulaone, labels_cov=labels_one, includenas=FALSE, logit=TRUE, clustered=TRUE, flist=files.databases)

# LPM with clustered errors, only for the small sample
runmodels(sformula=formulaone, labels_cov=labels_one, includenas=FALSE, logit=FALSE, clustered=TRUE, flist=files.databases)

# Logit with clustered errors, only for the small sample
runmodels(sformula=formulaone, labels_cov=labels_one, includenas=TRUE, logit=TRUE, clustered=TRUE, flist=files.databases)
# LPM with clustered errors, only for the large sample
runmodels(sformula=formulaone, labels_cov=labels_one, includenas=TRUE, logit=FALSE, clustered=TRUE, flist=files.databases)



formula_two<-"linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis"  
labels_two<-c("Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Average centrality",
              "Abs. diff. centrality",
              "Geographic distance")

runmodels(sformula=formula_two, labels_cov=labels_two, includenas=FALSE, logit=FALSE, clustered=TRUE, flist=files.databases)

database_ctt<-as.data.table(read.csv(files.databases[1]))
database_pboc<-as.data.table(read.csv(files.databases[3]))

database_ctt_corr <- cor(database_ctt[,c("linked", "ethnic", "soc_2", "soc_3", "soc_4", "av_cent", "absdif_cent", "geodis", "insprox", "techprox")])
database_ctt_corr<-as.matrix(database_ctt_corr)
database_ctt_corr[upper.tri(database_ctt_corr, diag = TRUE)]<-NA
stargazer(database_ctt_corr[2:10,1:9], title="CTT: Correlation Matrix", column.sep.width="0pt", digits=4)


#https://stats.stackexchange.com/questions/108007/correlations-with-unordered-categorical-variables

correlation.matrix <- cor(attitude[,c("rating","complaints","privileges")])
stargazer(correlation.matrix, title="Correlation Matrix")