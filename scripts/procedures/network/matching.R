rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

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
  patipc3<-dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
                                     FROM christian.t08_class_at1us_date_fam_for a 
                                     INNER JOIN riccaboni.t01_", sector, "_class b 
                                     ON a.pat=b.pat 
                                     INNER JOIN christian.pat_3ipc c
                                     ON a.pat=c.pat 
                                     WHERE a.EARLIEST_FILING_YEAR=",linkyear," AND c.EARLIEST_FILING_YEAR=",linkyear))
 length(unique(patipc6$class))
  dedges$ipc<-substr(dedges$finalID_, 3,3)
  #dedges<-dedges[1:10,]
  dedges.nodes<-rbind(data.frame(finalID=unique(dedges$finalID_)),data.frame(finalID=unique(dedges$finalID__)))
  dedges.nodes<-data.frame(finalID=unique(dedges.nodes$finalID))
  dedges<-dedges[1:10,]
  dedges$ipc<-c("1","2","1","3","1","2","1","3","1","2")
  dedges2<-dedges
  rm(dedges)

  ipcrow<-function(idv,id__, ncontrol=1, edges, ipcfile){
  ipcclasses<-ipcfile[ipcfile$finalID==id__,]
  print(ipcclasses)
  setipc<-as.data.table(ipcfile[ipcfile$class %in% ipcclasses$class,])
  print(setipc)
  setnei<-as.data.table(edges[edges$finalID_==idv,])
  print(setnei)
  setnona<-setipc[!(setipc$finalID %in% setnei$finalID__),]
  print(setnona)
  setnona<-setnona[sample(nrow(setnona), ncontrol),]
  print(setnona)
  Result<-data.table(finalID_=idv, finalID__=setnona$finalID, counterof=id__,class=setnona$class, ncount=seq(1,ncontrol,1))
  print(Result)
  return(Result)
  }
  
  ipcrow(dedges[1,])
rr<-mapply(ipcrow, idv=dedges$finalID_, id__=dedges$finalID__, MoreArgs = list(edges=dedges, ncontrol=1, ipcfile=patipc3))
rr<-as.data.frame(t(rr))
  
  rr<-mapply(ipcrow, ipcv=dedges$ipc, idv=dedges$finalID_, id__=dedges$finalID__, MoreArgs = list(edges=dedges, ncontrol=3, ipcfile=patipc3), SIMPLIFY = FALSE)
  rr<-merge.list(rr)
  
  
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