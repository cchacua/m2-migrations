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
  datalist = lapply(filenames, read.csv, stringsAsFactors = FALSE)
  datalist = do.call("rbind", datalist)  
  datalist<-unique(datalist)
  #datalist[datalist== ""] <- NA
  datalist
}


setnatdf<-function(output){
df<-data.frame(full_name=output[,2])
df$nationality<-colnames(output[,5:43])[apply(output[,5:43], 1, which.max)]
df$probability<-apply(output[,5:43], 1, max)
df<-df[,c("full_name", "nationality", "probability")]
df<-as.data.frame(list(df, output))
# Replace Hispanic-Portguguese to Hispanic-Portuguese

return(df)
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
  # Delete only
  vector<-sub("^(JR|Jr|jr|JR\\.|Jr\\.|SR|Sr|sr|SR\\.|Sr\\.|INC|IN|In|Inc)$", "", vector)
  
 
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
  # Delete only case
  vector<-sub("^(DR|Dr|dr|DR\\.|Dr\\.|Mr|MR|Mr\\.|MR\\.|Md|MD|Md\\.|MD\\.|Prof|Prof\\.|Mrs\\.|MRS\\.|MRs\\.)$", "", vector)
  
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
  vector<-sub("^(I|II|III|IV|V|VI|i|ii|iii|iv|v|vi|Ii|Iii|Iv|Vi|nny|S-|SRL|Uop\\s+Llc)$", "", vector)
  # All after "; c/o " 26693, 7783
  vector<-sub(";?\\s?(c/o|C/o|C/O|c/O|c/c|C/C|c/|C/O)+(.*)", "", vector)
  # All after legal, 4890
  vector<-sub(";?\\s?(Newcastle|Duke\\s+University|Johnson&Johnson|Coop\\s+Res|Rhône-Poul|California|du\\s+Sacre|SONY|Depart\\s+|ACS\\s+Dob|Imperial|Epoch\\s+Medical|NV\\s+Organon|Tsukuba\\s+Hisamitsu|Osaca|Glaxo|UCLA\\s+|Duke\\s+U|Sygen\\s+Inte|Ecole\\s+Sup|Agouron\\s+Pha|KULeuven|KU\\s+Leuven|Centre\\s+fo|Advanced|Ca\\s+Lab|Solvay|Northrop|Div\\s+Bioeng|Wellman\\s+Lab|Rush-Presbyterian|Japan\\s+Tobacco|Niigata\\s+Uni|GE\\s+Healthcar|Electrical\\s+En|SmithKl\\s+Bee|Conopco|Memorial\\s+Sloan|New\\s+York|Dpt\\s+of|Walter\\s+Reed\\s+Ar|Celera\\s+Geno|IntraMedical\\s+Imag|Alliance\\s+Prot|SM\\s+Chemicals|MRC\\s+Human|Emisphere\\s+Tec|Rua\\s+Onze)+(.*)", "", vector)
  vector<-sub(";?\\s?(Montana\\s+State|Yale\\s+University|RWTH\\s+Aachen|Laban\\s+Inter|Osaka\\s+Un|Hanoi\\s+Colle|Indian\\s+Stati|JohnsonJohnson|Southend\\s+Main\\s+Ro|Oxford\\s+Glyc|NATIONAL|Corner\\s+of|Scynexis|Cntr\\s+Dis|ITT\\s+Automotive|CA\\s+Lab|Tsukuba\\s+HISAMITSU|JP\\s+Tabacco|Japan|Manugistics|Computer|Chugai\\s+Bioph|UECKER\\s+ASSO|Aston\\s+Lane|Saratoga\\s+Garden|Eli\\s+Lilly\\s+an|Belcan\\s+Corp|Résidence|Smithkline|Western\\s+General|State\\s+Oceanic|Dreamhouse\\s+Software|Uhlig\\s+LLC|San\\s+Franci|Award\\s+Software|Top\\s+Global|Signature\\s+Control|Kobo\\s+Products|Sajjaingadh\\s+Housing|Broadcom|Dow\\s+Agrosci|Internat\\s+Paten|Janssen\\s+Pharm)+(.*)", "", vector)
  
  vector<-sub(";?\\s?(legal|Legal|LEGAL|IBM |Universität|University|Universiteit|Universiteit|Lund Institute|Hewlett-Packard|QUALCOMM|Ludwig Ins|Division |Department|Research|The\\s+|the\\s+|THE\\s+|Pfizer|PFIZER|EASTMAN KODAK|Eastman Kodak|Microsfot|Microsoft|Univ |Uni |Dept |Dep |Inst |Ins |Office|Management|Massachusetts|National|Apartment|SmithKline|Pharm Res|Unilever|Université|LG\\s+Life\\+sScie|Iatron\\s+Labora)+(.*)", "", vector)
  vector<-sub(";?\\s?(EMULEX|Honeywell Inte|Neuroscience|CITRIX|Children|Hospital|Laboratory|Ctr f|LAB |Lab |Tokyo|Graduate|United|Plant|Institute|Institut|UTSW|Glaxo |Chiron Corp|Syngenta|Swedish Medical|Syngenta|Lsu Medical|MBG Business|School|Pioneer |Sony|Boehringer|Orthopedics|Pharmacia|Rhone-Poulenc|Kyowa|RICOH|European|MINNESOTA|Minnesota|Molecular|Ribo Targets|Public|Pharmaceutical|Corporate|VaxGen|BMFZ\\s+und|Facildade\\s+de|Custom\\s+|OSI\\s+Pharma|ALBERT\\s+EINSTEIN\\s+COLL|CORPORATION|ADMINISTRATOR|OLD\\s+NATION)+(.*)", "", vector)
  #31831
  vector<-sub(";?\\s?(Qualcomm|Clinical|Orion Cor|Orb Net|Ricoh|Mobay Ch|GlaxoSm|Bio-Defense|Novartis|FUJITSU|Kirin Beer|American Expr|Hatfield Marine|Cent\\s+for\\s+Imm|Embarcadero Sys|Southwestern|Pres\\s+Fellow|LAURA\\s+DUPRIEST|NTT DoCoMo|Pysician|Postech|NCR Corpo|Imperial Canc|Chron\\s+Corp|JP\\s+Morgan\\s+Chas|Systems\\s+|4th|Quality\\s+Met|Alister\\s+Bioco|Clinical|UOP\\s+LLC|Vestek\\s+Elek|AstraZeneca|Segretaria|GlaxoSmit|Fachrichtung|Prosidion|Emulex\\s+De|DBLive|AOP\\s+LLC|ASTON\\s+LANE|INV\\s+BIOMEDICAS|Faculty|International|Motorola|Société|Neurog\\s+)+(.*)", "", vector)
  #print(vector)
  vector<-sub(";?\\s?(MIT Tec|Toshiba|Bio |Celartem|DuPont Ag|MENICON |Vestel Elektro|Pennsylvania|Panasonic|Rensselaer Polytec|Lilly Forsc|Organon|Pennsylvania|College|Istituto|Westar\\s+BioEng|Universitet|Malaria\\s+Vacci|Pres\\s+Fel|Shanghai Ge|Dow Global|LLC\\s+|INC\\s+|Inc\\s+|Corporation|Healthcare|HP\\s+Compan|Flat\\s+|Kanebo\\s+Cos|Univalid\\s+Bio|Amersham\\s+He|Pharma\\s+M|Solvay\\s+Pha|2|Eisai\\s+Inc|HGM-McMaster|Deaconess\\s+Me|Wisconsin|Russian\\s+Aca|Cancer\\s+Res|BAE\\s+SYSTE|TETREL\\s+TECH|PHYSICANS|MICROBIOLOGICAL|ARIZONA\\s+CAN|YALE\\s+CAN)+(.*)", "", vector)
  vector<-sub(";?\\s?(Falk\\s+Cardiovascular|Biovail\\s+Techn|Micro-Integration|Mircrosoft|Huntsman\\s+Cancer|Mount\\s+Sinai\\s+School|Datascope|International|DOW\\s+CORNING|PETROBAS\\s+|Hewlett\\s+Packard|Alistair\\s+British|Fujitsu\\s+Lim|Intellectual\\s+Property|Synaptics|Oxford\\s+BioMedica|CareerBuilder|Xicor|Pharmanex|Asynchrony|Ribapharm|ADSI|Genetech)+(.*)", "", vector)

  
  
  
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
  # 
  df.m<-str_split(df$name, ", ", n=3, simplify=TRUE)
  df.m<-as.data.frame(df.m)
  df$firstname<-as.character(df.m[,2])
  df$lastname<-as.character(df.m[,1])
  df$complement<-as.character(df.m[,3])
  # 
  # df_c<-df[toupper(df$firstname)!='INC.' & toupper(df$firstname)!='INC' & toupper(df$firstname)!='LLC.' & toupper(df$firstname)!='LLC' & toupper(df$firstname)!='LTD.' & toupper(df$firstname)!='LTD' & toupper(df$lastname)!='INC.' & toupper(df$lastname)!='INC' & toupper(df$lastname)!='LLC.' & toupper(df$lastname)!='LLC' & toupper(df$lastname)!='LTD.' & toupper(df$lastname)!='LTD' & toupper(df$complement)!='INC.' & toupper(df$complement)!='INC' & toupper(df$complement)!='LLC.' & toupper(df$complement)!='LLC' & toupper(df$complement)!='LTD.' & toupper(df$complement)!='LTD',]
  # # df_c<-df_c[toupper(df_c$lastname)!='INC.' & toupper(df_c$lastname)!='LLC.' & toupper(df_c$lastname)!='LTD.',]
  # 
  # df_nc<-df[toupper(df$firstname)=='INC.' | toupper(df$firstname)=='INC' | toupper(df$firstname)=='LLC.' | toupper(df$firstname)=='LLC' | toupper(df$firstname)=='LTD.' | toupper(df$firstname)=='LTD' | toupper(df$lastname)=='INC.' | toupper(df$lastname)=='INC' | toupper(df$lastname)=='LLC.' | toupper(df$lastname)=='LLC' | toupper(df$lastname)=='LTD.' | toupper(df$lastname)=='LTD'| toupper(df$complement)=='INC.' | toupper(df$complement)=='INC' | toupper(df$complement)=='LLC.' | toupper(df$complement)=='LLC' | toupper(df$complement)=='LTD.' | toupper(df$complement)=='LTD',]

  df_c<-df[toupper(df$firstname)!='INC.' & toupper(df$firstname)!='INC' & toupper(df$firstname)!='LLC.' & toupper(df$firstname)!='LLC' & toupper(df$firstname)!='LTD.' & toupper(df$firstname)!='LTD' & toupper(df$lastname)!='INC.' & toupper(df$lastname)!='INC' & toupper(df$lastname)!='LLC.' & toupper(df$lastname)!='LLC' & toupper(df$lastname)!='LTD.' & toupper(df$lastname)!='LTD',]
  df_nc<-df[toupper(df$firstname)=='INC.' | toupper(df$firstname)=='INC' | toupper(df$firstname)=='LLC.' | toupper(df$firstname)=='LLC' | toupper(df$firstname)=='LTD.' | toupper(df$firstname)=='LTD' | toupper(df$lastname)=='INC.' | toupper(df$lastname)=='INC' | toupper(df$lastname)=='LLC.' | toupper(df$lastname)=='LLC' | toupper(df$lastname)=='LTD.' | toupper(df$lastname)=='LTD',]
  
  
  df_c$firstname<-cleanstring(df_c$firstname)
  df_c$lastname<-cleanstring(df_c$lastname)
  df_c$complement<-cleanstring(df_c$complement)


  df_c$full<-as.character(paste0(ifelse(df_c$firstname=="", "",paste0(df_c$firstname, " ")), ifelse(df_c$complement=="", "",paste0(df_c$complement, " ")), df_c$lastname))

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
open.rdata<-function(x){local(get(load(x)))}

distances_aslist<-function(graph_element){
  distance<-distances(graph_element)
  distance.l<-melt(distance)
  distance.l<-distance.l[distance.l$value!=0,]
  return(distance.l)
}

distanceoneline<-function(onerow, graph_element){
  vfrom<-V(graph_element)[V(graph_element)$name == onerow[1]]
  vto<-V(graph_element)[V(graph_element)$name == onerow[2]]
  dline<-distances(graph_element, v=vfrom, to=vto, weights = NULL)
  dline<-melt(dline)
  return(dline)
}

ugraphinv_dis_line<-function(endyear, withplot=FALSE){
  inityear<-endyear-4
  linkyear<-endyear+1
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  uedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                        FROM riccaboni.edges_undir_pyr 
                                        WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                        ORDER BY EARLIEST_FILING_YEAR"))
  dedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                        FROM riccaboni.edges_undid_ud
                                        WHERE EARLIEST_FILING_YEAR=",linkyear))
  print("Data has been loaded")
  print(paste("Number of total edges",nrow(uedges)))
  print(paste("Number of edges to find",nrow(dedges), nrow(dedges)/nrow(uedges)))
  uedges<-as.matrix(uedges)
  graph<-graph_from_edgelist(uedges, directed = FALSE)
  rm(uedges)
  save(graph, file=paste0("../output/graphs/networks/",inityear,"-",endyear, "_network", ".RData"))
  print("Graph has been done and saved")


  distances_outdf<-apply(dedges, 1, distanceoneline, graph_element=graph)
  print("Distances have been computed")
  distances_outdf<-merge.list(distances_outdf)
  distances_outdf$lyear<-linkyear
  # components<-decompose.graph(graph, min.vertices=1)
  # distances_outlist<-lapply(components, distances_aslist)
  # distances_outdf<-merge.list(distances_outlist)
  # distances_outdf$lyear<-linkyear
  write.csv(distances_outdf, paste0("../output/graphs/distance_list/",inityear,"-",endyear, "_list", ".csv"))
  
  if(withplot==TRUE){
    graph.l<-layout_with_drl(graph, options=list(simmer.attraction=0))
    print("Layout has been done")
    pdf(paste0("../output/graphs/images/",inityear,"-",endyear, "_plot", ".pdf"))
    plot(graph, layout=graph.l, vertex.label=NA, vertex.frame.color=NA, vertex.size=0.7, edge.width=0.4)
    dev.off()
    print("Plot has been done")
  }
  
  return("Done")
}

ugraphinv_dis_bulk<-function(endyear, withplot=FALSE, sector="ctt"){
  print("Sector should be pboc or ctt")
  inityear<-endyear-4
  linkyear<-endyear+1
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  uedges<-as.data.table(dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                     FROM riccaboni.edges_undir_pyr", sector,
                                     " WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                     ORDER BY EARLIEST_FILING_YEAR")))
  dedges<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT finalID AS finalID_, finalID_ AS finalID__, undid
                                     FROM riccaboni.count_edges_", sector, 
                                     " WHERE EARLIEST_FILING_YEAR=",linkyear)))
  
  # dedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__, undid
  #                                    FROM riccaboni.edges_undid_ud_", sector, 
  #                                    " WHERE EARLIEST_FILING_YEAR=",linkyear))
  # 
  print("Data has been loaded")
  print(paste("Number of total edges",nrow(uedges)))
  print(paste("Number of edges to find",nrow(dedges), nrow(dedges)/nrow(uedges)))
  uedges<-as.matrix(uedges)
  graph<-graph_from_edgelist(uedges, directed = FALSE)
  rm(uedges)
  save(graph, file=paste0("../output/graphs/networks/",sector, "_", inityear,"-",endyear, "_network", ".RData"))
  print("Graph has been done and saved")
  
  nodesdegree<-unique(rbind(data.frame(v1=dedges$finalID_),data.frame(v1=dedges$finalID__)))
  vdegree<-V(graph)[V(graph)$name %in% nodesdegree$v1]
  vdegree<-degree(graph, v =vdegree)
  vdegree<-as.data.frame(vdegree)
  vdegree$finalID<-rownames(vdegree)
  vdegree$lyear<-linkyear
  vdegree$yfinalID<-paste0(linkyear,vdegree$finalID)
  fwrite(vdegree, paste0("../output/graphs/degree/d",sector, "_", inityear,"-",endyear, "_list", ".csv"))
  vdegree<-as.data.table(vdegree)
  
  setkey(dedges,finalID_)
  setkey(vdegree,finalID)
  dedges<-dedges[vdegree, nomatch=0]
  # Test the other side
  setkey(dedges,finalID__)
  dedges<-dedges[vdegree, nomatch=0]

  vfrom<-V(graph)[V(graph)$name  %in% dedges$finalID_]
  vto<-V(graph)[V(graph)$name %in% dedges$finalID__]
  dline<-distances(graph, v=vfrom, to=vto, weights = NULL)

  #dline<-as.data.table(dline)
  dline<-melt(dline)
  dline<-dline[dline$value!=0 & dline$value!="Inf",]
  print("Distances have been computed")
  gc()
  dline$undid<-paste0(linkyear, dline$Var1, dline$Var2)
  # dedges<-as.data.table(dedges)
  # setkey(dline,undid)
  # setkey(dedges,undid)
  # dline<- dline[dedges, nomatch=0]
  dline<-merge(dline,dedges[,1:3],by="undid")
  
  dline<-data.table(undid=dline$undid,undid_=paste0(linkyear,dline$finalID__, dline$finalID_), socialdist=dline$value, finalID_=dline$finalID_, finalID__=dline$finalID__, lyear=linkyear)
  #dline<-dline[dline$undid %in% dedges$undid,]
  
  fwrite(dline, paste0("../output/graphs/distance_list/",sector, "_", inityear,"-",endyear, "_list", ".csv"))
  
  
  if(withplot==TRUE){
    graph.l<-layout_with_drl(graph, options=list(simmer.attraction=0))
    print("Layout has been done")
    pdf(paste0("../output/graphs/images/",inityear,"-",endyear, "_plot", ".pdf"))
    plot(graph, layout=graph.l, vertex.label=NA, vertex.frame.color=NA, vertex.size=0.7, edge.width=0.4)
    dev.off()
    print("Plot has been done")
  }
  gc()
  return("done")
}


ugraphinv_files<-function(endyear){
  inityear<-endyear-4
  linkyear<-endyear+1
  print(paste("Beginning year:", inityear))
  print(paste("Ending year:", endyear))
  print(paste("Link year:", linkyear))
  uedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                     FROM riccaboni.edges_undir_pyr 
                                     WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                     ORDER BY EARLIEST_FILING_YEAR"))
  print("Data has been loaded")
  print(paste("Number of edges",nrow(uedges)))
  uedges<-as.matrix(uedges)
  graph<-graph_from_edgelist(uedges, directed = FALSE)
  rm(uedges)
  save(graph, file=paste0("../output/graphs/networks/",inityear,"-",endyear, "_network", ".RData"))
  return("Done")
}


count_invs<-function(query, metroid=FALSE){
  df<-dbGetQuery(patstat, query)
  df<-as.data.table(df)
  if(metroid==TRUE){df$ID<-substr(df$ID,1,5)}
  df<-df[order(df$nloc, decreasing = TRUE),]
  df<-reshape(transform(df, time=ave(ID, finalID, EARLIEST_FILING_YEAR, FUN=seq_along)), idvar=c("finalID", "EARLIEST_FILING_YEAR"), direction="wide")
  df<-df[,1:4]
  colnames(df)<-c("finalID","EARLIEST_FILING_YEAR","ID","nloc")
  df<-df[, j=list(ninventors = .N, nlocsum = sum(nloc)),by = list(ID,EARLIEST_FILING_YEAR)]
  df$key<-paste0(df$EARLIEST_FILING_YEAR, df$ID)
  return(as.data.frame(df))
}

ipcrow_one<-function(ipcv, idv, ncontrol=1, edges){
  setipc<-as.data.table(edges[edges$ipc==ipcv,])
  setnei<-as.data.table(edges[edges$finalID_==idv,])
  setkey(setipc,finalID__)
  setkey(setnei,finalID__)
  Result <- merge(setipc,setnei, all=TRUE)
  Result <- Result[is.na(finalID_.y)]
  Result<-Result[sample(nrow(Result), ncontrol),c(5,1,4)]
  colnames(Result)<-c("finalID_", "finalID__", "ipc")
  Result$finalID_<-idv
  return(Result)
}

ipcrow_onerow<-function(onerow, ncontrol=1,edges=dedges){
  onerow<-as.vector(onerow)
  onerow<-data.frame(finalID_=onerow[1], finalID__=onerow[2], undid=onerow[3], ipc=onerow[4])
  setipc<-as.data.table(edges[edges$ipc==onerow$ipc,])
  setnei<-as.data.table(edges[edges$finalID_==onerow$finalID_,])
  setkey(setipc,finalID__)
  setkey(setnei,finalID__)
  Result <- merge(setipc,setnei, all=TRUE)
  Result <- Result[is.na(finalID_.y)]
  Result<-Result[sample(nrow(Result), ncontrol),c(5,1,4)]
  colnames(Result)<-c("finalID_", "finalID__", "ipc")
  Result$finalID_<-idv
  return(Result)
}

ipcrow<-function(idv,id__, ncontrol=1, edges, ipcfile, lyear){
  ipcclasses<-ipcfile[ipcfile$finalID==id__,]
  setipc<-as.data.table(ipcfile[ipcfile$class %in% ipcclasses$class,])
  setnei<-as.data.table(edges[edges$finalID_==idv,])
  setnona<-setipc[!(setipc$finalID %in% setnei$finalID__),]
  setnona<-setnona[sample(nrow(setnona), ncontrol),]
  if(nrow(setnona)>0){
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=setnona$class, ncount=seq(1,ncontrol,1))
  }
  else {
    setnona<-ipcfile[!(ipcfile$finalID %in% setnei$finalID__),]
    setnona<-setnona[sample(nrow(setnona), ncontrol),]
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=NA, ncount=seq(1,ncontrol,1))
  }
  return(Result)
}


controls_bulk<-function(linkyear, numbercontrols=1, sector="ctt"){
  print("Sector should be pboc or ctt")
  print(paste("Link year (t0):", linkyear))
  dedges<-dbGetQuery(patstat, paste0("SELECT DISTINCT finalID, finalID_
                                     FROM riccaboni.edges_dir_aus_pyr a
                                     INNER JOIN riccaboni.t01_", sector,"_class d
                                     ON a.pat=d.pat
                                     WHERE a.EARLIEST_FILING_YEAR=",linkyear))
  patipc6<-dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
                                      FROM christian.t08_class_at1us_date_fam_for a 
                                      INNER JOIN riccaboni.t01_", sector, "_class b 
                                      ON a.pat=b.pat 
                                      INNER JOIN christian.pat_6ipc c
                                      ON a.pat=c.pat 
                                      WHERE a.EARLIEST_FILING_YEAR=",linkyear," AND c.EARLIEST_FILING_YEAR=",linkyear))
  if(numbercontrols==1){
    rr<-mapply(ipcrow, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear))
    #rr<-mapply(ipcrow, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=1, ipcfile=patipc3, lyear=linkyear))
    rr<-as.data.frame(t(rr))
  }
  else{
    rr<-mapply(ipcrow, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear), SIMPLIFY = FALSE)
    rr<-merge.list(rr)
  }
  fwrite(rr, paste0("../output/graphs/counterfactual/",sector, "_", linkyear, "_list", ".csv"))
  return("done")
}


ipcrow_two<-function(idv,id__, ncontrol=1, edges, ipcfile, lyear, graphob){
  ipcclasses<-ipcfile[ipcfile$finalID==id__,]
  setipc<-as.data.table(ipcfile[ipcfile$class %in% ipcclasses$class,])
  setnei<-as.data.table(edges[edges$finalID_==idv,])
  node<-V(graphob)[V(graphob)$name %in% idv]
  neib<- neighbors(graphob, node)
  neib2<-V(graphob)[V(graphob)$name]
  setnona<-setipc[!(setipc$finalID %in% setnei$finalID__),]
  setnona<-setnona[!(setnona$finalID %in% neib2),]
  setnona<-setnona[sample(nrow(setnona), ncontrol),]
  if(nrow(setnona)>0){
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=setnona$class, ncount=seq(1,ncontrol,1))
  }
  else {
    setnona<-ipcfile[!(ipcfile$finalID %in% setnei$finalID__),]
    setnona<-setnona[!(setnona$finalID %in% neib2),]
    setnona<-setnona[sample(nrow(setnona), ncontrol),]
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=NA, ncount=seq(1,ncontrol,1))
  }
  return(Result)
}

controls_bulk_two<-function(linkyear, numbercontrols=1, sector="ctt"){
  inityear<-linkyear-5
  endyear<-linkyear-1
  print("Sector should be pboc or ctt")
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  dedges<-dbGetQuery(patstat, paste0("SELECT DISTINCT finalID, finalID_
                                     FROM riccaboni.edges_dir_aus_pyr a
                                     INNER JOIN riccaboni.t01_", sector,"_class d
                                     ON a.pat=d.pat
                                     WHERE a.EARLIEST_FILING_YEAR=",linkyear))
  patipc6<-dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
                                      FROM christian.t08_class_at1us_date_fam_for a 
                                      INNER JOIN riccaboni.t01_", sector, "_class b 
                                      ON a.pat=b.pat 
                                      INNER JOIN christian.pat_6ipc c
                                      ON a.pat=c.pat 
                                      WHERE a.EARLIEST_FILING_YEAR=",linkyear," AND c.EARLIEST_FILING_YEAR=",linkyear))
  uedges<-dbGetQuery(patstat, paste0("SELECT finalID_, finalID__
                                     FROM riccaboni.edges_undir_pyr", sector,
                                     " WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                     ORDER BY EARLIEST_FILING_YEAR"))
  uedges<-as.matrix(uedges)
  graph<-graph_from_edgelist(uedges, directed = FALSE)
  if(numbercontrols==1){
    rr<-mapply(ipcrow_two, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear, graphob=graph))
    #rr<-mapply(ipcrow, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=1, ipcfile=patipc3, lyear=linkyear))
    rr<-as.data.frame(t(rr))
  }
  else{
    rr<-mapply(ipcrow_two, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear, graphob=graph), SIMPLIFY = FALSE)
    rr<-merge.list(rr)
  }
  fwrite(rr, paste0("../output/graphs/counterfactual/",sector, "_", linkyear, "_list", ".csv"))
  return("done")
}

ipcrow_three<-function(idv,id__, ncontrol=1, edges, ipcfile, lyear, aedges){
  ipcfile<-as.data.table(ipcfile)
  ipcclasses<-ipcfile[ipcfile$finalID==id__,]
  setkey(ipcfile,class)
  setkey(ipcclasses,class)
  setipc<-ipcfile[ipcclasses, nomatch=0]
  setipc<-setipc[,1:2]
  # setipc<-as.data.table(ipcfile[ipcfile$class %in% ipcclasses$class,])
  setnei<-as.data.table(edges[edges$finalID==idv,])
  setnei2<-as.data.table(aedges[aedges$finalID==idv,])
  if(nrow(setnei2)>0){
    setnei<-rbind(setnei,setnei2)
  }
  setkey(setipc,finalID)
  setkey(setnei,finalID_)
  # setnona<-setipc[!(setipc$finalID %in% setnei$finalID_),]
  # setnona<-setnona[!(setnona$finalID %in% setnei2$finalID_),]
  setnona<-setipc[!setnei,]
  setnona<-setnona[sample(nrow(setnona), ncontrol),]
  if(nrow(setnona)>0){
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=setnona$class, ncount=seq(1,ncontrol,1))
  }
  else {
    setkey(ipcfile,finalID)
    setnona<-ipcfile[!setnei,]
    # setnona<-ipcfile[!(ipcfile$finalID %in% setnei$finalID_),]
    # setnona<-setnona[!(setnona$finalID %in% setnei2$finalID_),]
    setnona<-setnona[sample(nrow(setnona), ncontrol),]
    Result<-data.table(finalID_=idv, finalID__=setnona$finalID, year=lyear, counterof=id__,class=NA, ncount=seq(1,ncontrol,1))
  }
  return(Result)
}

controls_bulk_three<-function(linkyear, numbercontrols=1, sector="ctt"){
  inityear<-linkyear-5
  endyear<-linkyear-1
  print("Sector should be pboc or ctt")
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  dedges<-dbGetQuery(patstat, paste0("SELECT DISTINCT finalID, finalID_
                                     FROM riccaboni.edges_dir_aus_pyr a
                                     INNER JOIN riccaboni.t01_", sector,"_class d
                                     ON a.pat=d.pat
                                     WHERE a.EARLIEST_FILING_YEAR=",linkyear))
  patipc6<-dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
                                      FROM christian.t08_class_at1us_date_fam_for a 
                                      INNER JOIN riccaboni.t01_", sector, "_class b 
                                      ON a.pat=b.pat 
                                      INNER JOIN christian.pat_6ipc c
                                      ON a.pat=c.pat 
                                      WHERE a.EARLIEST_FILING_YEAR=",linkyear," AND c.EARLIEST_FILING_YEAR=",linkyear))
  adedges<-dbGetQuery(patstat, paste0("SELECT finalID, finalID_
                                     FROM riccaboni.edges_diryr_", sector,
                                     " WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear,"
                                     ORDER BY EARLIEST_FILING_YEAR"))

  if(numbercontrols==1){
    rr<-mapply(ipcrow_three, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear, aedges=adedges))
    #rr<-mapply(ipcrow, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=1, ipcfile=patipc3, lyear=linkyear))
    rr<-as.data.frame(t(rr))
  }
  else{
    rr<-mapply(ipcrow_three, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(edges=dedges, ncontrol=numbercontrols, ipcfile=patipc6, lyear=linkyear, aedges=adedges), SIMPLIFY = FALSE)
    rr<-merge.list(rr)
  }
  fwrite(rr, paste0("../output/graphs/counterfactual/",sector, "_", linkyear, "_list", ".csv"))
  return("done")
}

insdistance<-function(linkyear, sector="ctt"){
  inityear<-linkyear-5
  endyear<-linkyear-1
  print("Sector should be pboc or ctt")
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  # Edges with counterfactual: to find
  dedges<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, a.finalID_
                                                   FROM riccaboni.count_edges_", sector," a
                                                   WHERE a.EARLIEST_FILING_YEAR=",linkyear)))
  #Time window data
  insti_win<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT finalID, PSN_SECTOR 
                                                      FROM christian.inv_institu
                                                      WHERE EARLIEST_FILING_YEAR>=",inityear," AND EARLIEST_FILING_YEAR<=",endyear)))
  # Test if the first side appears in the time windows. If not, and at least one of them do not appear, the institutional proximity is zero
  insti_win_ids<-data.table(finalID=unique(insti_win$finalID))
  setkey(dedges,finalID)
  setkey(insti_win_ids,finalID)
  dedges<-dedges[insti_win_ids, nomatch=0]
  # Test the other side
  setkey(dedges,finalID_)
  dedges<-dedges[insti_win_ids, nomatch=0]
  
  if(nrow(dedges)>0){
    rr<-mapply(compare_psn, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(lyear=linkyear, instidata=insti_win))
    rr<-as.data.frame(t(rr))
    fwrite(rr, paste0("../output/graphs/insdistance/",sector, "_", linkyear, "_list", ".csv"))
  }
  
  return("done")
  
}

compare_psn<-function(idv,id__, lyear, instidata){
  instidata<-as.data.table(instidata)
  d1<-instidata[instidata$finalID==idv, 2]
  d2<-instidata[instidata$finalID==id__, 2]
  setkey(d1,PSN_SECTOR)
  setkey(d2,PSN_SECTOR)
  sharedins<-d1[d2, nomatch=0]
  if(nrow(sharedins)>0){
    result<-data.table(finalID_=idv, finalID__=id__, insprox=1, shareins=sharedins$PSN_SECTOR[1], year=lyear)
  }
  else{
    result<-data.table(finalID_=idv, finalID__=id__, insprox=0, shareins=NA, year=lyear)
  }
  return(result)
}

distance_pointsclass<-function(tfield){
  file.df<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT a.locid, a.loc, a.loc_  FROM riccaboni.count_edges_",tfield,"_gs a;")))
  
  file.df$loc<-as.character(file.df$loc)
  file.df$loc_<-as.character(file.df$loc_)
  file.df1<-do.call("rbind", strsplit(file.df$loc, ","))
  file.df1<-data.frame(apply(file.df1, 2, as.numeric))
  colnames(file.df1)<-c("lat","long")
  file.df1<-as.matrix(file.df1[,c(2,1)])
  
  file.df2<-do.call("rbind", strsplit(file.df$loc_, ","))
  file.df2<-data.frame(apply(file.df2, 2, as.numeric))
  colnames(file.df2)<-c("lat","long")
  file.df2<-as.matrix(file.df2[,c(2,1)])
  
  distances<-geosphere::distGeo(file.df1, file.df2)
  distances<-as.data.table(distances)
  distances$locid<-as.vector(file.df$locid)
  # print(distances)
  fwrite(distances, paste0("../output/graphs/geodis_locid",tfield, "_list", ".csv"))
  return("Done")
  #return(distances)
}


estimate_models<-function(tfield){
  
  file.df<-as.data.table(dbGetQuery(patstat, paste0(
    "SELECT linked, ethnic, socialdist, av_cent, absdif_cent, geodis, undid, EARLIEST_FILING_YEAR, insprox, counterof, CONCAT(EARLIEST_FILING_YEAR, finalID, IFNULL(counterof, ''), finalID_) AS undidcc, finalID, finalID_, nation, nation_
    FROM riccaboni.count_edges_",tfield,"_gsi
    WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';")))
  setkey(file.df,undid) 
  #table(file.df$linked)
  
  #####################
  # Delete when social distance is one, as to focus on first collaborations
  #####################
  # Extract when social distance is equal one
  file_sd_1.df<-file.df[file.df$socialdist==1,]
  setkey(file_sd_1.df,undid)
  # Identify the counterfactual pairs
  # ATTENTION: THE NAME OF THE COUNTERFACTUAL IS pat
  counter<-as.data.table(dbGetQuery(patstat, 
                                    "SELECT finalID, finalID_, pat, undid, CONCAT(EARLIEST_FILING_YEAR, finalID, pat) AS undidc, CONCAT(EARLIEST_FILING_YEAR, finalID, pat, finalID_) AS undidcc
                                    FROM riccaboni.edges_dir_count_ctt
                                    WHERE EARLIEST_FILING_YEAR>='1980' AND EARLIEST_FILING_YEAR<='2012';"))
  
  setkey(counter,undidc)
  counter<-counter[file_sd_1.df, nomatch=0]
  
  delete<-rbind(counter[,"undidcc"],file_sd_1.df[,"undidcc"])
  setkey(delete,undidcc)
  
  # Delete when social distance is equal one
  setkey(file.df,undidcc)
  file.df<-file.df[!delete]
  rm(delete, file_sd_1.df)
  
  #####################
  # Keep only first collaborations (create a new id without year and make the distribution of years)
  #####################
  file.df$idnodes<-substr(file.df$undid,5, nchar(file.df$undid))
  #file.df<-file.df[1:10,]
  file.df<-file.df[order(file.df$EARLIEST_FILING_YEAR),]
  file_fc.df<-reshape(transform(file.df[file.df$linked==1], time=ave(EARLIEST_FILING_YEAR, idnodes, FUN=seq_along)), idvar=c("idnodes"), direction="wide")
  #file_fc.df<-file_fc.df[order(file_fc.df$linked.2),]
  delete1<-rbind(data.frame(undidcc=unique(file_fc.df$undidcc.2)),data.frame(undidcc=unique(file_fc.df$undidcc.3)), data.frame(undidcc=unique(file_fc.df$undidcc.4)))
  delete1<-data.table(undidcc=delete1[complete.cases(delete1),"undidcc"])
  setkey(delete1,undidcc)
  
  setkey(counter,undidc)
  counter<-counter[delete1, nomatch=0]
  
  delete<-rbind(counter[,"undidcc"],delete1[,"undidcc"])
  setkey(delete,undidcc)
  
  setkey(file.df,undidcc)
  file.df<-file.df[!delete]
  rm(delete, counter, delete1, file_fc.df)
  
  # > nrow(file.df)
  # [1] 1033039
  # View(file.df[1:10,])
  
  
  #####################
  # Create dummies of social distance
  #####################
  file.df$socialdist<-as.numeric(file.df$socialdist)
  # file.df$soc_1<-ifelse(file.df$socialdist<2, 1, 0)    
  # table(file.df$soc_1)
  # file.df[file.df$soc_1==1,]
  file.df$soc_2<-ifelse(file.df$socialdist==2, 1, 0)    
  #table(file.df$soc_2)
  file.df$soc_3<-ifelse(file.df$socialdist==3, 1, 0)    
  #table(file.df$soc_3)
  file.df$soc_4m<-ifelse(file.df$socialdist>3, 1, 0)    
  #table(file.df$soc_4m)
  
  #####################
  # Recode geographic distance as a numeric and year as factor
  #####################    
  file.df$geodis<-as.numeric(file.df$geodis)
  file.df$EARLIEST_FILING_YEAR<-factor(file.df$EARLIEST_FILING_YEAR)
  
  #table(file.df$absdif_cent)
  fwrite(file.df, paste0("../output/final_tables/",tfield, "_firstcoll.csv"))
  #####################
  # Estimation
  ##################### 
  # # Basic model
  # gc()
  # # + geodis + insprox + degreecenboth
  # 
  # lreg<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, data = file.df)
  # #summary(lreg)  
  # logitmodel<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, family=binomial(link='logit'),data = file.df)
  # 
  # #summary(logitmodel)
  # 
  # # stargazer(lreg, logitmodel, title=paste0(tfield, " basic models, 1980-2012"),
  # #           align=TRUE, dep.var.labels="Co-invention",
  # #           covariate.labels=c("Ethnic proximity",
  # #                              "Social distance = 2","Social distance = 3","Average centrality","Abs. diff. centrality"
  # #                              , "Geographic distance", "Institutional proximity"),
  # #           omit.stat=c("ser","f"), no.space=TRUE)
  # 
  # lreg_t<-lm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, data = file.df)
  # #summary(lreg_t) 
  #   
  # # What should I do with the missings
  # 
  # logitmodel_t<-glm(linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, family=binomial(link='logit'),data = file.df)
  # #summary(logitmodel_t)
  # 
  # # 
  # lreg_c<-miceadds::lm.cluster(data = file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, cluster = "finalID")
  # logitmodelc_<-  miceadds::glm.cluster(data = file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox, cluster = "finalID",family=binomial(link='logit'))
  # 
  # logitmodel_tc<-miceadds::glm.cluster(data=file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, cluster = "finalID",family=binomial(link='logit'))
  # #summary(logitmodel_tc)
  # lreg_tc<-miceadds::lm.cluster(data=file.df, linked ~ ethnic + soc_2 + soc_3 + av_cent + absdif_cent + geodis + insprox + EARLIEST_FILING_YEAR, cluster = "finalID")
  # #summary(lreg_tc)
  # return(list(ols1=lreg, ols2=lreg_t, ols3=lreg_c, ols4=lreg_tc, logit1=logitmodel, logit2=logitmodel_t,logit3=logitmodelc_,logit4=logitmodel_tc))
  return("Done")
}



cognidistance<-function(linkyear, sector="ctt"){
  # linkyear<-1990
  # sector<-"ctt"
  inityear<-linkyear-5
  endyear<-linkyear-1
  print("Sector should be pboc or ctt")
  print(paste("Beginning year (t-5):", inityear))
  print(paste("Ending year (t-1):", endyear))
  print(paste("Link year (t0):", linkyear))
  # Edges with counterfactual: to find
  dedges<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, a.finalID_
                                                   FROM riccaboni.count_edges_", sector," a
                                                   WHERE a.EARLIEST_FILING_YEAR=",linkyear)))
  #Time window data
  patipc6<-as.data.table(dbGetQuery(patstat, paste0("SELECT DISTINCT a.finalID, c.class
                                                    FROM christian.t08_class_at1us_date_fam_for a 
                                                    INNER JOIN riccaboni.t01_", sector, "_class b 
                                                    ON a.pat=b.pat 
                                                    INNER JOIN christian.pat_6ipc c
                                                    ON a.pat=c.pat 
                                                    WHERE a.EARLIEST_FILING_YEAR>=",inityear," AND a.EARLIEST_FILING_YEAR<=",endyear," AND c.EARLIEST_FILING_YEAR>=",inityear," AND c.EARLIEST_FILING_YEAR<=",endyear)))
  dedges_copy<-dedges
  # Test if the first side appears in the time windows. If not, and at least one of them do not appear, the institutional proximity is zero
  patipc6_ids<-data.table(finalID=unique(patipc6$finalID))
  setkey(dedges,finalID)
  setkey(patipc6_ids,finalID)
  dedges<-dedges[patipc6_ids, nomatch=0]
  # Test the other side
  setkey(dedges,finalID_)
  dedges<-dedges[patipc6_ids, nomatch=0]
  
  if(nrow(dedges)>0){
    rr<-mapply(compare_tech, idv=dedges$finalID, id__=dedges$finalID_, MoreArgs = list(lyear=linkyear, techdata=patipc6))
    rr<-as.data.frame(t(rr))
    fwrite(rr, paste0("../output/graphs/techproxi/",sector, "_", linkyear, "_list", ".csv"))
  }
  
  return("done")
  
}

compare_tech<-function(idv,id__, lyear, techdata){
  techdata<-as.data.table(techdata)
  d1<-techdata[techdata$finalID==idv, 2]
  d2<-techdata[techdata$finalID==id__, 2]
  setkey(d1,class)
  setkey(d2,class)
  sharetech<-d1[d2, nomatch=0]
  if(nrow(sharetech)>0){
    result<-data.table(finalID_=idv, finalID__=id__, techprox=1, sharetech=sharetech$class[1], year=lyear)
  }
  else{
    result<-data.table(finalID_=idv, finalID__=id__, techprox=0, sharetech=NA, year=lyear)
  }
  return(result)
}
