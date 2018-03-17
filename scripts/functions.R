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


cleanstring<-function(x){
  vector<-as.character(x)
  vector[stri_length(vector)<2]<-""
  # Delete When the number of points is half the lenght of the string
  vector[str_count(vector, "\\.")/stri_length(vector)>=.5]<-""
  # Delete sequence of numbers at the begining
  vector<-sub("^[[:digit:]]+ \\: +", "", vector)
  # Delete characters between blanks and with a point if Upper Case (105760)
  vector<-gsub("* [[:upper:]]\\. +", " ", vector)
  # Delete characters between blanks if Upper Case (105576)
  vector<-gsub("* [[:upper:]] +", " ", vector)
  # Delete first character after a point
  vector<-sub("^.?\\.", "", vector)
  # Delete first character after a point (1172)
  vector<-sub("^.?\\.", "", vector)
  # Delete first character after a point
  vector<-sub("^.?\\.", "", vector)
  # Delete last character after a point if Upper Case
  vector<-gsub("[[:upper:]]\\.$", "", vector)
  # Delete last point
  vector<-sub("\\.$", "", vector)
  # Delete last -
  vector<-sub("\\-$", "", vector)
  # Delete begining -
  vector<-sub("^\\-", "", vector)
  # Change 0 by O
  vector<-gsub("0", "O", vector)
  # Change 1 by I
  vector<-gsub("1", "I", vector)
  # Change 3 by "
  vector<-gsub("3", "", vector)
  # Delete first letter and then a blank (46)
  vector<-sub("^[[:upper:]] +", "", vector) 
  # Delete blank and last letter (179, 105469)
  vector<-sub("* [[:upper:]]$", "", vector)
  # á
  vector<-gsub("\\{acute\\s+over\\s+\\(α\\)\\}", "á", vector)
  # ñ
  vector<-gsub("\\{hacek\\s+over\\s+\\(n\\)\\}", "ñ", vector)
  # r
  vector<-gsub("\\{{grave\\s+over\\s+\\(r\\)\\}", "r̀", vector)
  # Delete text between parenthesis (106691)
  vector<-sub("\\s*\\([^\\)]+\\)", "", vector) 
  
  # Delete "- " (65238)
  vector<-gsub("- ", " ", vector) 
  # Delete +di (106731)
  vector<-sub(" \\+di", "", vector)
  # Delete points
  vector<-gsub("\\.", " ", vector)
  # Delete Jr (65238,65284, 105688)
  vector<-sub("* +(JR .|Jr .|jr .|JR\\. .|Jr\\. .|SR .|Sr .|sr .|SR\\. .|Sr\\. .)", "", vector)
  # Delete Jr at the begining
  vector<-sub("^(JR .|Jr .|jr .|JR\\. .|Jr\\. .|SR .|Sr .|sr .|SR\\. .|Sr\\. .)", "", vector)
  # Delete Jr at the end
  vector<-sub(" +(JR|Jr|jr|JR\\.|Jr\\.|SR|Sr|sr|SR\\.|Sr\\.)$", "", vector)

  # # Delete Sr (106361)
  # vector<-sub("* +()", "", vector)
  # # Delete Sr at the begining
  # vector<-sub("^()", "", vector)
  # Delete Dr,
  vector<-sub("* +(DR .|Dr.|dr .|DR\\. .|Dr\\. .|Mr .|MR .|Mr\\. .|MR\\. .|Md .|MD .|Md\\. .|MD\\. .|Prof .|Prof\\. .)", "", vector)
  # Delete Dr at the begining
  vector<-sub("^(DR .|Dr .|dr .|DR\\. .|Dr\\. .|Mr .|MR .|Mr\\. .|MR\\. .|Md .|MD .|Md\\. .|MD\\. .|Prof .|Prof\\. .)", "", vector)
  # Delete at the end
  vector<-sub(" +(DR|Dr|dr|DR\\.|Dr\\.|Mr|MR|Mr\\.|MR\\.|Md|MD|Md\\.|MD\\.|Prof|Prof\\.)$", "", vector)
  # Letters with accents: (4682)
  vector<-gsub("acute;+", "", vector)
  vector<-gsub("&", "", vector)

  # ç
  vector<-gsub("Ã§", "ç", vector)
  # ú 27985
  vector<-gsub("Ãº", "ú", vector)
  # é 27418
  vector<-gsub("Ã©", "é", vector)


  # Delete characters between blanks if Upper Case
  vector<-gsub("* [[:upper:]] +", " ", vector)
  # Delete extra espaces
  vector<-sub("\\s+", " ", str_trim(vector))
  # Delete II, III or IV, V, VI
  vector<-sub(" +(II|III|IV|V)$", "", vector)
  # All after "; c/o " 26693, 7783
  vector<-sub(";?\\s?(c/o|C/o|C/O|c/O|c/c|C/C)+(.*)", "", vector)
  # All after legal, 4890
  vector<-sub(";?\\s?(legal|Legal|LEGAL|IBM |Universität|University|Universiteit|Universiteit|Lund Institute|Hewlett-Packard|QUALCOMM|Ludwig Ins|Division |Department|Research|The\\s+|the\\s+|Pfizer|PFIZER|EASTMAN KODAK|Eastman Kodak|Microsfot|Microsoft|Univ |Dept |Office|Management|Massachusetts|National|Apartment|SmithKline|Pharm Res|Unilever|)+(.*)", "", vector)
  # Delete extra espaces
  vector<-sub("\\s+", " ", str_trim(vector))
  # Deleting again single characters
  vector[stri_length(vector)<2]<-""

  return(vector)
}

#cleanstring("Kari	C/OMolecular/Cancer Biology Laboratory")



cleannames_one<-function(query, filename=NULL){
  df<-dbGetQuery(patstat, query)
  print(paste("Number of rows:", nrow(df)))
  print(paste("Distinct IDs:",length(unique(df$finalID))))
  
  df.m<-str_split(df$name, ", ",  simplify=TRUE)
  df.m<-as.data.frame(df.m)
  df$firstname<-as.character(df.m[,2])
  df$lastname<-as.character(df.m[,1])
  
  df_c<-df[toupper(df$firstname)!='INC.' & toupper(df$firstname)!='INC' & toupper(df$firstname)!='LLC.' & toupper(df$firstname)!='LLC' & toupper(df$firstname)!='LTD.' & toupper(df$firstname)!='LTD' & toupper(df$lastname)!='INC.' & toupper(df$lastname)!='INC' & toupper(df$lastname)!='LLC.' & toupper(df$lastname)!='LLC' & toupper(df$lastname)!='LTD.' & toupper(df$lastname)!='LTD',]
  # df_c<-df_c[toupper(df_c$lastname)!='INC.' & toupper(df_c$lastname)!='LLC.' & toupper(df_c$lastname)!='LTD.',]
  
  df_nc<-df[toupper(df$firstname)=='INC.' | toupper(df$firstname)=='INC' | toupper(df$firstname)=='LLC.' | toupper(df$firstname)=='LLC' | toupper(df$firstname)=='LTD.' | toupper(df$firstname)=='LTD' | toupper(df$lastname)=='INC.' | toupper(df$lastname)=='INC' | toupper(df$lastname)=='LLC.' | toupper(df$lastname)=='LLC' | toupper(df$lastname)=='LTD.' | toupper(df$lastname)=='LTD',]
  
  df_c$firstname<-cleanstring(df_c$firstname)
  df_c$lastname<-cleanstring(df_c$lastname)
  
  df_c$full<-as.character(paste0(ifelse(df_c$firstname=="", "",paste0(df_c$firstname, " ")), df_c$lastname))
  
  write.csv(df_c, paste0("../output/nationality/", filename, "_c.csv"))
  write.csv(df_nc, paste0("../output/nationality/", filename, "_nc.csv"))
  return(list(df_c, df_nc))
}