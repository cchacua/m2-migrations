files.databases<-list.files(path="../output/final_tables/test2", full.names=TRUE)
files.databases

flist<-files.databases
labels_cov<-labels_two
sformula<-formula_two


runmodels<-function(sformula, labels_cov, includenas=TRUE, logit=FALSE, clustered=TRUE, flist=files.databases, ctt=TRUE){
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
  #write.dta(database, paste0("../output/final_tables/ctt_na_TRUE.dta"))
  #write.dta(database, paste0("../output/final_tables/pboc_na_TRUE.dta"))
  
  
  
  # Attention: sformula should be a string
  sformula_t<-as.formula(paste0(sformula, " + EARLIEST_FILING_YEAR"))
  sformula<-as.formula(sformula)
  
  if(logit==TRUE){
    tittle_table<-"Logit Models, 1980-2012"
    #reg<-glm(sformula, family=binomial(link='logit'), data = database)
    #reg_t<-glm(sformula_t, family=binomial(link='logit'), data = database)

    #print(paste("Pseudo-R2", logit_pseudor2(reg), logit_pseudor2(reg_pboc), 
     #           logit_pseudor2(reg_t), paste0(logit_pseudor2(reg_t_pboc), " \\"), sep = " & "))
    
    if(clustered==TRUE){
      reg_t<-miceadds::glm.cluster(data = database, sformula_t, cluster = "finalID", family=binomial(link='logit'))
      # reg_t_c_s<-sqrt(diag(as.matrix(reg_t_c$vcov)))
    }
  }
  else{
    tittle_table<-"Linear Probability Models, 1980-2012"
    reg_t<-lm(sformula_t, data = database)
    if(clustered==TRUE){
      reg_t_c<-miceadds::lm.cluster(data = database, sformula_t, cluster = "finalID")
      reg_t_c_s<-sqrt(diag(as.matrix(reg_t_c$vcov)))
    }
  }
  summary(reg_t)
  wald.test(b = coef(reg_t), Sigma = as.matrix(reg_t_c$vcov), Terms = 3:5)
  
  
  # print(summary(reg))
  # print(summary(reg_pboc))
  # print(summary(reg_t))
  # print(summary(reg_t_pboc))
  # if(clustered==TRUE){
  #   print(summary(reg_c))
  #   print(summary(reg_pboc_c))
  #   print(summary(reg_t_c))
  #   print(summary(reg_t_pboc_c))
  # }
  
  print("Don't forget to change Yes, No, fot the time fixed effects")  
  
  return(reg_t)
  
}
formula_two<-"linked ~ ethnic + soc_2 + soc_3 + soc_4 + av_cent + absdif_cent + geodis"  
labels_two<-c("Ethnic proximity",
              "Social distance = 2",
              "Social distance = 3",
              "Social distance = 4",
              "Average centrality",
              "Abs. diff. centrality",
              "Geographic distance")

# Logit with clustered errors, only for the large sample
logitlarge_ctt<-runmodels(sformula=formula_two, labels_cov=labels_two, includenas=FALSE, logit=TRUE, clustered=TRUE, flist=files.databases, ctt=TRUE)
data1<-logitlarge_ctt[[1]]$data
effects_logit= margins(logitlarge_ctt, logitlarge_ctt$data) 

##
database<-as.data.table(read.csv(flist[2]))
database$geodis<-as.numeric(as.character(database$geodis))
database$EARLIEST_FILING_YEAR<-factor(database$EARLIEST_FILING_YEAR)
database$soc<-database$socialdist
database$soc[database$soc>4]<-"0"
table(database$soc)
database$soc<-factor(database$soc)
#reg_t<-miceadds::glm.cluster(data = database, linked ~ ethnic + soc + av_cent + absdif_cent + geodis + EARLIEST_FILING_YEAR, cluster = "finalID", family=binomial(link='logit'))
reg_t<-glm(linked ~ ethnic + soc + av_cent + absdif_cent + geodis + EARLIEST_FILING_YEAR, family=binomial(link="logit"), data = database)
summary(reg_t)
newdata2 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each = 33)))), 
                                      soc = factor(rep(c(0,2,3,4), each = 66)),
                                      av_cent=mean(av_cent),
                                      absdif_cent=mean(absdif_cent), 
                                      geodis=mean(geodis),
                                      EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 1))
                                      ))
newdata2 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165)))), 
                                      soc = 2,
                                      av_cent=mean(av_cent),
                                      absdif_cent=mean(absdif_cent), 
                                      geodis=rep(seq(from = 0, to = 25, length.out = 5),66),
                                      EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 5))
))

#newdata2 <- with(mydata, data.frame(gre = , gpa = mean(gpa), rank = factor(rep(1:4, each = 100))))

newdata3 <- cbind(newdata2, predict(reg_t, newdata = newdata2, type = "link", se = TRUE))
newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (1.96 * se.fit))
  UL <- plogis(fit + (1.96 * se.fit))
})
newdata3_<-unique(newdata3[,c("PredictedProb","soc", "ethnic")])
newdata3_$ethnic<-as.factor(newdata3_$ethnic)
newdata3_$soc<-as.numeric(as.character(newdata3_$soc))
newdata3_$soc[newdata3_$soc==0]<-5

ggplot(newdata3_, aes(x = soc, y = PredictedProb)) + geom_line(aes(colour = ethnic), size = 1)


# Remember 0 is for social distance =5
newdata2 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165*2)))), 
                                      soc = as.factor(c(0,2)),
                                      av_cent=mean(av_cent),
                                      absdif_cent=mean(absdif_cent), 
                                      geodis=rep(seq(from = 0, to = 25, length.out = 5),66*2),
                                      EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 10))
))

newdata21 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165)))), 
                                      soc = as.factor(0),
                                      av_cent=mean(av_cent),
                                      absdif_cent=mean(absdif_cent), 
                                      geodis=rep(seq(from = 0, to = 25, length.out = 5),66),
                                      EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 5))
))

newdata22 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165)))), 
                                       soc = as.factor(3),
                                       av_cent=mean(av_cent),
                                       absdif_cent=mean(absdif_cent), 
                                       geodis=rep(seq(from = 0, to = 25, length.out = 5),66),
                                       EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 5))
))

newdata2<-rbind(newdata21,newdata22)

predict.rob <- function(x,clcov,newdata){
  if(missing(newdata)){ newdata <- x$model }
  m.mat <- model.matrix(x$terms,data=newdata)
  m.coef <- x$coef
  fit <- as.vector(m.mat %*% x$coef)
  se.fit <- sqrt(diag(m.mat%*%clcov%*%t(m.mat)))
  return(list(fit=fit,se.fit=se.fit))
}

#newdata3 <- cbind(newdata2, predict(reg_t, newdata = newdata2, type = "link", se = TRUE))
newdata3 <- cbind(newdata2, predict(reg_t2, newdata = newdata2, type = "link", se = TRUE))


newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (1.96 * se.fit))
  UL <- plogis(fit + (1.96* se.fit))
})
#
# 2.576
newdata3_<-unique(newdata3[newdata3$EARLIEST_FILING_YEAR==2000,c("PredictedProb","geodis", "ethnic", "soc", "LL","UL")])
newdata3_$ethnic<-as.numeric(as.character(newdata3_$ethnic))

newdata3_$ethnic[newdata3_$ethnic==0]<-"$e_{ij}=0$"
newdata3_$ethnic[newdata3_$ethnic!="$e_{ij}=0$"]<-"$e_{ij}=1$"
newdata3_$ethnic<-as.factor(newdata3_$ethnic)
newdata3_$soc<-as.numeric(as.character(newdata3_$soc))
newdata3_$soc[newdata3_$soc==0]<-"$s_{ij}>4$"
newdata3_$soc[newdata3_$soc!="$s_{ij}>4$"]<-"$s_{ij}=3$"
newdata3_$soc<-factor(newdata3_$soc)
tikz(file = "../output/graphs/plots/socialdis_ctt.tex", width = 5.5, height = 2)
#Simple plot of the dummy data using LaTeX elements
measure.plot<-ggplot(newdata3_, aes(x = geodis, y = PredictedProb)) + 
  scale_color_aaas() + theme_bw()  + 
  geom_ribbon(aes(ymin = LL,
                  ymax = UL, fill = ethnic), alpha = 1) +
  geom_line(aes(colour = ethnic), size = 0.3) +
  theme(legend.title=element_blank()) + facet_grid(. ~ soc) +ylab("Predicted Prob.") + xlab("Geographic distance")
  
measure.plot
  #ggplot(sizes, aes(Year, Measure, colour=type)) + scale_color_aaas() + theme_bw() + geom_line(size=1)+ geom_point(size=2)+xlab("Year") + ylab(legend.t) + scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) + theme(legend.title=element_blank())
#print(measure.plot)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()

###########################
database<-as.data.table(read.csv(files.databases[4]))
database$geodis<-as.numeric(as.character(database$geodis))
database$EARLIEST_FILING_YEAR<-factor(database$EARLIEST_FILING_YEAR)
database$soc<-database$socialdist
database$soc[database$soc>4]<-"0"
table(database$soc)
database$soc<-factor(database$soc)
reg_t<-glm(linked ~ ethnic + soc + av_cent + absdif_cent + geodis + EARLIEST_FILING_YEAR, family=binomial(link="logit"), data = database)
summary(reg_t)

newdata21 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165)))), 
                                       soc = as.factor(0),
                                       av_cent=mean(av_cent),
                                       absdif_cent=mean(absdif_cent), 
                                       geodis=rep(seq(from = 0, to = 25, length.out = 5),66),
                                       EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 5))
))

newdata22 <- with(database, data.frame(ethnic=as.numeric(as.character(factor(rep(0:1, each =165)))), 
                                       soc = as.factor(4),
                                       av_cent=mean(av_cent),
                                       absdif_cent=mean(absdif_cent), 
                                       geodis=rep(seq(from = 0, to = 25, length.out = 5),66),
                                       EARLIEST_FILING_YEAR=factor(rep(1980:2012, each = 5))
))

newdata2<-rbind(newdata21,newdata22)
newdata3 <- cbind(newdata2, predict(reg_t, newdata = newdata2, type = "link", se = TRUE))
# newdata3 <- within(newdata3, {
#   PredictedProb <- plogis(fit)
#   LL <- plogis(fit - (1.96 * se.fit))
#   UL <- plogis(fit + (1.96 * se.fit))
# })
newdata3 <- within(newdata3, {
  PredictedProb <- plogis(fit)
  LL <- plogis(fit - (2.576 * se.fit))
  UL <- plogis(fit + (2.576 * se.fit))
})

newdata3_<-unique(newdata3[newdata3$EARLIEST_FILING_YEAR==2000,c("PredictedProb","geodis", "ethnic", "soc", "LL","UL")])
newdata3_$ethnic<-as.numeric(as.character(newdata3_$ethnic))

newdata3_$ethnic[newdata3_$ethnic==0]<-"$e_{ij}=0$"
newdata3_$ethnic[newdata3_$ethnic!="$e_{ij}=0$"]<-"$e_{ij}=1$"
newdata3_$ethnic<-as.factor(newdata3_$ethnic)
newdata3_$soc<-as.numeric(as.character(newdata3_$soc))
newdata3_$soc[newdata3_$soc==0]<-"$s_{ij}>4$"
newdata3_$soc[newdata3_$soc!="$s_{ij}>4$"]<-"$s_{ij}=3$"
newdata3_$soc<-factor(newdata3_$soc)

# newdata3_<-unique(newdata3[,c("PredictedProb","geodis", "ethnic", "soc")])
# newdata3_$ethnic<-as.numeric(as.character(newdata3_$ethnic))
# 
# newdata3_$ethnic[newdata3_$ethnic==0]<-"Non Ethnic"
# newdata3_$ethnic[newdata3_$ethnic!="Non Ethnic"]<-"Ethnic"
# newdata3_$ethnic<-as.factor(newdata3_$ethnic)
# newdata3_$soc<-as.numeric(as.character(newdata3_$soc))
# newdata3_$soc[newdata3_$soc==0]<-"s=5"
# newdata3_$soc[newdata3_$soc!="s=5"]<-"s=3"
# newdata3_$soc<-factor(newdata3_$soc)
tikz(file = "../output/graphs/plots/socialdis_pboc.tex", width = 5.5, height = 2)
#Simple plot of the dummy data using LaTeX elements
# measure.plot<-ggplot(newdata3_, aes(x = geodis, y = PredictedProb)) + 
#   scale_color_aaas() + theme_bw()  + 
#   geom_line(aes(colour = ethnic), size = 1) +
#   theme(legend.title=element_blank()) + facet_grid(. ~ soc) +ylab("Predicted Prob.") + xlab("Geographic distance")
# #measure.plot
measure.plot<-ggplot(newdata3_, aes(x = geodis, y = PredictedProb)) + 
  scale_color_aaas() + theme_bw()  + 
  geom_ribbon(aes(ymin = LL,
                  ymax = UL, fill = ethnic), alpha = 1) +
  geom_line(aes(colour = ethnic), size = 0.5) +
  theme(legend.title=element_blank()) + facet_grid(. ~ soc) +ylab("Predicted Prob.") + xlab("Geographic distance")

#ggplot(sizes, aes(Year, Measure, colour=type)) + scale_color_aaas() + theme_bw() + geom_line(size=1)+ geom_point(size=2)+xlab("Year") + ylab(legend.t) + scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) + theme(legend.title=element_blank())
print(measure.plot)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()

# LPM with clustered errors, only for the large sample
lpmlarge_ctt<-runmodels(sformula=formula_two, labels_cov=labels_two, includenas=TRUE, logit=FALSE, clustered=TRUE, flist=files.databases, ctt=TRUE)
