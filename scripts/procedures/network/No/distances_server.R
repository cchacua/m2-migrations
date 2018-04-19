library(igraph)
library(reshape2)

merge.list = function(datalist){
  datalist = do.call("rbind", datalist)  
  datalist<-unique(datalist)
  #datalist[datalist== ""] <- NA
  datalist
}

distances_aslist<-function(graph_element, endyear){
  inityear<-endyear-4
  linkyear<-endyear+1
  distance<-distances(graph_element, mode ="all", algorithm ="unweighted")
  distance.l<-melt(distance)
  distance.l<-distance.l[distance.l$value!=0,]
  distance.l$lyear<-linkyear
  write.csv(distance.l, paste0("../output/graphs/distance_list/",inityear,"-",endyear, "_",gsub("(\\:|\\s+|-)","",Sys.time()), ".csv"))
  
  return("Done")
}

open.rdata<-function(x){local(get(load(x)))}



ugraphinv_dis_file<-function(rnetwork, withplot=FALSE){
  endyear<-as.numeric(gsub("_(.*)+","",gsub("(.*)+-","",rnetwork)))
  inityear<-endyear-4
  linkyear<-endyear+1
  print(paste("Beginning year:", inityear))
  print(paste("Ending year:", endyear))
  print(paste("Link year:", linkyear))

  graph<-open.rdata(rnetwork)
  print("Graph has been loaded")
  components<-decompose.graph(graph, min.vertices=1)
  lapply(components, distances_aslist, endyear)
  # distances_outlist<-
  # distances_outdf<-merge.list(distances_outlist)
   
  if(withplot==TRUE){
    graph.l<-layout_with_drl(graph, options=list(simmer.attraction=0))
    print("Layout has been done")
    pdf(paste0("../output/graphs/images/",inityear,"-",endyear, "_plot", ".pdf"))
    plot(graph, layout=graph.l, vertex.label=NA, vertex.frame.color=NA, vertex.size=0.7, edge.width=0.4)
    dev.off()
    print("Plot has been done")
  }
  
  #return(list(graph, distance))
  return("Done")
}


nfiles<-list.files("../output/graphs/networks/three",full.names = TRUE)
nfiles
lapply(nfiles, ugraphinv_dis_file)
