files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases


# database<-as.data.table(read.csv(files.databases[1]))
# sformula<-formulaone
# logit<-FALSE
# clustered<-TRUE
# labels_cov<-labels_one
runmodels<-function(sformula, labels_cov, ctt=TRUE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases){
  if(includenas==TRUE){
    if(ctt==TRUE){
      database<-as.data.table(read.csv(flist[2]))
    }
    else{
      database<-as.data.table(read.csv(flist[4]))
    }
  }
  else{
    if(ctt==TRUE){
      database<-as.data.table(read.csv(flist[1]))
    }
    else{
      database<-as.data.table(read.csv(flist[3]))
    }
  }
  
  database$geodis<-as.numeric(database$geodis)
  database$EARLIEST_FILING_YEAR<-factor(database$EARLIEST_FILING_YEAR)
  #write.dta(database, paste0("../output/final_tables/ctt_na",includenas,".dta"))
  
  # Attention: sformula should be a string
  if(time_fe==TRUE){
    sformula<-as.formula(paste0(sformula, " + EARLIEST_FILING_YEAR"))}
  else{
    sformula<-as.formula(sformula)
  }
  
  # ethnics<-as.character(unique(database$nation))
  # ethnics<-ethnics[order(ethnics)]
  ethnics<-c("European.EastEuropean",      
             "European.French",
             "European.German",            
             "European.Italian.Italy",
             "European.Russian", 
             "EastAsian.Chinese",
             "EastAsian.Indochina.Vietnam",
             "EastAsian.Japan",
             "EastAsian.Malay.Indonesia",  
             "EastAsian.South.Korea",
             "Muslim.Persian",
             "SouthAsian")
  ethnics_label<-c("East European",      
                   "French",
                   "German",            
                   "Italy",
                   "Russian",
                   "Chinese",
                   "Vietnam",
                   "Japan",
                   "Indonesia",  
                   "Korea",         
                   "Persian",
                   "South Asian")
  #g1<-sample_nat(ethnics[1], sformulaa=sformula, logitt=logit, clusteredd=clustered)
  mbycoo<-lapply(ethnics, sample_nat, sformulaa=sformula, logitt=logit, clusteredd=clustered, database)
  
  if(logit==TRUE){
    print(paste(round(mbycoo[[1]]$pseudo, 4), round(mbycoo[[2]]$pseudo, 4), round(mbycoo[[3]]$pseudo, 4),
                round(mbycoo[[4]]$pseudo, 4), round(mbycoo[[5]]$pseudo, 4), round(mbycoo[[6]]$pseudo, 4),
                round(mbycoo[[7]]$pseudo, 4), round(mbycoo[[8]]$pseudo, 4), round(mbycoo[[9]]$pseudo, 4),
                round(mbycoo[[10]]$pseudo, 4), round(mbycoo[[11]]$pseudo, 4), round(mbycoo[[12]]$pseudo, 4), sep = " fff "))
    print("Don't forget to change Yes, No, fot the time fixed effects")  
    
    if(ctt==TRUE){
      tittle_table<-"CTT Logit Models by CEL group, 1980-2012"
    }
    else{
      tittle_table<-"PBOC Logit Models by CEL group, 1980-2012"
    }
    }
  else{
    if(ctt==TRUE){
      tittle_table<-"CTT Linear Probability Models by CEL group, 1980-2012"
    }
    else{
      tittle_table<-"PBOC Linear Probability Models by CEL group, 1980-2012"
    }
    
  }
  
  # print(paste(paste0("Pseudo R$^[2]$  \multicolumn[1][c][",mbycoo[[1]]$pseudo), mbycoo[[2]]$pseudo, mbycoo[[3]]$pseudo,
  #              mbycoo[[4]]$pseudo, mbycoo[[5]]$pseudo, mbycoo[[6]]$pseudo,
  #              mbycoo[[7]]$pseudo, mbycoo[[8]]$pseudo, mbycoo[[9]]$pseudo,
  #              mbycoo[[10]]$pseudo, mbycoo[[11]]$pseudo, paste0(mbycoo[[12]]$pseudo, "] \\"), sep = "] &  \multicolumn[1][c]["))
  # Pseudo R$^{2}$ & \multicolumn{1}{c}{
  # } \\
  # } &  \multicolumn{1}{c}{
  
  # print(paste(mbycoo[[1]]$pseudo, mbycoo[[2]]$pseudo, mbycoo[[3]]$pseudo,
  #             mbycoo[[4]]$pseudo, mbycoo[[5]]$pseudo, mbycoo[[6]]$pseudo,
  #             mbycoo[[7]]$pseudo, mbycoo[[8]]$pseudo, mbycoo[[9]]$pseudo,
  #             mbycoo[[10]]$pseudo, mbycoo[[11]]$pseudo, mbycoo[[12]]$pseudo, sep = " fff "))
  
  

    stargazer(mbycoo[[1]]$regre, mbycoo[[2]]$regre, mbycoo[[3]]$regre,
              mbycoo[[4]]$regre, mbycoo[[5]]$regre, mbycoo[[6]]$regre,
              mbycoo[[7]]$regre, mbycoo[[8]]$regre, mbycoo[[9]]$regre,
              mbycoo[[10]]$regre, mbycoo[[11]]$regre, mbycoo[[12]]$regre,
              title=tittle_table,
              align=TRUE,
              column.sep.width="-20pt", digits=4,
              notes.label="", header=FALSE, column.labels=ethnics_label,
              omit        = "EARLIEST_FILING_YEAR",
              omit.labels = "Time fixed effects",
              omit.yes.no = c("Yes","No"),
              dep.var.labels=" ",
              dep.var.labels.include=TRUE,
              dep.var.caption="Co-invention",
              se=list(mbycoo[[1]]$se, mbycoo[[2]]$se, mbycoo[[3]]$se,
                      mbycoo[[4]]$se, mbycoo[[5]]$se, mbycoo[[6]]$se,
                      mbycoo[[7]]$se, mbycoo[[8]]$se, mbycoo[[9]]$se,
                      mbycoo[[10]]$se, mbycoo[[11]]$se, mbycoo[[12]]$se),
              covariate.labels=labels_cov,
              omit.stat=c("ser","f"), no.space=TRUE)
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

# CTT LPM, Small sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=TRUE, includenas=FALSE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)

# CTT Logit, Small sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=TRUE, includenas=FALSE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)

# PBOC LPM, Small sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=FALSE, includenas=FALSE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)

# PBOC Logit, Small sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=FALSE, includenas=FALSE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)

# CTT LPM, Large sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=TRUE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)
# PBOC LPM, Large sample, clustered
runmodels(sformula=formulaone, labels_cov=labels_one, ctt=FALSE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)


formula_two<-"linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis + techprox"  
labels_two<-c("Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Average centrality",
              "Abs. diff. centrality",
              "Geographic distance", 
              "Technological proximity")
# CTT LPM, Large sample, clustered
runmodels(sformula=formula_two, labels_cov=labels_two, ctt=TRUE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)
# PBOC LPM, Large sample, clustered
runmodels(sformula=formula_two, labels_cov=labels_two, ctt=FALSE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)


# CTT Logit, Large sample, clustered
runmodels(sformula=formula_two, labels_cov=labels_two, ctt=TRUE, includenas=TRUE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)
# PBOC Logit, Large sample, clustered
runmodels(sformula=formula_two, labels_cov=labels_two, ctt=FALSE, includenas=TRUE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)


formula_three<-"linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis"  
labels_three<-c("Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Average centrality",
              "Abs. diff. centrality",
              "Geographic distance")
# CTT LPM, Large sample, clustered
runmodels(sformula=formula_three, labels_cov=labels_three, ctt=TRUE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)
# PBOC LPM, Large sample, clustered
runmodels(sformula=formula_three, labels_cov=labels_three, ctt=FALSE, includenas=TRUE, logit=FALSE, clustered=TRUE,time_fe=TRUE, flist=files.databases)


# CTT Logit, Large sample, clustered
runmodels(sformula=formula_three, labels_cov=labels_three, ctt=TRUE, includenas=TRUE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)
# PBOC Logit, Large sample, clustered
runmodels(sformula=formula_three, labels_cov=labels_three, ctt=FALSE, includenas=TRUE, logit=TRUE, clustered=TRUE,time_fe=TRUE, flist=files.databases)

