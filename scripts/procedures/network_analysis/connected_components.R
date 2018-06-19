# Graph component distribution
comp.distribution<-function(net, binwidth=20){
  #net<-n1
  net<-components(net)
  net.mem<-as.data.frame(net[1])
  net.mem$finalID<-rownames(net.mem)
  #net.mem$membership<-ifelse(net.mem$membership==1, NA, net.mem$membership)
  #colnames(net.mem)<-c("Size", "Number")
  dist<-ggplot(net.mem, aes(x=membership)) + geom_histogram(fill="#00B0F6", binwidth=binwidth) + xlab("")+ ylab(NULL)+ggtitle("Total")
  dist
}

files.n_ctt<-list.files(path="../output/graphs/networks/ctt", full.names=TRUE)
files.n_ctt

n1<-open.rdata(files.n_ctt[30])
comp.distribution(n1, binwidth=20)
