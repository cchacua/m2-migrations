rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')


file.df<-as.data.table(dbGetQuery(patstat, 
              "SELECT linked, ethnic, socialdist, degreecenboth, geodis, undid, EARLIEST_FILING_YEAR, insprox, counterof, CONCAT(EARLIEST_FILING_YEAR, finalID, IFNULL(counterof, ''), finalID_) AS undidcc
                  FROM riccaboni.count_edges_ctt_gsi
                  WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';"))
setkey(file.df,undid) 
table(file.df$linked)

#####################
# Delete when social distance is one, as to focus on first collaborations
#####################
  # Extract when social distance is equal one
    file_sd_1.df<-file.df[file.df$socialdist==1,]
    setkey(file_sd_1.df,undid)
  # Identify the counterfactual pairs
      # ATTENTION: THE NAME OF THE COUNTERFACTUAL IS pat
    counter<-as.data.table(dbGetQuery(patstat, 
                      "SELECT finalID, finalID_, pat, undid, CONCAT(EARLIEST_FILING_YEAR, finalID, pat) AS undidc, CONCAT(EARLIEST_FILING_YEAR, finalID, pat, finalID_) AS undidcc
                      FROM riccaboni.edges_dir_count_ctt
                      WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';"))
    
    setkey(counter,undidc)
    counter<-counter[file_sd_1.df, nomatch=0]
    
    delete<-rbind(counter[,"undidcc"],file_sd_1.df[,"undidcc"])
    setkey(delete,undidcc)
 
  # Delete when social distance is equal one
    setkey(file.df,undidcc)
    file.df<-file.df[!delete]
    rm(delete,counter, file_sd_1.df)
#####################
# Create dummies of social distance
#####################
    file.df$socialdist<-as.numeric(file.df$socialdist)
    # file.df$soc_1<-ifelse(file.df$socialdist<2, 1, 0)    
    # table(file.df$soc_1)
    # file.df[file.df$soc_1==1,]
    file.df$soc_2<-ifelse(file.df$socialdist==2, 1, 0)    
    table(file.df$soc_2)
    file.df$soc_3<-ifelse(file.df$socialdist==3, 1, 0)    
    table(file.df$soc_3)
    file.df$soc_4m<-ifelse(file.df$socialdist>3, 1, 0)    
    table(file.df$soc_4m)

#####################
# Recode geographic distance as a numeric
#####################    
    file.df$geodis<-as.numeric(file.df$geodis)
#####################
# Keep only first collaborations (create a new id without year and make the distribution of years)
#####################           
    
#####################
# Estimation
##################### 
    gc()
    # + geodis + insprox + degreecenboth
    lreg<-lm(linked ~ ethnic + soc_2 + soc_3 + degreecenboth + geodis,  data = file.df)
    summary(lreg)  
    # What should I do with the missings
    
    logitmodel <- glm(linked ~ ethnic + soc_2 + soc_3 + degreecenboth + insprox + geodis,family=binomial(link='logit'),data=file.df)
    summary(logitmodel)
    