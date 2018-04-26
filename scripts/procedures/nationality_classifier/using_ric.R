

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
rs <- dbSendQuery(patstat, 'SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci')

# Read points with coordinates and turn it into a SpatialPointsDataFrame
file<-dbGetQuery(patstat, "SELECT DISTINCT a.finalID, a.name FROM riccaboni.t08_names_allclasses_t01_t09_onlynames a INNER JOIN christian.ric_us_ao_diff_8_aid b ON a.finalID=b.finalID")

length(unique(file$finalID))
# 34828, so, it's ok

part1.list<-cleannames_one(query="SELECT DISTINCT a.name, a.finalID 
                        FROM christian.ric_us_ao_diff_8_aid_n a 
                        WHERE a.ncommas='1' AND a.ncharac<='20' AND a.nblanks='1'AND a.ncommasblanksright='1' AND a.hnumber='0' AND a.ndots='0'
                        ORDER BY a.finalID",
                           filename = "part1_ric.csv")


part1_nc<-as.data.frame(part1.list[2])
part1_c<-as.data.frame(part1.list[1])

part1_c_res<-reshape(transform(part1_c, time=ave(full, finalID, FUN=seq_along)), idvar="finalID", direction="wide")
part1_c_unique<-part1_c_res[is.na(part1_c_res$full.2),]
part1_c_unique$full1_UPPER<-toupper(part1_c_unique$full.1)
write.csv(part1_c_unique,paste0("../output/nationality/", "part1a.csv"))
length(unique(part1_c_unique$finalID))
#12541
length(unique(part1_c_unique$full.1))
#12471
length(unique(part1_c_unique$full1_UPPER))
# 12433
write.csv(unique(part1_c_unique$full1_UPPER), paste0("../output/nationality/", "part1a_onlynames_unique.csv"))

part1_c_dupl<-part1_c_res[!is.na(part1_c_res$full.2),]
nrow(part1_c_dupl)
# 292
part1_c_dupl$full_big<-ifelse(stri_length(part1_c_dupl$full.1)>=stri_length(part1_c_dupl$full.2), part1_c_dupl$full.1, part1_c_dupl$full.2)
part1_c_dupl$full_big<-toupper(part1_c_dupl$full_big)
write.csv(part1_c_dupl, paste0("../output/nationality/", "part1_duplicates.csv"))
write.csv(unique(part1_c_dupl$full_big), paste0("../output/nationality/", "part1_onlynames_duplicates.csv"))
length(unique(part1_c_dupl$full_big))
# 292

