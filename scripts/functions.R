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
  # Delete all after a sequence of numbers
  vector<-gsub("[[:digit:]]{2,}(.*)", "", vector)
  # Delete begining -
  vector<-sub("\\:", "", vector)

  
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
  vector<-gsub("\\{dot\\s+over\\s+\\(a\\)\\}", "Ȧ", vector)
  # ñ
  vector<-gsub("\\{hacek\\s+over\\s+\\(n\\)\\}", "ñ", vector)
  vector<-gsub("\\{overscore\\s+\\(n\\)\\}", "ñ", vector)
  
  vector<-gsub("\\{hacek\\s+over\\s+\\(o\\)\\}", "o", vector)
  vector<-gsub("\\{hacek\\s+over\\s+\\(g\\)\\}", "ǧ", vector)
  vector<-gsub("\\{hacek\\s+over\\s+\\(c\\)\\}", "č", vector)
  vector<-gsub("\\{hacek\\s+over\\s+\\(z\\)\\}", "ž", vector)
  vector<-gsub("\\{hacek\\s+over\\s+\\(S\\)\\}", "š", vector)
  vector<-gsub("\\{hacek\\s+over\\s+\\(r\\)\\}", "ř", vector)
  # r
  vector<-gsub("\\{grave\\s+over\\s+\\(r\\)\\}", "r̀", vector)
  vector<-gsub("\\{grave\\s+over\\s+\\(s\\)\\}", "s̀", vector)
  #
  vector<-gsub("\\{grave\\s+over\\s+\\(D\\)\\}", "D", vector)
  
  vector<-gsub("\\{umlaut\\s+over\\s+\\(w\\)\\}", "ẅ", vector)

  
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
  #print(vector)
  # Delete Dr at the begining
  vector<-sub("^(DR .|Dr .|dr .|DR\\. .|Dr\\. .|Mr .|MR .|Mr\\. .|MR\\. .|Md .|MD .|Md\\. .|MD\\. .|Prof .|Prof\\. .)", "", vector)
  #print(vector)
  # Delete at the end
  vector<-sub(" +(DR|Dr|dr|DR\\.|Dr\\.|Mr|MR|Mr\\.|MR\\.|Md|MD|Md\\.|MD\\.|Prof|Prof\\.|Mrs\\.|MRS\\.|MRs\\.)$", "", vector)
  vector<-gsub("&Oslash;", "Ø", vector)
  vector<-gsub("OSLASHED\\s", "Ø", vector)
  
  vector<-sub(";?\\s?(Johnson\\s+&\\s+Johnson)+(.*)", "", vector)
  
  
  # Letters with accents: (4682)
  vector<-gsub("acute;+", "", vector)
  vector<-gsub("&", "", vector)
  
  
  # UTF 8: http://www.e-bancel.com/codes_utf8_caracteres_accentues.php
  # ç
  vector<-gsub("Ã§", "ç", vector)
  # ú 27985
  vector<-gsub("Ãº", "ú", vector)

  # á 29260
  vector<-gsub("Ã¡", "á", vector)
  vector<-gsub("Ã ", "à", vector)
  vector<-gsub("Ã¢", "â", vector)
  vector<-gsub("Ã£", "ã", vector)
  vector<-gsub("Ã„", "Ä", vector)
  vector<-gsub("Ã¤", "ä", vector)
  vector<-gsub("Ã€", "À", vector)
  
  # é 27418
  vector<-gsub("Ã©", "é", vector)
  vector<-gsub("Ã¨", "è", vector)
  vector<-gsub("Ãª", "ê", vector)
  vector<-gsub("Ã«", "ë", vector)
  vector<-gsub("Ã‰", "É", vector)
  
  # i
  vector<-gsub("Ã®", "î", vector)
  vector<-gsub("Ã¯", "ï", vector)

  
  # o
  vector<-gsub("Ã´", "ô", vector)
  vector<-gsub("Ã¶", "ö", vector)
  vector<-gsub("Ã³", "ó", vector)
  vector<-gsub("Ã¸", "ø", vector)
  vector<-gsub("Ã“", "Ó", vector)
  vector<-gsub("Ã˜", "Ø", vector)
  vector<-gsub("Ã’", "Ò", vector)
  vector<-gsub("Ã–", "Ö", vector)

  # u
  vector<-gsub("Ã¹", "ù", vector)
  vector<-gsub("Ã»", "û", vector)
  vector<-gsub("Ã¼", "ü", vector)
  vector<-gsub("Ãœ", "Ü", vector)
  
  # ß
  vector<-gsub("ÃŸ", "ß", vector)
  
  vector<-gsub("Ã‘", "Ñ", vector)
  #
  vector<-gsub("Ã¥", "å", vector)

 
  
  # Delete characters between blanks if Upper Case
  vector<-gsub("* [[:upper:]] +", " ", vector)
  # Delete extra espaces
  vector<-sub("\\s+", " ", str_trim(vector))
  # Delete II, III or IV, V, VI
  vector<-sub(" +(II|III|IV|V)$", "", vector)
  # All after "; c/o " 26693, 7783
  vector<-sub(";?\\s?(c/o|C/o|C/O|c/O|c/c|C/C|c/|C/O)+(.*)", "", vector)
  # All after legal, 4890
  vector<-sub(";?\\s?(legal|Legal|LEGAL|IBM |Universität|University|Universiteit|Universiteit|Lund Institute|Hewlett-Packard|QUALCOMM|Ludwig Ins|Division |Department|Research|The\\s+|the\\s+|THE\\s+|Pfizer|PFIZER|EASTMAN KODAK|Eastman Kodak|Microsfot|Microsoft|Univ |Uni |Dept |Dep |Inst |Ins |Office|Management|Massachusetts|National|Apartment|SmithKline|Pharm Res|Unilever|Université)+(.*)", "", vector)
  vector<-sub(";?\\s?(EMULEX|Honeywell Inte|Neuroscience|CITRIX|Children|Hospital|Laboratory|Ctr f|LAB |Lab |Tokyo|Graduate|United|Plant|Institute|Institut|UTSW|Glaxo |Chiron Corp|Syngenta|Swedish Medical|Syngenta|Lsu Medical|MBG Business|School|Pioneer |Sony|Boehringer|Orthopedics|Pharmacia|Rhone-Poulenc|Kyowa|RICOH|European|MINNESOTA|Minnesota|Molecular|Ribo Targets|Public|Pharmaceutical|Corporate|VaxGen|BMFZ\\s+und|Facildade\\s+de|Custom\\s+|OSI\\s+Pharma|ALBERT\\s+EINSTEIN\\s+COLL|CORPORATION|ADMINISTRATOR|OLD\\s+NATION)+(.*)", "", vector)
  #31831
  vector<-sub(";?\\s?(Qualcomm|Clinical|Orion Cor|Orb Net|Ricoh|Mobay Ch|GlaxoSm|Bio-Defense|Novartis|FUJITSU|Kirin Beer|American Expr|Hatfield Marine|Cent\\s+for\\s+Imm|Embarcadero Sys|Southwestern|Pres\\s+Fellow|LAURA\\s+DUPRIEST|NTT DoCoMo|Pysician|Postech|NCR Corpo|Imperial Canc|Chron\\s+Corp|JP\\s+Morgan\\s+Chas|Systems\\s+|4th|Quality\\s+Met|Alister\\s+Bioco|Clinical|UOP\\s+LLC|Vestek\\s+Elek|AstraZeneca|Segretaria|GlaxoSmit|Fachrichtung|Prosidion|Emulex\\s+De|DBLive|AOP\\s+LLC|ASTON\\s+LANE|INV\\s+BIOMEDICAS|Faculty|International|Motorola|Société|Neurog\\s+)+(.*)", "", vector)
  #print(vector)
  vector<-sub(";?\\s?(MIT Tec|Toshiba|Bio |Celartem|DuPont Ag|MENICON |Vestel Elektro|Pennsylvania|Panasonic|Rensselaer Polytec|Lilly Forsc|Organon|Pennsylvania|College|Istituto|Westar\\s+BioEng|Universitet|Malaria\\s+Vacci|Pres\\s+Fel|Shanghai Ge|Dow Global|LLC\\s+|INC\\s+|Inc\\s+|Corporation|Healthcare|HP\\s+Compan|Flat\\s+|Kanebo\\s+Cos|Univalid\\s+Bio|Amersham\\s+He|Pharma\\s+M|Solvay\\s+Pha|2|Eisai\\s+Inc|HGM-McMaster|Deaconess\\s+Me|Wisconsin|Russian\\s+Aca|Cancer\\s+Res|BAE\\s+SYSTE|TETREL\\s+TECH|PHYSICANS|MICROBIOLOGICAL|ARIZONA\\s+CAN|YALE\\s+CAN)+(.*)", "", vector)
  vector<-sub(";?\\s?(Falk\\s+Cardiovascular|Biovail\\s+Techn|Micro-Integration|Mircrosoft|Huntsman\\s+Cancer|Mount\\s+Sinai\\s+School|Datascope|International|DOW\\s+CORNING|PETROBAS\\s+|Hewlett\\s+Packard|Alistair\\s+British|Fujitsu\\s+Lim|Intellectual\\s+Property|Synaptics|Oxford\\s+BioMedica)+(.*)", "", vector)
  
  #print(vector)
  vector<-gsub("\\s+DE$", "", vector)

  # Delete extra espaces
  vector<-sub("\\s+", " ", str_trim(vector))
  # Deleting again single characters
  vector[stri_length(vector)<2]<-""

  #vector<-sub("\\s", "\\-", vector)
  # FUTURE WORK
  # To define later: information in parenthesis can help to identify same person
  # Née, Born, can be useful to identify married women
  return(vector)
}

#cleanstring("VINCENT")



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

cleannames_two<-function(query, filename=NULL){
  df<-dbGetQuery(patstat, query)
  print(paste("Number of rows:", nrow(df)))
  print(paste("Distinct IDs:",length(unique(df$finalID))))
  
  df.m<-str_split(df$name, ", ",  simplify=TRUE)
  df.m<-as.data.frame(df.m)
  df$firstname<-as.character(df.m[,2])
  df$lastname<-as.character(df.m[,1])
  df$complement<-as.character(df.m[,3])
  
  df_c<-df[toupper(df$firstname)!='INC.' & toupper(df$firstname)!='INC' & toupper(df$firstname)!='LLC.' & toupper(df$firstname)!='LLC' & toupper(df$firstname)!='LTD.' & toupper(df$firstname)!='LTD' & toupper(df$lastname)!='INC.' & toupper(df$lastname)!='INC' & toupper(df$lastname)!='LLC.' & toupper(df$lastname)!='LLC' & toupper(df$lastname)!='LTD.' & toupper(df$lastname)!='LTD' & toupper(df$complement)=='INC.' & toupper(df$complement)=='INC' & toupper(df$complement)=='LLC.' & toupper(df$complement)=='LLC' & toupper(df$complement)=='LTD.' & toupper(df$complement)=='LTD',]
  # df_c<-df_c[toupper(df_c$lastname)!='INC.' & toupper(df_c$lastname)!='LLC.' & toupper(df_c$lastname)!='LTD.',]
  
  df_nc<-df[toupper(df$firstname)=='INC.' | toupper(df$firstname)=='INC' | toupper(df$firstname)=='LLC.' | toupper(df$firstname)=='LLC' | toupper(df$firstname)=='LTD.' | toupper(df$firstname)=='LTD' | toupper(df$lastname)=='INC.' | toupper(df$lastname)=='INC' | toupper(df$lastname)=='LLC.' | toupper(df$lastname)=='LLC' | toupper(df$lastname)=='LTD.' | toupper(df$lastname)=='LTD'| toupper(df$complement)=='INC.' | toupper(df$complement)=='INC' | toupper(df$complement)=='LLC.' | toupper(df$complement)=='LLC' | toupper(df$complement)=='LTD.' | toupper(df$complement)=='LTD',]
  
  df_c$firstname<-cleanstring(df_c$firstname)
  df_c$lastname<-cleanstring(df_c$lastname)
  df_c$complement<-cleanstring(df_c$complement)
  
  
  df_c$full<-as.character(paste0(ifelse(df_c$firstname=="", "",paste0(df_c$firstname, " ")), df_c$lastname))
  
  write.csv(df_c, paste0("../output/nationality/", filename, "_c.csv"))
  write.csv(df_nc, paste0("../output/nationality/", filename, "_nc.csv"))
  return(list(df_c, df_nc))
}

##Partial Matching Function

##Here's where the algorithm starts...
##I'm going to generate a signature from country names to reduce some of the minor differences between strings
##In this case:
### convert all characters to lower case (tolower())
### split the string into a vector (unlist()) of separate words (strsplit())
### sort the words alphabetically (sort())
### and then concatenate them with no spaces (paste(y,collapse='')).
##So for example, United Kingdom would become kingdomunited
##To extend this function, we might also remove stopwords such as 'the' and 'of', for example (not shown).
signature=function(x){
  sig=paste(sort(unlist(strsplit(tolower(x)," "))),collapse='')
  return(sig)
}

###############################################
# Partial Matching Function
# Taken from https://blog.ouseful.info/2012/09/26/merging-data-sets-based-on-partially-matched-data-elements/
###############################################
#The partialMatch function takes two wordlists as vectors (x,y) and an optional distance threshold (levDist)
#The aim is to find words in the second list (y) that match or partially match words in the first (x)
partialMatch=function(x,y,levDist=0.1){
  #Create a data framecontainind the signature for each word
  xx=data.frame(sig=sapply(x, signature),row.names=NULL)
  yy=data.frame(sig=sapply(y, signature),row.names=NULL)
  #Add the original words to the data frame too...
  xx$raw=x
  yy$raw=y
  #We only want words that have a signature...
  xx=subset(xx,subset=(sig!=''))
  
  #The first matching pass - are there any rows in the two lists that have exactly the same signature?
  xy<-merge(xx,yy,by='sig',all=T)
  matched<-subset(xy,subset=(!(is.na(raw.x)) & !(is.na(raw.y))))
  #?I think matched=xy[ complete.cases(raw.x,raw.y) ] might also work here?
  #Label the items with identical signatures as being 'Duplicate' matches
  #matched$pass="Duplicate"
  if (nrow(matched) > 0) matched$pass= "Duplicate"
  #Grab the rows from the first list that were unmatched - that is, no matching item from the second list appears
  todo=subset(xy,subset=(is.na(raw.y)),select=c(sig,raw.x))
  #We've grabbed the signature and original raw text from the first list that haven't been matched up yet
  #Name the columns so we know what's what
  colnames(todo)=c('sig','raw')
  
  #This is the partial matching magic - agrep finds items in the second list that are within a 
  ## certain Levenshtein distance of items in the first list.
  ##Note that I'm finding the distance between signatures.
  todo$partials= as.character(sapply(todo$sig, agrep, yy$sig,max.distance = levDist,value=T))
  
  #Bring the original text into the partial match list based on the sig key.
  todo=merge(todo, yy, by.x= 'partials', by.y= 'sig', all.x=T)
  
  #Find the items that were actually partially matched, and pull out the columns relating to signatures and raw text
  partial.matched=subset(todo,subset=(!(is.na(raw.x)) & !(is.na(raw.y))),select=c("sig","raw.x","raw.y"))
  #Label these rows as partial match items
  if (nrow(partial.matched) > 0) partial.matched$pass= "Partial"
  #Add the set of partially matched items to the set of duplicate matched items
  matched=rbind(matched,partial.matched)
  
  #Find the rows that still haven't been matched
  un.matched=subset(todo,subset=(is.na(raw.x)),select=c("sig","raw.x","raw.y"))
  
  #If there are any unmatched rows, add them to the list of matched rows, but labelled as such
  if (nrow(un.matched)>0){
    un.matched$pass="Unmatched"
    matched=rbind(matched,un.matched)
  }
  
  #Grab the columns of raw text from x and y from the matched list, along with how they were matched/are unmatched
  matched=subset(matched,select=c("raw.x","raw.y","pass"))
  #Ideally, the length of this should be the same as the length of valid rows in the original first list (x)
  
  return(matched)
}

mergeinvpat<-function(pnumber, ep.df=eqpat.df, e8.df=eq08.df){
  print(pnumber)
  one<-ep.df[ep.df$pat==pnumber,]
  two<-e8.df[e8.df$pat==pnumber,]
  one$PERSON_NAME<-toupper(one$PERSON_NAME)
  two$name<-toupper(two$name)
  matches<-partialMatch(one$PERSON_NAME, two$name, levDist=0.1)
  # Merge one with match
  result<-merge(one,matches,by.x="PERSON_NAME",by.y='raw.x',all.x=T)
  # Merge two with match
  result<-merge(result,two,by.x='raw.y',by.y="name",all.x=T)
  write.csv(result, paste0("../output/matched_names/", pnumber, ".csv"))
  
  return("Done")
}

mergeinvpat_fast<-function(one=eqpat.df, two=eq08.df){
  one$PERSON_NAME<-paste(one$pat, toupper(one$PERSON_NAME))
  two$name<-paste(two$pat, toupper(two$name))
  matches<-partialMatch(one$PERSON_NAME, two$name, levDist=0.1)
  # Merge one with match
  result<-merge(one,matches,by.x="PERSON_NAME",by.y='raw.x',all.x=T)
  # Merge two with match
  result<-merge(result,two,by.x='raw.y',by.y="name",all.x=T)
  
  return(result)
}


merge.list = function(datalist){
  datalist = do.call("rbind", datalist)  
  datalist<-unique(datalist)
  #datalist[datalist== ""] <- NA
  datalist
}
