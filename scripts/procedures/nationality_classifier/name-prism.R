library("nomine")

get_nationalities_batch<-function(route){
  print(sub(".*/", "", route))
  file<-read.csv(route, header = FALSE, stringsAsFactors = FALSE)
  colnames(file)<-c("row","name", "finalID", "firstname", "lastname",  "full")
  output<-get_nationalities(file$full)
  output<-as.data.frame(output)
  output$finalID<-file$finalID
  output$name<-file$name
  output$firstname<-file$firstname
  output$lastname<-file$lastname
  write.csv(output, paste0("../output/nationality/output/", sub(".*/", "", route),".csv"))
}

# First set
files.part1_f<-list.files(path="../output/nationality/part1_f", full.names=TRUE) 
lapply(files.part1_f,get_nationalities_batch)

