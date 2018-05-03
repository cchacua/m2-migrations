#install.packages("reshape")
library(reshape)

rs <- dbSendQuery(patstat, 'SET CHARACTER SET "UTF8"')
oecd<-read.csv( "../output/spatial_eco/data_usma_oecd.csv")
oecd$METRO_ID<-as.character(oecd$METRO_ID)
write.dta(oecd, "../output/spatial_eco/data_oecd_allyears.dta")


#########################################################################################
# Metropolitan areas
#########################################################################################

### PBOC ALL INVENTORS
pboc.df<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                           FROM christian.t08_classes_locboth a
                           INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
                           INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                           GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR;", metroid=FALSE)

### PBOC NON-CELTIC
pboc_nceltic.df<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR;", metroid=FALSE)
"
China
India 
Iran
Japan
South Korea
France 
Germany
Italy
Poland
Russia
"

"
EastAsian.Chinese
SouthAsian
Muslim.Persian
EastAsian.Japan
EastAsian.South.Korea
European.French
European.German
European.Italian.Italy
European.EastEuropean
European.Russian
"

EastAsian.Chinese<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='EastAsian.Chinese'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)

SouthAsian<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='SouthAsian'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
Muslim.Persian<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='Muslim.Persian'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
EastAsian.Japan<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='EastAsian.Japan'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
EastAsian.South.Korea<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='EastAsian.South.Korea'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
European.French<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='European.French'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
European.German<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='European.German'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
European.Italian.Italy<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='European.Italian.Italy'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
European.EastEuropean<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='European.EastEuropean'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)
European.Russian<-count_invs("SELECT a.finalID, a.METROID AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                    FROM christian.t08_class_at1us_date_fam_nceltic_loc a
                                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                    WHERE a.nation='European.Russian'                                    
                                    GROUP BY a.finalID, a.METROID, a.EARLIEST_FILING_YEAR
                                    ;", metroid=FALSE)

pboc.df<-smalldfcount(pboc.df)
pboc_nceltic.df<-smalldfcount(pboc_nceltic.df)
European.German<-smalldfcount(European.German)
EastAsian.Chinese<-smalldfcount(EastAsian.Chinese)
European.French<-smalldfcount(European.French)
SouthAsian<-smalldfcount(SouthAsian)
European.Italian.Italy<-smalldfcount(European.Italian.Italy)
EastAsian.South.Korea<-smalldfcount(EastAsian.South.Korea)
EastAsian.Japan<-smalldfcount(EastAsian.Japan)
Muslim.Persian<-smalldfcount(Muslim.Persian)
European.Russian<-smalldfcount(European.Russian)
European.EastEuropean<-smalldfcount(European.EastEuropean)

list_df <- list(   pboc.df,
                pboc_nceltic.df,
                European.German,
                EastAsian.Chinese,
                European.French,
                SouthAsian,
                European.Italian.Italy,
                EastAsian.South.Korea,
                EastAsian.Japan,
                Muslim.Persian,
                European.Russian,
                European.EastEuropean
                )
#merged_df <- merge_all(list_df, by='key')

smalldfcount<-function(x){
  sx<-deparse(substitute(x))
  x<-as.data.frame(x)
  x<-x[, c("key", "ninventors")]
  colnames(x)<-c("key", sx)
  return(x)
}

merged_df <-Reduce(function(x, y) merge(x, y, all=TRUE,  by='key'), list_df)
#merged_df <-Reduce(function(x, y) merge(x, y, all=TRUE,  by='key') , list_df)
merged_df$key<-as.character(merged_df$key)
write.dta(merged_df, "../output/spatial_eco/data_counts_merged_df.dta")

pboc_end<-merge(pboc.df,pboc_nceltic.df, by='key', all=TRUE)
pboc_end$propor<-pboc_end$ninventors.y/pboc_end$ninventors.x
pboc_end<-pboc_end[,c("ID.x","EARLIEST_FILING_YEAR.x","ninventors.x", "ninventors.y", "propor")]
colnames(pboc_end)<-c("ID","EARLIEST_FILING_YEAR","pboc", "pbocnon", "pbocratio")
pboc_end$koecd<-paste0(pboc_end$EARLIEST_FILING_YEAR, substr(pboc_end$ID, 1,5) )
oecd$koecd<-paste0(oecd$Year,oecd$METRO_ID)
pboc_oecd_end<-merge(pboc_end,oecd, by="koecd", all=TRUE)

#write.dta(pboc_end[pboc_end$EARLIEST_FILING_YEAR=="2005",], "../output/spatial_eco/data_2005_pboc.dta")
write.dta(pboc_oecd_end, "../output/spatial_eco/data_pboc_oecd_end.dta")
write.dta(pboc_end, "../output/spatial_eco/data_pboc_end_allyears.dta")


#########################################################################################
# Counties
#########################################################################################

### PBOC ALL INVENTORS
pboc_cou.df<-count_invs("SELECT a.finalID, a.HASC_2 AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                    FROM christian.t08_classes_locbothcoun a
                    INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
                    INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                    GROUP BY a.finalID, a.HASC_2, a.EARLIEST_FILING_YEAR;")

### PBOC NON-CELTIC
pboc_cou_nceltic.df<-count_invs("SELECT a.finalID, a.HASC_2 AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                            FROM christian.t08_classes_locbothcoun a
                            INNER JOIN christian.t08_class_at1us_date_fam_nceltic b ON a.pat=b.pat
                            INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam c ON a.pat=c.pat
                            INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                            GROUP BY a.finalID, a.HASC_2, a.EARLIEST_FILING_YEAR;")

pboc_cou_end<-merge(pboc_cou.df,pboc_cou_nceltic.df, by='key', all=TRUE)
pboc_cou_end$propor<-pboc_cou_end$ninventors.y/pboc_cou_end$ninventors.x
pboc_cou_end<-pboc_cou_end[,c("ID.x","EARLIEST_FILING_YEAR.x","ninventors.x", "ninventors.y", "propor")]
colnames(pboc_cou_end)<-c("ID","EARLIEST_FILING_YEAR","pboc", "pbocnon", "pbocratio")
write.dta(pboc_cou_end[pboc_cou_end$EARLIEST_FILING_YEAR=="2005",], "../output/spatial_eco/data_2005_cou_pboc.dta")


#########################################################################################
# States
#########################################################################################

### PBOC ALL INVENTORS
pbocstates.df<-count_invs("SELECT a.finalID, a.HASC_1 AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                        FROM christian.t08_classes_locbothstates a
                          INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam b ON a.pat=b.pat
                          INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                          GROUP BY a.finalID, a.HASC_1, a.EARLIEST_FILING_YEAR;")

### PBOC NON-CELTIC
pbocstates_nceltic.df<-count_invs("SELECT a.finalID, a.HASC_1 AS ID, a.EARLIEST_FILING_YEAR, COUNT(DISTINCT a.loc) AS nloc 
                                  FROM christian.t08_classes_locbothstates a
                                  INNER JOIN christian.t08_class_at1us_date_fam_nceltic b ON a.pat=b.pat
                                  INNER JOIN riccaboni.t08_allclasses_t01_loc_allteam c ON a.pat=c.pat
                                  INNER JOIN riccaboni.t01_pboc_class d ON a.pat=d.pat
                                  GROUP BY a.finalID, a.HASC_1, a.EARLIEST_FILING_YEAR;")

pbocstates_end<-merge(pbocstates.df,pbocstates_nceltic.df, by='key', all=TRUE)
pbocstates_end$propor<-pbocstates_end$ninventors.y/pbocstates_end$ninventors.x
pbocstates_end<-pbocstates_end[,c("ID.x","EARLIEST_FILING_YEAR.x","ninventors.x", "ninventors.y", "propor")]
colnames(pbocstates_end)<-c("ID","EARLIEST_FILING_YEAR","pboc", "pbocnon", "pbocratio")
write.dta(pbocstates_end[pbocstates_end$EARLIEST_FILING_YEAR=="2005",], "../output/spatial_eco/data_2005states_pboc.dta")


