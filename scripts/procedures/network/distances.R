
# Set UTF 8 to future queries
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')

# Using the Undirected network finalID_, finalID__ 
uedges79.df<-dbGetQuery(patstat, "SELECT *
                        FROM riccaboni.edges_undir_pyr 
                        WHERE EARLIEST_FILING_YEAR>=1975 AND EARLIEST_FILING_YEAR<=1979
                        ORDER BY EARLIEST_FILING_YEAR")
uedges79.m<-as.matrix(uedges79.df[,1:2])
graph79<-graph_from_edgelist(uedges79.m, directed = FALSE)
graph79.drl<- layout_with_drl(graph79, options=list(simmer.attraction=0))
#graph79.lgfr<-layout_with_graphopt(graph79, niter = 10)
pdf("../output/graphs/images/75-79drl_plot", ".pdf")
#par(cex=2)
plot(graph79, layout=graph79.drl, vertex.label=NA, vertex.frame.color=NA, vertex.size=0.7, edge.width=0.5)
#plot(mygraph, layout=layout.new, vertex.size= V(mygraph)$size, vertex.label=NA, vertex.frame.color=V(mygraph)$color, edge.width=1, edge.color=E(mygraph)$color, edge.arrow.size=0.2)
dev.off()

ugraphinv_dis(1979)






