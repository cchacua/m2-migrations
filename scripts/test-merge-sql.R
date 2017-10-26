
tmerge<-read.csv(files.sql[1], header = FALSE, stringsAsFactors=FALSE)
trica<-read.csv(files.sql[2], header = FALSE, stringsAsFactors=FALSE)
trica[1:10,]
colnames(tmerge)
colnames(trica)
trica$pat<-trica$V1
#t2<-df.diff(trica[by.cols], tmerge[by.cols])
t2<-anti_join(trica, tmerge,by="V1")

length(unique(trica$V1))
# 9.290.268
length(unique(tmerge$V1))
# 4.252.766
tmergeuniq<-unique(tmerge$V1)
tmergeuniq[1:100]

tricauniq<-unique(trica$V1)
tricauniq[1:100]
t2[1:10,]



trica.agen<-read.csv(files.sql[3], header = FALSE, stringsAsFactors=FALSE)
trica.agenuni<-unique(trica.agen)

t211.agen<-read.csv(files.sql[4], header = FALSE, stringsAsFactors=FALSE)
t211.agenuni<-unique(t211.agen)


