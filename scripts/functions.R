# Substract right
substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

# Find if a coordinate point is inside the US
pointinus<-function(coordinates.file, mapusa=mapusa.gadm){
  # Read USA polygons
  #mapusa<-readRDS(files.gadm[1])
  print(substrRight(coordinates.file, 2))
  # Read points with coordinates and turn it into a SpatialPointsDataFrame
  file<-read.csv(coordinates.file, header = FALSE)
  colnames(file)<-"loc"
  file$loc<-as.character(file$loc)
  file.df<-do.call("rbind", strsplit(file$loc, ","))
  file.df<-data.frame(apply(file.df, 2, as.numeric))
  colnames(file.df)<-c("lat","long")
  tric_loc<-file.df
  coordinates(tric_loc) <- c("long", "lat")
  
  # Set coordinate systems as equal
  proj4string(tric_loc) <- proj4string(mapusa)
  
  # Check if point is in polygon and save as csv
  inside.usa<- !is.na(over(tric_loc, as(mapusa, "SpatialPolygons")))
  output<-data.frame(loc=file$loc, lat=file.df$lat, long=file.df$long, isin=inside.usa)
  write.csv(output, paste0("../data/sql/21 Distinct locations/outputs/tempfile.part.", substrRight(coordinates.file, 2),".csv"))
}

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

# Merge multiple files
merge.csv = function(mypath){
  filenames=list.files(path=mypath, full.names=TRUE)
  datalist = lapply(filenames, read.csv)
  datalist = do.call("rbind", datalist)  
  datalist<-unique(datalist)
  #datalist[datalist== ""] <- NA
  datalist
}

