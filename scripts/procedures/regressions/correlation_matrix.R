files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases

corr_matrix_l<-function(files=files.databases, ctt=TRUE, includenas=FALSE){
  if(ctt==TRUE){
    tittle_table<-"CTT correlation Matrix"
    if(includenas==TRUE){
      df<-as.data.frame(read.csv(files[2]))
    }
    else{
      df<-as.data.frame(read.csv(files[1]))
    }
    
  }
  else{
    tittle_table<-"PBOC correlation Matrix"
    if(includenas==TRUE){
      df<-as.data.frame(read.csv(files[4]))
    }
    else{
      df<-as.data.frame(read.csv(files[3]))
    }
  }
  # c("linked", "ethnic", "soc_2", "soc_3", "soc_4", "av_cent", "absdif_cent", "geodis", "insprox", "techprox")
  if(includenas==FALSE){
    df_corr<- cor(df[,c("linked","ethnic", 
                        "insprox","techprox",
                        "soc_2", "soc_3", 
                        "soc_4","soc_5m",
                        "absdif_cent","av_cent" ,
                        "geodis")])
    labels<-c("Co-patent",
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
  }
  else{
    df_corr<- cor(df[,c("linked","ethnic", 
                        "soc_2", "soc_3", 
                        "soc_4","soc_5m",
                        "absdif_cent","av_cent" ,
                        "geodis")])
    labels<-c("Co-patent",
              "Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Social distance = 5",
              "Abs. diff. centrality",
              "Average centrality" ,
              "Geographic distance")
  }

  
  df_corr<-as.matrix(df_corr)
  df_corr[upper.tri(df_corr, diag = FALSE)]<-NA
  
  numbers<-seq(1,ncol(df_corr), 1)
  
  rownames(df_corr)<-paste0(numbers, " - ",labels)
  colnames(df_corr)<-numbers
  stargazer(df_corr[,1:ncol(df_corr)-1], title=tittle_table,
            column.sep.width="-4pt", digits=2, align=TRUE)
  
  #https://stats.stackexchange.com/questions/108007/correlations-with-unordered-categorical-variables
  
}

# Summary, ctt, small sample
corr_matrix_l(files=files.databases, ctt=TRUE, includenas=FALSE)

# Summary, PBOC, small sample
corr_matrix_l(files=files.databases, ctt=FALSE, includenas=FALSE)

# Summary, ctt, Large sample
corr_matrix_l(files=files.databases, ctt=TRUE, includenas=TRUE)

# Summary, PBOC, Large sample
corr_matrix_l(files=files.databases, ctt=FALSE, includenas=TRUE)


database_ctt<-as.data.table(read.csv(files.databases[1]))
database_pboc<-as.data.table(read.csv(files.databases[3]))

database_ctt_corr <- cor(database_ctt[,c("linked", "ethnic", "soc_2", "soc_3", "soc_4", "av_cent", "absdif_cent", "geodis", "insprox", "techprox")])
database_ctt_corr<-as.matrix(database_ctt_corr)
database_ctt_corr[upper.tri(database_ctt_corr, diag = TRUE)]<-NA
stargazer(database_ctt_corr[2:10,1:9], title="CTT: Correlation Matrix", column.sep.width="0pt", digits=4)


#https://stats.stackexchange.com/questions/108007/correlations-with-unordered-categorical-variables
