files<-list.files(path="../data/patstat2016b/raw", full.names=TRUE)
files

# Read a file
tls201<-read.csv(files[1], header = TRUE, nrows = 3)


