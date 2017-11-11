epo.ric<-read.csv(files.mergetest.epo[3], header = FALSE, stringsAsFactors=FALSE)
epo.merge<-read.csv(files.mergetest.epo[2], header = FALSE, stringsAsFactors=FALSE)
epo.nonjoint<-anti_join(epo.ric, epo.merge,by="V1")
epo.nonjoint