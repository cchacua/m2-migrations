files.patstat<-list.files(path="../data/patstat2016b/raw", full.names=TRUE)
files.patstat

# Read a file
tls201<-read.csv(files.patstat[1], header = TRUE, nrows = 3)

files.riccaboni<-list.files(path="../data/riccaboni", full.names=TRUE)
files.riccaboni

# [1] "../data/riccaboni/all_disambiguated_patents_withLocal.txt"
# [2] "../data/riccaboni/Citation_AppExa.txt"                    
# [3] "../data/riccaboni/combined_labels_boston.txt"             
# [4] "../data/riccaboni/combined_labels_HarvardInv.txt"         
# [5] "../data/riccaboni/combined_labels_paris.txt"              
# [6] "../data/riccaboni/IPC_to_Industry_WIPOJan2013.txt"        
# [7] "../data/riccaboni/LinkedAssigneeNameLocData.txt"          
# [8] "../data/riccaboni/LinkedInventorNameLocData.txt"          
# [9] "../data/riccaboni/mobilityLinks.txt"                      
# [10] "../data/riccaboni/Patent_classes.txt"                     
# [11] "../data/riccaboni/patent_to_triadic_family.txt"           
# [12] "../data/riccaboni/USPC_to_IPC_fullList.txt"               
# [13] "../data/riccaboni/wipo_class_ID.txt"     

# t01<-read.table(files.riccaboni[7], header = TRUE, sep = "|", nrows =100000)
# View(t01[291192,])


files.sql<-list.files(path="../data/sql", full.names=TRUE)
files.sql

