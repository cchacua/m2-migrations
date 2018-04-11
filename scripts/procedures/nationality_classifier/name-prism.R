install.packages("nomine")
library("nomine")

logtovector<-function(loglist, fileslist){
  loglist<-as.data.frame(loglist)
  loglist<-t(loglist)
  loglist<-as.data.frame(loglist)
  result<-data.frame(path=fileslist, status=loglist$V1 )
  result<-result[result$status=="Not done",]
  rownames(result)<-seq(1,nrow(result),1)
  result<-as.vector(as.character(result[,1]))
  return(result)
}

get_nationalities_batch<-function(route){
  print(sub(".*/", "", route))
  file<-read.csv(route, header = FALSE, stringsAsFactors = FALSE)
  colnames(file)<-c("row","name", "finalID", "firstname", "lastname",  "full")
  file$full<-as.character(file$full)
  output<-get_nationalities(file$full)
  output<-as.data.frame(output)
  output$finalID<-file$finalID
  output$name<-file$name
  output$firstname<-file$firstname
  output$lastname<-file$lastname
  write.csv(output, paste0("./output/", sub(".*/", "", route),".csv"))
  return("Done")
}

get_nationalities_batch2<-function(route){
  print(sub(".*/", "", route))
  file<-read.csv(route, header = FALSE, stringsAsFactors = FALSE)
  colnames(file)<-c("row","full")
  file$full<-as.character(file$full)
  output<-get_nationalities(file$full)
  output<-as.data.frame(output)
  write.csv(output, paste0("./output/", sub(".*/", "", route),".csv"))
  return("Done")
}

# First set a
# files.part1_f<-list.files(path="./data/part1_f", full.names=TRUE) 
# files.part1_f
# log<-lapply(files.part1_f[1:11],
#        function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))

# First set b
files.part1b_f<-list.files(path="./data/part1b_f", full.names=TRUE) 
files.part1b_f
get_nationalities_batch(files.part1b_f[1])
lapply(files.part1b_f[2:3],
            function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))

files.part1ba_f<-list.files(path="./data/part1ba_f", full.names=TRUE) 
files.part1ba_f
lapply(files.part1ba_f[1:length(files.part1ba_f)],
       function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))


# First set c

files.part1c_f<-list.files(path="./data/part1c_f", full.names=TRUE) 
files.part1c_f
log<-lapply(files.part1c_f,
       function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))

log2<-as.data.frame(log)
log2<-t(log2)
log2<-as.data.frame(log2)

files.part1c_f_not<-data.frame(path=files.part1c_f, status=log2$V1 )
files.part1c_f_not<-files.part1c_f_not[files.part1c_f_not$status=="Not done",]
rownames(files.part1c_f_not)<-seq(1,nrow(files.part1c_f_not),1)

files.part1c_f_not_l<-as.vector(as.character(files.part1c_f_not$path))
log3<-lapply(files.part1c_f_not_l,
            function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))

log4<-as.data.frame(log3)
log4<-t(log4)
log4<-as.data.frame(log4)
files.part1c_f_not2<-data.frame(path=files.part1c_f_not, status=log4$V1 )
files.part1c_f_not2<-files.part1c_f_not2[files.part1c_f_not2$status=="Not done",]
rownames(files.part1c_f_not2)<-seq(1,nrow(files.part1c_f_not2),1)
files.part1c_f_not2_l<-as.vector(as.character(files.part1c_f_not2[,1]))

log5<-lapply(files.part1c_f_not2_l,
             function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))
log6<-lapply(files.part1c_f_not2_l[2],
             function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))
# "part1c.p.9452"
get_nationalities_batch(files.part1c_f_not2_l[2])
###########################
# Second set
files.part2_f<-list.files(path="./data/part2_f", full.names=TRUE) 
files.part2_f
log_part2<-lapply(files.part2_f,
            function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))
# All done

###########################
# Third set
files.part3_f<-list.files(path="./data/part3_f", full.names=TRUE) 
files.part3_f
log_part3<-lapply(files.part3_f,
                  function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part3_f_nd<-logtovector(log_part3,files.part3_f)
log_part3_b<-lapply(files.part3_f_nd,
                  function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part3_f_ndd<-logtovector(log_part3_b,files.part3_f_nd)
log_part3_c<-lapply(files.part3_f_ndd,
                    function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
# All done

###########################
# Fourth set
files.part4a_f<-list.files(path="./data/part4a_f", full.names=TRUE) 
files.part4a_f
log_part4a<-lapply(files.part4a_f,
                  function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part4b_f<-list.files(path="./data/part4b_f", full.names=TRUE) 
files.part4b_f
log_part4b<-lapply(files.part4b_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part4b_f_nd<-logtovector(log_part4b,files.part4b_f)
log_part4b<-lapply(files.part4b_f_nd,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
# Not done
#  "part4b.p.9134"
#get_nationalities_batch2(x)
###########################
# Fifth set
files.part5a_f<-list.files(path="./data/part5_f", full.names=TRUE) 
files.part5a_f
log_part5a<-lapply(files.part5a_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
files.part5a_f_nd<-logtovector(log_part5a,files.part5a_f)
log_part5a_nd<-lapply(files.part5a_f_nd,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part5b_f<-list.files(path="./data/part5b_f", full.names=TRUE) 
files.part5b_f
log_part5b<-lapply(files.part5b_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Sixth set
files.part6a_f<-list.files(path="./data/part6a_f", full.names=TRUE) 
files.part6a_f
log_part6a<-lapply(files.part6a_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part6a_f_nd<-logtovector(log_part6a,files.part6a_f)
log_part6a_nd<-lapply(files.part6a_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
# Not done:  
# "part6a.p.9069"
#  "part6a.p.9799"
# "part6a.p.9800"

files.part6b_f<-list.files(path="./data/part6b_f", full.names=TRUE) 
files.part6b_f
log_part6b<-lapply(files.part6b_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part6b_f_nd<-logtovector(log_part6b,files.part6b_f)
log_part6b_nd<-lapply(files.part6b_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Seventh set
files.part7a_f<-list.files(path="./data/part7a_f", full.names=TRUE) 
files.part7a_f
log_part7a<-lapply(files.part7a_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part7a_f_nd<-logtovector(log_part7a,files.part7a_f)
files.part7a_f_nd
log_part7a_nd<-lapply(files.part7a_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part7b_f<-list.files(path="./data/part7b_f", full.names=TRUE) 
files.part7b_f
log_part7b<-lapply(files.part7b_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part7b_f_nd<-logtovector(log_part7b,files.part7b_f)
files.part7b_f_nd
log_part7b_nd<-lapply(files.part7b_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

# file:///C:/github/nameprism_work/data/part7b_f/part7b.p.07
# file:///C:/github/nameprism_work/data/part7b_f/part7b.p.03


###########################
# Ninth set (there is no 8)
files.part9a_f<-list.files(path="./data/part9a_f", full.names=TRUE) 
files.part9a_f
log_part9a<-lapply(files.part9a_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part9a_f_nd<-logtovector(log_part9a,files.part9a_f)
files.part9a_f_nd
log_part9a_nd<-lapply(files.part9a_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))


###########################
# Tenth set
files.part10a_f<-list.files(path="./data/part10a_f", full.names=TRUE) 
files.part10a_f
log_part10a<-lapply(files.part10a_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part10a_f_nd<-logtovector(log_part10a,files.part10a_f)
files.part10a_f_nd
#] "./data/part10a_f/part10a.p.9160"
log_part10a_nd<-lapply(files.part10a_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Eleventh set
files.part11a_f<-list.files(path="./data/part11a_f", full.names=TRUE) 
files.part11a_f
log_part11a<-lapply(files.part11a_f,
                    function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))


files.part11b_f<-list.files(path="./data/part11b_f", full.names=TRUE) 
files.part11b_f
log_part11b<-lapply(files.part11b_f,
                    function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Twelfth set
files.part12_f<-list.files(path="./data/part12_f", full.names=TRUE) 
files.part12_f
log_part12<-lapply(files.part12_f,
                    function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
files.part12_f_nd<-logtovector(log_part12,files.part12_f)
files.part12_f_nd
log_part12_nd<-lapply(files.part12_f_nd,
                       function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Non-set
files.partnon_f<-list.files(path="./data/partnon", full.names=TRUE) 
files.partnon_f
log_partnon<-lapply(files.partnon_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))
# part1c.p.9452.csv

files.partnon_f<-list.files(path="../output/nationality/partnon/done02", full.names=TRUE) 
files.partnon_f
log_partnon<-lapply(files.partnon_f,
                    function(x) tryCatch(get_nationalities_batch(x), error=function(e) print("Not done")))

files.partnon_f<-list.files(path="../output/nationality/partnon/done03", full.names=TRUE) 
files.partnon_f

file<-read.csv(files.partnon_f[1], header = FALSE, stringsAsFactors = FALSE)
colnames(file)<-c("row","name", "finalID", "firstname", "lastname",  "full")
file$full<-as.character(file$full)
output<-get_nationalities(file$full)
output<-as.data.frame(output)
output$finalID<-file$finalID
output$name<-file$name
output$firstname<-file$firstname
output$lastname<-file$lastname
write.csv(output, "../output/nationality/partnon/done03-.csv")

file<-read.csv(files.partnon_f[1], header = FALSE, stringsAsFactors = FALSE)
colnames(file)<-c("row","full")
file$full<-as.character(file$full)
output<-get_nationalities(file$full)
output<-as.data.frame(output)
write.csv(output,"../output/nationality/partnon/done03-.csv")

log_partnon<-lapply(files.partnon_f,
                    function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

###########################
# Thirteenth set
files.part13_f<-list.files(path="./data/part13_f", full.names=TRUE) 
files.part13_f
log_part13<-lapply(files.part13_f,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.part13_f_nd<-logtovector(log_part13,files.part13_f)
files.part13_f_nd
log_part13_nd<-lapply(files.part13_f_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))





###########################
# federico
files.fede<-list.files(path="./data/federico", full.names=TRUE) 
files.fede
log_fede<-lapply(files.fede,
                   function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

files.fede_nd<-logtovector(log_fede,files.fede)
files.fede_nd
log_fede_nd<-lapply(files.fede_nd,
                      function(x) tryCatch(get_nationalities_batch2(x), error=function(e) print("Not done")))

