files.patstat<-list.files(path="../data/patstat2016b/raw", full.names=TRUE)
files.patstat

# Read a file
# tls201<-read.csv(files.patstat[1], header = TRUE, nrows = 3)

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

# ri.t01<-read.table(files.riccaboni[7], header = TRUE, sep = "|", nrows =100000)
# View(t01[291192,])

files.regpat<-list.files(path="../data/regpat201602", full.names=TRUE)
files.regpat

# [1] "../data/regpat201602/201602_CPC_Class_Y.txt"      
# [2] "../data/regpat201602/201602_EPO_App_reg.txt"      
# [3] "../data/regpat201602/201602_EPO_Inv_reg.txt"      
# [4] "../data/regpat201602/201602_EPO_IPC.txt"          
# [5] "../data/regpat201602/201602_EPO_PCT.txt"          
# [6] "../data/regpat201602/201602_PCT_App_reg.txt"      
# [7] "../data/regpat201602/201602_PCT_Inv_reg.txt"      
# [8] "../data/regpat201602/201602_PCT_IPC.txt"          
# [9] "../data/regpat201602/REGPAT_Regions_NUTS3_TL3.txt"
# [10] "../data/regpat201602/REGPAT_Regions.txt"   

t01<-read.table(files.regpat[7], header = TRUE, sep = "|", quote = '""', nrows =100)


files.patqual<-list.files(path="../data/patentquality201709", full.names=TRUE)
files.patqual

# [1] "../data/patentquality201709/201709_epo_indic_cohort.txt"         
# [2] "../data/patentquality201709/201709_OECD_PATENT_QUALITY_EPO.txt"  
# [3] "../data/patentquality201709/201709_OECD_PATENT_QUALITY_USPTO.txt"
# [4] "../data/patentquality201709/201709_uspto_indic_cohort.txt"

t01<-read.table(files.patqual[3], header = TRUE, sep = "|", nrows =100)


files.sql<-list.files(path="../data/sql", full.names=TRUE)
files.sql

