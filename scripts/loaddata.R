################################################################################################
# PATSTAT 2016b
################################################################################################
files.patstat<-list.files(path="../data/patstat2016b/raw", full.names=TRUE)
files.patstat

# Read a file
# tls201<-read.csv(files.patstat[1], header = TRUE, skip=6012997, nrows = 3)


################################################################################################
# Morrison, Riccaboni and Pammolli (2017)
################################################################################################
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


################################################################################################
# RegPat 201602
################################################################################################
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
t01<-read.table(files.regpat[3], header = TRUE, sep = "|", quote = '""', nrows =10)


################################################################################################
# OECD Citations 201709
################################################################################################
files.oecdcitations<-list.files(path="../data/oecd_citations", full.names=TRUE)
files.oecdcitations

# [1] "../data/oecd_citations/201709_EP_Citations.txt"      
# [2] "../data/oecd_citations/201709_EP_Cit_Counts.txt"     
# [3] "../data/oecd_citations/201709_EP_Equivalent.txt"     
# [4] "../data/oecd_citations/201709_EP_NPL_Citations.txt"  
# [5] "../data/oecd_citations/201709_US_Citations_1.txt"    
# [6] "../data/oecd_citations/201709_US_Citations_2.txt"    
# [7] "../data/oecd_citations/201709_US_Citations_3.txt"    
# [8] "../data/oecd_citations/201709_US_Citations_4.txt"    
# [9] "../data/oecd_citations/201709_US_Cit_Counts.txt"     
# [10] "../data/oecd_citations/201709_US_Equivalent.txt"     
# [11] "../data/oecd_citations/201709_US_NPL_Citations_1.txt"
# [12] "../data/oecd_citations/201709_US_NPL_Citations_2.txt"
# [13] "../data/oecd_citations/201709_WO_Citations.txt"      
# [14] "../data/oecd_citations/201709_WO_Equivalent.txt"     
# [15] "../data/oecd_citations/201709_WO_NPL_Citations.txt"  
# [16] "../data/oecd_citations/raw" 

t01<-read.table(files.oecdcitations[9], header = TRUE, sep = "|", quote = '""', nrows =100)
colnames(t01)
write.csv(colnames(t01), "../output/databases/oecd_citations/colnames.csv")

t01<-read.table(files.oecdcitations[7], header = FALSE, sep = "|", quote = '""', skip= 600, nrows =100)

t01<-read.table(files.oecdcitations[13], header = TRUE, sep = "|", quote = '""', nrows =100)
colnames(t01)
write.csv(colnames(t01), "../output/databases/oecd_citations/colnames.csv")

################################################################################################
# OECD Patent Quality 201709
################################################################################################
files.patqual<-list.files(path="../data/patentquality201709", full.names=TRUE)
files.patqual

# [1] "../data/patentquality201709/201709_epo_indic_cohort.txt"         
# [2] "../data/patentquality201709/201709_OECD_PATENT_QUALITY_EPO.txt"  
# [3] "../data/patentquality201709/201709_OECD_PATENT_QUALITY_USPTO.txt"
# [4] "../data/patentquality201709/201709_uspto_indic_cohort.txt"

t01<-read.table(files.patqual[3], header = TRUE, sep = "|", nrows =100)


################################################################################################
# OECD Patent Quality 201709
################################################################################################
files.patentsview<-list.files(path="../data/uspto-patentview", full.names=TRUE)
files.patentsview

# [1] "../data/uspto-patentview/application.tsv"     
# [2] "../data/uspto-patentview/patentid_applnid.txt"
# [3] "../data/uspto-patentview/raw"      

t01<-read.table(files.patentsview[1], header = TRUE, nrows =100)
t01<-read.table(files.patentsview[2], header = TRUE, nrows =100)
colnames(t01)

################################################################################################
# PCT Nationality
################################################################################################
files.pct<-list.files(path="../data/pct", full.names=TRUE)
files.pct

# [1] "../data/pct/inventors_names_patstat.csv"       
# [2] "../data/pct/No"                                
# [3] "../data/pct/regpat_pct_inv_reg_nationality.csv"

t01<-read.csv2(files.pct[1], header = TRUE, nrows =100)
t01<-read.csv2(files.pct[3], header = TRUE, nrows =100)
colnames(t01)


################################################################################################
# Others, SQL
################################################################################################
files.sql<-list.files(path="../data/sql", full.names=TRUE)
files.sql

files.mergetest.epo<-list.files(path="../data/merge_test/epo", full.names=TRUE)
files.mergetest.epo

# [1] "../data/merge_test/epo/epo-pubnumber-merge2.csv"   
# [2] "../data/merge_test/epo/epo-pubnumber-merge.csv"    
# [3] "../data/merge_test/epo/epo-pubnumber-riccaboni.csv"