
controls_bulk<-function(endyear, withplot=FALSE, sector="ctt"){
  print("Sector should be pboc or ctt")
  
  sector="ctt"
  endyear<-2008
  
  inityear<-endyear-4
  linkyear<-endyear+1
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  uedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                     FROM riccaboni.edges_undir_pyr", sector,
                                     " WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                     ORDER BY EARLIEST_FILING_YEAR"))
  dedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__, undid
                                     FROM riccaboni.edges_undid_ud_", sector, 
                                     " WHERE EARLIEST_FILING_YEAR=",linkyear))
  dedges$ipc<-substr(dedges$finalID_, 3,3)
  dedges<-dedges[1:10,]
  dedges.nodes<-rbind(data.frame(finalID=unique(dedges$finalID_)),data.frame(finalID=unique(dedges$finalID__)))
  dedges.nodes<-data.frame(finalID=unique(dedges.nodes$finalID))
  dedges<-dedges[1:10,]
  dedges$ipc<-c("1","2","1","3","1","2","1","3","1","2")
  dedges2<-dedges
  rm(dedges)
  
  #ipcrow<-function(onerow, ncontrol=1,edges=dedges){
  ipcrow<-function(ipcv, idv, ncontrol=1, edges){

    # onerow<-as.vector(onerow)
    # onerow<-data.frame(finalID_=onerow[1], finalID__=onerow[2], undid=onerow[3], ipc=onerow[4])
    # setipc<-as.data.table(edges[edges$ipc==onerow$ipc,])
    # setnei<-as.data.table(edges[edges$finalID_==onerow$finalID_,])
    setipc<-as.data.table(edges[edges$ipc==ipcv,])
    setnei<-as.data.table(edges[edges$finalID_==idv,])
    
    setkey(setipc,finalID__)
    setkey(setnei,finalID__)
    Result <- merge(setipc,setnei, all=TRUE)
    Result <- Result[is.na(finalID_.y)]
    Result<-Result[sample(nrow(Result), ncontrol),c(5,1,4)]
    colnames(Result)<-c("finalID_", "finalID__", "ipc")
    #Result$finalID_<-onerow$finalID_
    Result$finalID_<-idv
    return(Result)
  }
  
  ipcrow(dedges[1,])
  rr<-mapply(ipcrow, ipcv=dedges$ipc, idv=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=1))
  rr<-as.data.frame(t(rr))

  dedges.all<-expand.grid(dedges.nodes$finalID, dedges.nodes$finalID, KEEP.OUT.ATTRS = FALSE, stringsAsFactors = TRUE)
  colnames(dedges.all)<-c("finalID_", "finalID__")
  dedges.all<-as.data.table(dedges.all)
  gc()
  dedges.all<-dedges.all[dedges.all$finalID_!=dedges.all$finalID__,]
  dedges.all<-dedges.all[, undid:=do.call(paste0,.SD)]
  setkey(dedges.all,undid)
  uedges<-as.data.table(uedges)
  uedges<-uedges[, undid:=do.call(paste0,.SD)]
  setkey(uedges,undid)
  Result <- merge(dedges.all,uedges, all=TRUE)
  Result <- Result[is.na(finalID_) | is.na(finalID_)]
  
  
  dedges<-as.data.table(dedges)
  dedges<-dedges[, undid:=do.call(paste0,.SD)]
  setkey(dedges,undid)
  
  dedges.all$eid<-paste0(dedges.all$finalID_,dedges.all$finalID__)
  gc()
  
  print("Data has been loaded")
  print(paste("Number of total edges",nrow(uedges)))
  print(paste("Number of edges to find",nrow(dedges), nrow(dedges)/nrow(uedges)))
  uedges<-as.matrix(uedges)
  graph<-graph_from_edgelist(uedges, directed = FALSE)
  rm(uedges)
  save(graph, file=paste0("../output/graphs/networks/",sector, "_", inityear,"-",endyear, "_network", ".RData"))
  print("Graph has been done and saved")
  
  vfrom<-V(graph)[V(graph)$name %in% dedges$finalID_]
  vto<-V(graph)[V(graph)$name %in% dedges$finalID__]
  dline<-distances(graph, v=vfrom, to=vto, weights = NULL)
  #dline<-as.data.table(dline)
  dline<-melt(dline)
  dline<-dline[dline$value!=0 & dline$value!="Inf",]
  print("Distances have been computed")
  gc()
  dline$undid<-paste0(linkyear, dline$Var1, dline$Var2)
  # dedges<-as.data.table(dedges)
  # setkey(dline,undid)
  # setkey(dedges,undid)
  # dline<- dline[dedges, nomatch=0]
  dline<-merge(dline,dedges,by="undid")
  
  #dline<-dline[dline$undid %in% dedges$undid,]
  dline$lyear<-linkyear
  
  write.csv(dline, paste0("../output/graphs/distance_list/",sector, "_", inityear,"-",endyear, "_list", ".csv"))
  
  if(withplot==TRUE){
    graph.l<-layout_with_drl(graph, options=list(simmer.attraction=0))
    print("Layout has been done")
    pdf(paste0("../output/graphs/images/",inityear,"-",endyear, "_plot", ".pdf"))
    plot(graph, layout=graph.l, vertex.label=NA, vertex.frame.color=NA, vertex.size=0.7, edge.width=0.4)
    dev.off()
    print("Plot has been done")
  }
  gc()
  return("done")
}