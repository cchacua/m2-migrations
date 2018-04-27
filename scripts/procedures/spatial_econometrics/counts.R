inv_counts<-dbGetQuery(patstat, "SELECT a.METRO, a.EARLIEST_FILING_YEAR, COUNT(a.finalID) AS ninventors FROM christian.nceltic_state_g_ctt a GROUP BY a.METRO, a.EARLIEST_FILING_YEAR;")
write.dta(inv_counts[inv_counts$EARLIEST_FILING_YEAR=="2005",], "../output/spatial_eco/data_nonceltic_inv.dta")
