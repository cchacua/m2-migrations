# Graph a measure for all years, taking a list with networks files

transitivity_onerow<-function(x){
  net<-open.rdata(x)
  year<-sub("_+(.*)","",sub("+(.*)-","",x))
  Measure.out<-transitivity(net, type="global")
  w<-c(Year=year,Measure=Measure.out)
}

graphtransitivity.years<-function(){
  list_ctt<-list.files(path="../output/graphs/networks/ctt", full.names=TRUE)
  list_pboc<-list.files(path="../output/graphs/networks/pboc", full.names=TRUE)
  sizes_ctt<-as.data.frame(t(as.data.frame(lapply(list_ctt, transitivity_onerow))))
  sizes_ctt$type<-"CTT"
  sizes_pboc<-as.data.frame(t(as.data.frame(lapply(list_pboc, transitivity_onerow))))
  sizes_pboc$type<-"PBOC"
  sizes<-rbind(sizes_ctt, sizes_pboc)
  rownames(sizes)<-seq(1, nrow(sizes), 1)
  sizes$Measure<-as.numeric(as.character(sizes$Measure))
  sizes$Year<-as.numeric(as.character(sizes$Year))
  legend.t<-"Value"
  tikz(file = "../output/graphs/plots/global_transitivity.tex", width = 4, height = 2)
  #Simple plot of the dummy data using LaTeX elements
  measure.plot<-ggplot(sizes, aes(Year, Measure, colour=type)) + scale_color_aaas() + theme_bw() + geom_line(size=1)+ geom_point(size=2)+xlab("Year") + ylab(legend.t) + scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) + theme(legend.title=element_blank())
  print(measure.plot)
  #Necessary to close or the tikxDevice .tex file will not be written
  dev.off()
  
  # "#FFFFFF" + theme(legend.position="none") 
  ggsave(paste0("../output/graphs/plots/global_transitivity.png", sep=""), plot = measure.plot, device = "png",
         scale = 1, width = 4, height = 2, units = "in",
         dpi = 300, limitsize = TRUE) 
}

graphtransitivity.years()


# Clustering coefficient for particular nodes
graph.clustering<-function(list, name="network"){
  clustering<-lapply(list,function(x){
    y<-open.rdata(x)
    year<-y$Year
    net<-y$Network
    net<-as.undirected(net, mode="collapse")
    local<-transitivity(net,  vids ="FRA20" ,type="local")
    averagecl<-transitivity(net,type="average")
    global<-transitivity(net, type="global")
    
    localw<-transitivity(net,  vids ="FRA20" ,type="weighted")
    
    localwall<-transitivity(net,type="weighted")
    localwall<-as.data.frame(localwall)
    localwall$values<-ifelse(localwall$localwall==Inf, NA, localwall$localwall)
    localwall$values<-ifelse(localwall$localwall>=1, 1, localwall$localwall)
    localwall<-mean(localwall$values, na.rm =TRUE)
    
    print(year)
    w<-c(Year=year,Local=local, Average=averagecl, Global=global, Local_W=localw,Average_W=localwall )
  })
  clustering<-as.data.frame(clustering)
  clustering<-t(clustering)
  clustering<-as.data.frame(clustering)
  #rownames(clustering)<-clustering$Year
  clustering<- melt(clustering, id="Year")
  write.csv(clustering, paste0("../outputs/clustering/clustering_",name,".csv", sep=""))
  
  clustering.graph<-ggplot(data=clustering, aes(x=Year, y=value, group=variable, color=variable)) + geom_line() + geom_point()+ylab("Clustering coefficient")+ guides(fill=guide_legend(title=NULL))+scale_x_continuous(minor_breaks = seq(2000 , 2014, 1), breaks = seq(2000 , 2014, 5))
  
  ggsave(paste0("../outputs/clustering/clustering.",name, ".png", sep=""), plot = clustering.graph, device = "png",
         scale = 1, width = 10, height = 5, units = "cm",
         dpi = 300, limitsize = TRUE) 
}    

# Communities
comm.newman<-function(list, typenet){
  communities.list<-lapply(list,function(x){
    y<-open.rdata(x)
    year<-y$Year
    print(year)
    net<-y$Network
    community<-cluster_edge_betweenness(net, weights = E(net)$weight)
    save(x, file=paste0("../outputs/communities/newman/",typenet,"_",year,".RData"))
    community
  })
  communities.list
} 

########################################################################

estimate_assort<-function(x, degree=FALSE, nationa=nationalities, cel=TRUE ){
  # y<-open.rdata(list_ctt[20])
  # nationa<-nationalities
  
  y<-open.rdata(x)
  if(degree==TRUE){
    w<-assortativity_degree(y, directed = FALSE)
  }
  else{
    #list.vertex.attributes(y)
    n1<-as.data.table(V(y)$name)
    setkey(n1,V1)
    setkey(nationa,finalID)
    n2<-nationa[n1, nomatch=0]
    n2$nation<-as.factor(as.character(n2$nation))
    V(y)$nation <- n2$nation
    if(cel==FALSE){
      w<-assortativity_nominal(y, V(y)$nation, directed=F)
    }
   else{
     n3<-as.data.table(n2[n2$nation=="Others",])
     n3$finalID<-as.character(n3$finalID)
     y_<-y - V(y)[V(y)$name %in% n3$finalID]
     w<-assortativity_nominal(y_, V(y_)$nation, directed=F)
     #unique(V(y_)$nation)
   }
  }
  year<-sub("_+(.*)","",sub("+(.*)-","",x))
  print(paste(w,year))
  c(w, year)
}

lis_to_df<-function(lista){
  df<-as.data.frame(lista)
  df<-t(df)
  df<-as.data.frame(df)
  colnames(df)<-c("Value", "Year")
  rownames(df)<-df$Year
  df$Value<-as.numeric(as.character(df$Value))
  df$Year<-as.numeric(as.character(df$Year))
  return(df)
}

# Graph assortativity
graph.assortativity<-function(){
  list_ctt<-list.files(path="../output/graphs/networks/ctt", full.names=TRUE)
  list_pboc<-list.files(path="../output/graphs/networks/pboc", full.names=TRUE)
  nationalities<-as.data.table(dbGetQuery(patstat, paste0("
                    SELECT DISTINCT a.finalID, a.nation
                    FROM christian.id_nat a")))
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
             "SouthAsian",
             "CelticEnglish")
  nationalities$nation[(!nationalities$nation %in% ethnics)]<-"Others"
  # nationalities$nation[nationalities$nation %in% c("European.EastEuropean",      
  #                                                  "European.French",
  #                                                  "European.German",            
  #                                                  "European.Italian.Italy",
  #                                                  "European.Russian")]<-"European"
  # nationalities$nation[nationalities$nation %in% c("EastAsian.Chinese",
  #                                                  "EastAsian.Indochina.Vietnam",
  #                                                  "EastAsian.Japan",
  #                                                  "EastAsian.Malay.Indonesia",  
  #                                                  "EastAsian.South.Korea")]<-"EastAsian"
  # 
  a_ctt<-lapply(list_ctt,estimate_assort, degree=FALSE, nationa=nationalities, cel=TRUE)
  a_ctt<-lis_to_df(a_ctt)
  a_ctt$type<-"CTT"
  
  a_pboc<-lapply(list_pboc,estimate_assort, degree=FALSE, nationa=nationalities, cel=TRUE)
  a_pboc<-lis_to_df(a_pboc)
  a_pboc$type<-"PBOC"

  sizes_a<-rbind(a_ctt, a_pboc)
  sizes_a$sample<-"12 CEL"
  
  a_ctt_a<-lapply(list_ctt,estimate_assort, degree=FALSE, nationa=nationalities, cel=FALSE)
  a_ctt_a<-lis_to_df(a_ctt_a)
  a_ctt_a$type<-"CTT"
  
  a_pboc_a<-lapply(list_pboc,estimate_assort, degree=FALSE, nationa=nationalities, cel=FALSE)
  a_pboc_a<-lis_to_df(a_pboc_a)
  a_pboc_a$type<-"PBOC"
  
  sizes_b<-rbind(a_ctt_a, a_pboc_a)
  sizes_b$sample<-"ALL"
  
  sizes<-rbind(sizes_a, sizes_b)
  rownames(sizes)<-seq(1, nrow(sizes), 1)
  legend.t<-"Assortativity"
  
  tikz(file = "../output/graphs/plots/assortativity.tex",  width = 4.2, height = 2)
  #  tikz(file = "../output/graphs/plots/assortativity.tex", width = 5.5, height = 2)

  #Simple plot of the dummy data using LaTeX elements
  measure.plot<-ggplot(sizes, aes(Year, Value, group=sample)) +
    #measure.plot<-ggplot(sizes, aes(Year, Value, colour=sample)) +
    scale_color_aaas() + theme_bw() + 
    geom_line(size=0.3, aes(linetype=sample, color=sample)) +
    geom_point(size=0.6, aes(shape=sample, color=sample))+
    # measure.plot<-ggplot(sizes, aes(Year, Value, colour=sample)) +
    # scale_color_aaas() + theme_bw() + geom_line(size=0.3) +
    # geom_point(size=0.5)+
    xlab("Year") + ylab(legend.t) +
    scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) +
    theme(legend.title=element_blank()) + facet_grid(. ~ type)
  print(measure.plot)
  #Necessary to close or the tikxDevice .tex file will not be written
  dev.off()
  
  # "#FFFFFF" + theme(legend.position="none") 
  ggsave(paste0("../output/graphs/plots/assortativity.png", sep=""), plot = measure.plot, device = "png",
         scale = 1, width = 5.5, height = 2, units = "in",
         dpi = 300, limitsize = TRUE) 
}

graph.assortativity()

########################################################################
# Assortativity example
df1<-data.frame(f=c("a", "b", "c", "c", "d", "d", "e"), t=c("b", "c", "a", "d", "e", "f", "f"))
df_p<-data.frame(n=c("a", "b", "c","d", "e", "f"), p1=c(1,1,1,2,2,2), p2=c(1,2,1,1,2,2), p3=c(1,2,3,4,5,6))

g1<-graph_from_data_frame(df1, directed = FALSE, vertices = df_p)
list.vertex.attributes(g1)  

assortativity_nominal(g1, V(g1)$p1, directed = FALSE)
assortativity_nominal(g1, V(g1)$p2, directed = FALSE)
assortativity_nominal(g1, V(g1)$p3, directed = FALSE)
#0.7142857
#0.3
#-0.2098765

tikz(file = "../output/graphs/plots/exampleassort.tex", width = 5.5, height = 2)
#Simple plot of the dummy data using LaTeX elements
par(mfrow=c(1,2))
plot(g1, vertex.color=V(g1)$p1,  vertex.size=40, vertex.label="")
plot(g1, vertex.color=V(g1)$p2, ,  vertex.size=40, vertex.label="")
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()


########################################################################
estimate_avecentra<-function(x, nationa=nationalities, cel=TRUE ){
  # y<-open.rdata(list_ctt[20])
  # nationa<-nationalities
  
  y<-open.rdata(x)

    #list.vertex.attributes(y)
    n1<-as.data.table(V(y)$name)
    setkey(n1,V1)
    setkey(nationa,finalID)
    n2<-nationa[n1, nomatch=0]
    n2$nation<-as.factor(as.character(n2$nation))
    V(y)$nation <- n2$nation
    if(cel==FALSE){
      n3<-as.data.table(n2[n2$nation=="Others",])
      n3$finalID<-as.character(n3$finalID)
      w<-degree(y, v=V(y)[V(y)$name %in% n3$finalID])
      #w<-degree(y)
    }
    else{
      n3<-as.data.table(n2[n2$nation!="Others",])
      n3$finalID<-as.character(n3$finalID)
      #y_<-y - V(y)[V(y)$name %in% n3$finalID]
      w<-degree(y, v=V(y)[V(y)$name %in% n3$finalID])
      #unique(V(y_)$nation)
    }
    w<-as.data.frame(w)
    w<-sum(w[1])/nrow(w)
    
  year<-sub("_+(.*)","",sub("+(.*)-","",x))
  print(paste(year, w))
  c(w, year)
}


# Graph Average degree centrality
graph.avecentra<-function(){
  list_ctt<-list.files(path="../output/graphs/networks/ctt", full.names=TRUE)
  list_pboc<-list.files(path="../output/graphs/networks/pboc", full.names=TRUE)
  nationalities<-as.data.table(dbGetQuery(patstat, paste0("
                                                          SELECT DISTINCT a.finalID, a.nation
                                                          FROM christian.id_nat a")))
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
  nationalities$nation[(!nationalities$nation %in% ethnics)]<-"Others"
  
  a_ctt<-lapply(list_ctt,estimate_avecentra, nationa=nationalities, cel=TRUE)
  a_ctt<-lis_to_df(a_ctt)
  a_ctt$type<-"CTT"
  
  a_pboc<-lapply(list_pboc,estimate_avecentra, nationa=nationalities, cel=TRUE)
  a_pboc<-lis_to_df(a_pboc)
  a_pboc$type<-"PBOC"
  
  sizes_a<-rbind(a_ctt, a_pboc)
  sizes_a$sample<-"12 CEL"
  
  a_ctt_a<-lapply(list_ctt,estimate_avecentra, nationa=nationalities, cel=FALSE)
  a_ctt_a<-lis_to_df(a_ctt_a)
  a_ctt_a$type<-"CTT"
  
  a_pboc_a<-lapply(list_pboc,estimate_avecentra, nationa=nationalities, cel=FALSE)
  a_pboc_a<-lis_to_df(a_pboc_a)
  a_pboc_a$type<-"PBOC"
  
  sizes_b<-rbind(a_ctt_a, a_pboc_a)
  sizes_b$sample<-"Other CEL"
  
  sizes<-rbind(sizes_a, sizes_b)
  rownames(sizes)<-seq(1, nrow(sizes), 1)
  legend.t<-"Average degree"
  tikz(file = "../output/graphs/plots/average_degree.tex",  width = 4.2, height = 2)
  #tikz(file = "../output/graphs/plots/average_degree.tex", width = 5.5, height = 2)
  #Simple plot of the dummy data using LaTeX elements
  measure.plot<-ggplot(sizes, aes(Year, Value, group=sample)) +
    #measure.plot<-ggplot(sizes, aes(Year, Value, colour=sample)) +
    scale_color_aaas() + theme_bw() + 
    geom_line(size=0.3, aes(linetype=sample, color=sample)) +
    geom_point(size=0.6, aes(shape=sample, color=sample))+
    xlab("Year") + ylab(legend.t) +
    scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) +
    theme(legend.title=element_blank()) + facet_grid(. ~ type)
  print(measure.plot)
  #Necessary to close or the tikxDevice .tex file will not be written
  dev.off()
  
  # "#FFFFFF" + theme(legend.position="none") 
  ggsave(paste0("../output/graphs/plots/average_degree.png", sep=""), plot = measure.plot, device = "png",
         scale = 1, width = 5.5, height = 2, units = "in",
         dpi = 300, limitsize = TRUE) 
}

graph.avecentra()

########################################################################

estimate_topcentrality<-function(x, nationa=nationalities, onlytop=TRUE){
  # y<-open.rdata(list_ctt[20])
  # nationa<-nationalities
  
  y<-open.rdata(x)
  
  #list.vertex.attributes(y)
  n1<-as.data.table(V(y)$name)
  setkey(n1,V1)
  setkey(nationa,finalID)
  n2<-nationa[n1, nomatch=0]
  n2$nation<-as.factor(as.character(n2$nation))
  V(y)$nation <- n2$nation

  w<-degree(y)

  w<-as.data.frame(w)
  w$finalID<-rownames(w)
  w<-as.data.table(w)
  setkey(w,finalID)
  n3<-nationa[w, nomatch=0]
  n3<-n3[order(n3$w, decreasing=TRUE),]
  if(onlytop==TRUE){
    n3<-n3[1:(nrow(n3)/10),]
  }
  n4<-n3[n3$nation!="Others",]
  # percentage<- 10
  # n3<-n3[n3$w > quantile(n3$w,prob=1-percentage/100),]
  # table(n3$nation)
  # print(colnames(n3))
  # print(head(n3))
  w<-nrow(n4)/nrow(n3)*100
  year<-sub("_+(.*)","",sub("+(.*)-","",x))
  print(paste(year, w))
  c(w, year)
}

# Graph Average degree centrality
graph.topcentrality<-function(){
  list_ctt<-list.files(path="../output/graphs/networks/ctt", full.names=TRUE)
  list_pboc<-list.files(path="../output/graphs/networks/pboc", full.names=TRUE)
  nationalities<-as.data.table(dbGetQuery(patstat, paste0("
                                                          SELECT DISTINCT a.finalID, a.nation
                                                          FROM christian.id_nat a")))
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
  nationalities$nation[(!nationalities$nation %in% ethnics)]<-"Others"

  a_ctt<-lapply(list_ctt,estimate_topcentrality, nationa=nationalities)
  a_ctt<-lis_to_df(a_ctt)
  a_ctt$type<-"CTT Top 10"
  
  a_pboc<-lapply(list_pboc,estimate_topcentrality, nationa=nationalities)
  a_pboc<-lis_to_df(a_pboc)
  a_pboc$type<-"PBOC Top 10"
  
  sizes1<-rbind(a_ctt, a_pboc)
  
  b_ctt<-lapply(list_ctt,estimate_topcentrality, nationa=nationalities, onlytop=FALSE)
  b_ctt<-lis_to_df(b_ctt)
  b_ctt$type<-"CTT all"
  
  b_pboc<-lapply(list_pboc,estimate_topcentrality, nationa=nationalities, onlytop=FALSE)
  b_pboc<-lis_to_df(b_pboc)
  b_pboc$type<-"PBOC all"
  
  sizes2<-rbind(b_ctt, b_pboc)
  
  sizes<-rbind(sizes1,sizes2)
  rownames(sizes)<-seq(1, nrow(sizes), 1)
  legend.t<-"Percentage share"
  tikz(file = "../output/graphs/plots/top_cent.tex", width = 4.2, height = 2)
  # tikz(file = "../output/graphs/plots/top_cent.tex", width = 5.5, height = 2)
  
  #Simple plot of the dummy data using LaTeX elements
  measure.plot<-ggplot(sizes, aes(Year, Value, group=type)) +
    #measure.plot<-ggplot(sizes, aes(Year, Value, colour=type)) +
    scale_color_aaas() + theme_bw() + 
    geom_line(size=0.6, aes(linetype=type, color=type)) +
    geom_point(size=1, aes(shape=type, color=type)) +
    #geom_line(size=0.6) + geom_point(size=1)+
    xlab("Year") + ylab(legend.t) +
    scale_x_continuous(minor_breaks = seq(1979 , 2013, 5), breaks = seq(1979 , 2013, 10)) +
    theme(legend.title=element_blank()) 
  # + facet_grid(. ~ sample)
  print(measure.plot)
  #Necessary to close or the tikxDevice .tex file will not be written
  dev.off()
  
  # "#FFFFFF" + theme(legend.position="none") 
  ggsave(paste0("../output/graphs/plots/top_cent.png", sep=""), plot = measure.plot, device = "png",
         scale = 1, width = 5.5, height = 2, units = "in",
         dpi = 300, limitsize = TRUE) 
}

graph.topcentrality()
