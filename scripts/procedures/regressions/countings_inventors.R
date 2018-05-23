files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases

# ctt=TRUE
# filelist<-files.databases

counting_invs<-function(ctt=TRUE, ao=TRUE, includenas=TRUE, filelist=files.databases){
  if(ctt==TRUE){
    tfield="ctt"
  }
  else{
    tfield="pboc"
  }
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
  
  if(ao==TRUE){
    df<-as.data.table(dbGetQuery(patstat, paste0("
                    SELECT DISTINCT a.finalID_, b.nation
                    FROM riccaboni.edges_undir_pyr",tfield," a
                    INNER JOIN christian.id_nat b
                    ON a.finalID_=b.finalID
WHERE a.EARLIEST_FILING_YEAR>='1975' and a.EARLIEST_FILING_YEAR<='2012'
                    UNION ALL 
                    SELECT DISTINCT c.finalID__, d.nation
                    FROM riccaboni.edges_undir_pyr",tfield," c
                    INNER JOIN christian.id_nat d
                    ON c.finalID__=d.finalID
WHERE c.EARLIEST_FILING_YEAR>='1975' and c.EARLIEST_FILING_YEAR<='2012'
")))
    df<-unique(df)
  }
  else{
    if(tfield=="ctt"){
      if(includenas==TRUE){
        df<-as.data.table(read.csv(filelist[2]))
        df<-unique(df[,c("finalID", "nation")])
      }
      else{
        df<-as.data.table(read.csv(filelist[1]))
        # df<- df[df$linked==1,]
        # df$finalID<-as.character(df$finalID)
        # df$nation<-as.character(df$nation)
        df<-unique(df[,c("finalID", "nation")])
        # df<-unique(df)
      }
    }
    else{
      if(includenas==TRUE){
        df<-as.data.table(read.csv(filelist[4]))
        df<-unique(df[,c("finalID", "nation")])
      }
      else{
        df<-as.data.table(read.csv(filelist[3]))
        df<-unique(df[,c("finalID", "nation")])
      }
    }
  }

  df$nation<-as.factor(df$nation)
  results<-as.data.frame(prop.table(table(df$nation)))
  results$Var1<-as.character(results$Var1)
  results<-results[order(results$Freq, decreasing = TRUE),]
  results<-results[results$Var1 %in% ethnics,]
  results[nrow(results) + 1,] = c("Celtic English and others",(1-sum(results$Freq)))
  results$percentage<-as.numeric(results$Freq)*100
  totalinv<-nrow(df)
  return(list(res=results, total=totalinv))
 }

ctt_ao_fulls<-counting_invs(ctt=TRUE, ao=TRUE, includenas=TRUE, filelist=files.databases)
pboc_ao_fulls<-counting_invs(ctt=FALSE, ao=TRUE, includenas=TRUE, filelist=files.databases)

m1<-cbind(ctt_ao_fulls$res[order(ctt_ao_fulls$res$Var1),c(1,3)], pboc_ao_fulls$res[order(pboc_ao_fulls$res$Var1),3])
m1$Var1<-gsub("([a-z])([A-Z])", "\\1 \\2", m1$Var1)
m1$Var1<-gsub("\\.", " - ", m1$Var1)
colnames(m1)<-c("CEL group", "CTT", "PBOC")
m1<-m1[order(m1$CTT, decreasing = TRUE),]

print(paste0("Total number of inventors: ",ctt_ao_fulls$total," in the CTT and ", pboc_ao_fulls$total, " in the PBOC field."))
print("Total & 100.0000 & 100.0000 \\")

table.latex (m1, ndigits=4, tcaption="Inventors by ethnic group and technological fields, partial-US-based teams, 1975-2012", tlabel="table-inv-count-ao", brnames=FALSE)

# stargazer(m1, summary=FALSE, align=TRUE,
#           column.sep.width="0pt", digits=4)


ctt_all_fulls<-counting_invs(ctt=TRUE, ao=FALSE, includenas=TRUE, filelist=files.databases)
pboc_all_fulls<-counting_invs(ctt=FALSE, ao=FALSE, includenas=TRUE, filelist=files.databases)

m2<-cbind(ctt_all_fulls$res[order(ctt_all_fulls$res$Var1),c(1,3)], pboc_all_fulls$res[order(pboc_all_fulls$res$Var1),3])
m2$Var1<-gsub("([a-z])([A-Z])", "\\1 \\2", m2$Var1)
m2$Var1<-gsub("\\.", " - ", m2$Var1)
colnames(m2)<-c("CEL group", "CTT", "PBOC")
m2<-m2[order(m2$CTT, decreasing = TRUE),]
m2<-m2[1:12,]
print(paste0("Total number of inventors: ",ctt_all_fulls$total," in the CTT and ", pboc_all_fulls$total, " in the PBOC field."))

table.latex (m2, ndigits=4, tcaption="Inventors by ethnic group and technological fields, final sample, 1975-2012", tlabel="table-inv-count-finalsample", brnames=FALSE)



results$Nationalities<-gsub("([a-z])([A-Z])", "\\1 \\2", results$Var1)
results$Nationalities<-gsub("\\.", " - ", results$Nationalities)

stargazer(results, summary=FALSE, align=TRUE,
          column.sep.width="0pt", digits=4)

table.latex (results[,c(1,3)], ndigits=4, tcaption="Number of inventors", tlabel="table-inv-count", brnames=FALSE)
