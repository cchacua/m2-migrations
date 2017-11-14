# https://stackoverflow.com/questions/12573456/returning-non-matching-records-from-a-merge
df.diff <- function(df1, df2) {
  is.dup <- duplicated(rbind(df2, df1))
  is.dup <- tail(is.dup, nrow(df1))
  df1[!is.dup, ]
}

# Query table to latex:
query.latex <- function(query, ndigits=0, tcaption=NULL, tlabel=NULL) {
table.temp<- dbSendQuery(patstat, query)
table.latex<-dbFetch(table.temp)
dbClearResult(table.temp)
table.latex<-xtable(table.latex)
digits(table.latex) <- ndigits
caption(table.latex)<- tcaption
label(table.latex)<-tlabel
print(table.latex, include.rownames = FALSE, booktabs = TRUE)
}