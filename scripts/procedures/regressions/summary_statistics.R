files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases

summary_table<-function(files=files.databases, ctt=TRUE, includenas=FALSE){
  if(ctt==TRUE){
    tittle_table<-"Summary statistics for the CTT sample"
    if(includenas==TRUE){
      df<-as.data.frame(read.csv(files[2]))
    }
    else{
      df<-as.data.frame(read.csv(files[1]))
    }
    
  }
  else{
    tittle_table<-"Summary statistics for the PBOC sample"
    if(includenas==TRUE){
      df<-as.data.frame(read.csv(files[4]))
    }
    else{
      df<-as.data.frame(read.csv(files[3]))
    }
  }
  df1<-df[,c("linked","ethnic", 
             "insprox","techprox","soc_2", 
              "soc_3", "soc_4","soc_5m",
             "absdif_cent","av_cent" ,"geodis")]

  colnames(df1)<-c("Co-patent",
                   "Ethnic proximity", 
                   "Institutional proximity",
                   "Technological proximity",
                   "Social distance = 2",
                   "Social distance = 3",
                   "Social distance = 4",
                   "Social distance = 5",
                   "Abs. diff. centrality",
                   "Average centrality" ,
                   "Geographic distance")
  stargazer(df1,
  title=tittle_table,
  align=TRUE,
  column.sep.width="0pt", digits=2
  )
  
  stargazer(df1[df1[,1]==1,2:ncol(df1)],
            title=paste0(tittle_table," - observed" ),
            align=TRUE,
            column.sep.width="0pt", digits=2
  )
  
  stargazer(df1[df1[,1]==0,2:ncol(df1)],
            title=paste0(tittle_table," - counterfactual" ),
            align=TRUE,
            column.sep.width="0pt", digits=2
  )
  
}

# Summary, ctt, small sample
summary_table(files=files.databases, ctt=TRUE, includenas=FALSE)

# Summary, PBOC, small sample
summary_table(files=files.databases, ctt=FALSE, includenas=FALSE)

# Summary, ctt, Large sample
summary_table(files=files.databases, ctt=TRUE, includenas=TRUE)

# Summary, PBOC, Large sample
summary_table(files=files.databases, ctt=FALSE, includenas=TRUE)





# 
# ddf<-read.csv(files.databases[1])
# ddf1<-ddf[,c("linked","ethnic", 
#              "insprox","techprox","soc_2", 
#              "soc_3", "soc_4","soc_5m",
#              "absdif_cent","av_cent" ,"geodis")]
# ddf1$linked<-as.factor(ddf1$linked)
# summary(ddf1[,1:7])
# d<-describe(ddf1[,2:9])
# d$vars<-rownames(d)
# d<-as.data.frame(d)
# table.latex(d[,1:10], ndigits=2, brnames=FALSE)
# table.latex(summary(t06[,10:11]), ndigits=2, brnames=FALSE)