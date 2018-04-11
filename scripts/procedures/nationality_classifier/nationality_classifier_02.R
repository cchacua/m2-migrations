#folders1<-list.files(path="../output/nationality", full.names=TRUE)

join_parts<-function(folder){
  name<-gsub("(.*)+/", "", folder)
  print(name)
  type<-substrRight(folder, 1)
  print(type)
  merge_all<-merge.csv(folder)
  merge_all<-setnatdf(merge_all)
  
  if(type=="a"){
    original<-read.csv(paste0(folder,".csv"))
    df<-merge(original[,c(1,2,3,ncol(original))], merge_all, by.x= 'full1_UPPER',  by.y= 'full_name', all.x=T, all.y=T)
    df1<-df[complete.cases(df),]
    df1<-df1[order(df1$finalID),]
    df2<-df[!complete.cases(df),]
    dfinal<-rbind(df1, df2)
  }
  
  if(type=="b"){
    original<-read.csv(paste0(folder,".csv"))
    df<-merge(original[,c(1,2,3,ncol(original))], merge_all, by.x= 'full_big',  by.y= 'full_name', all.x=T, all.y=T)
    df1<-df[complete.cases(df),]
    df1<-df1[order(df1$finalID),]
    df2<-df[!complete.cases(df),]
    dfinal<-rbind(df1, df2)
  }
  
  if(type=="x"){
    # Type b, with link
    original<-read.csv(paste0(folder,".csv"))
    
    link1<-read.csv(paste0(folder,"l1.csv"), header = FALSE)
    colnames(link1)<-c("num","namlink1")
    link2<-read.csv(paste0(folder,"l2.csv"), header = FALSE)
    colnames(link2)<-c("num","namlink2")
    link<-merge(link1, link2, by="num", all.x=T, all.y=T)
    merge_all<-merge(merge_all, link, by.x='full_name',  by.y='namlink1' , all.x=T, all.y=T)
    df<-merge(original[,c(1,2,3,ncol(original))], merge_all, by.x= 'full_big',  by.y= 'namlink2', all.x=T, all.y=T)
    df1<-df[complete.cases(df),]
    df1<-df1[order(df1$finalID),]
    df2<-df[!complete.cases(df),]
    dfinal<-rbind(df1, df2)
  }
  
  if(type=="w"){
    # Type a with link
    original<-read.csv(paste0(folder,".csv"))
    
    link1<-read.csv(paste0(folder,"l1.csv"), header = FALSE)
    colnames(link1)<-c("num","namlink1")
    link2<-read.csv(paste0(folder,"l2.csv"), header = FALSE)
    colnames(link2)<-c("num","namlink2")
    link<-merge(link1, link2, by="num", all.x=T, all.y=T)
    merge_all<-merge(merge_all, link, by.x='full_name',  by.y='namlink1' , all.x=T, all.y=T)
    df<-merge(original[,c(1,2,3,ncol(original))], merge_all, by.x= 'full1_UPPER',  by.y= 'namlink2', all.x=T, all.y=T)
    df1<-df[complete.cases(df),]
    df1<-df1[order(df1$finalID),]
    df2<-df[!complete.cases(df),]
    dfinal<-rbind(df1, df2)
  }
  
  if(type=="y"){
    # Part2
    original<-read.csv(paste0(folder,".csv"), header = FALSE)
    print(colnames(original))
    colnames(original)<-c("V1","name","finalID","firstname","lastname","full")
    df<-merge(original[,c(1,2,3,ncol(original))], merge_all, by.x= 'full',  by.y= 'full_name', all.x=T, all.y=T)
    df1<-df[complete.cases(df),]
    df1<-df1[order(df1$finalID),]
    df2<-df[!complete.cases(df),]
    dfinal<-rbind(df1, df2)
  }
  
  if(type=="z"){
    # nothing
    dfinal<-merge_all
  }
  
  write.csv(dfinal, paste0(folder, "_output_allnames.csv"))
  return(dfinal)
}




part1z<-join_parts("../output/nationality/final_output/part1z")
partodoz<-join_parts("../output/nationality/final_output/todo_finalz")


part2y<-join_parts("../output/nationality/final_output/part2y")
part3y<-join_parts("../output/nationality/final_output/part3y")

part4az<-join_parts("../output/nationality/final_output/part4az")
part4bz<-join_parts("../output/nationality/final_output/part4bz")
part4az<-read.csv("../output/nationality/final_output/part4az_output_allnames.csv")
part4bz<-read.csv("../output/nationality/final_output/part4bz_output_allnames.csv")

part4_c<-read.csv("../output/nationality/final_output/part4_c.csv")
part4b_c<-read.csv("../output/nationality/final_output/part4b_c.csv")
part4_c2<-part4_c[!(part4_c$finalID %in% part4b_c$finalID),]
# > length(unique(part4_c$finalID))
# [1] 134890
# > length(unique(part4_c2$finalID))
# [1] 123482
# > length(unique(part4b_c$finalID))
# [1] 11408
# > 123482+11408
# [1] 134890
write.csv(part4_c2, "../output/nationality/final_output/part4a.csv" )
write.csv(part4b_c, "../output/nationality/final_output/part4b.csv" )

colnames(part4az)
colnames(part4bz)
colnames(part4_c2)
colnames(part4b_c)

part4a_df<-merge(part4_c2[,c(1,2,3,ncol(part4_c2))], part4az, by.x= 'full',  by.y= 'full_name', all.x=T, all.y=T)
part4a_df1<-part4a_df[complete.cases(part4a_df),]
part4a_df1<-part4a_df1[order(part4a_df1$finalID),]
part4a_df2<-part4a_df[!complete.cases(part4a_df),]
dfinal<-rbind(part4a_df1, part4a_df2)
write.csv(dfinal, "../output/nationality/final_output/part4a_output_allnames_final.csv" )

part4b_df_1<-merge(part4b_c[,c(1,2,3,6)], part4bz, by.x= 'full.1',  by.y= 'full_name', all.x=F, all.y=F)
part4b_df_2<-merge(part4b_c[!(part4b_c$finalID %in% part4b_df_1$finalID),c(1,2,3,10)], part4bz, by.x= 'full.2',  by.y= 'full_name', all.x=F, all.y=F)
colnames(part4b_df_2)<-colnames(part4b_df_1)
part4b_df_2_<-merge(part4b_c[,c(1,2,3,10)], part4bz, by.x= 'full.2',  by.y= 'full_name', all.x=F, all.y=F)
colnames(part4b_df_2_)<-colnames(part4b_df_1)
part4b_df_3<-rbind(part4b_df_1, part4b_df_2)
part4b_df_3_<-rbind(part4b_df_1, part4b_df_2_)

part4b_df_4<-part4b_c[!(part4b_c$finalID %in% part4b_df_3$finalID),] 
part4b_df_4<-part4b_df_4[order(part4b_df_4$full.2),]
part4b_df_5<-part4bz[!(part4bz$full_name %in% part4b_df_3_$full.1),] 
part4b_df_5<-part4b_df_5[order(part4b_df_5$full_name),]
part4b_df_4$full.1<-part4b_df_5$full_name
colnames(part4b_df_4)
part4b_df_6<-merge(part4b_df_4[,c(1,2,3,6)], part4b_df_5, by.x= 'full.1',  by.y= 'full_name')

part4b_df_final<-rbind(part4b_df_3, part4b_df_6)
length(unique(part4b_df_final$finalID))
write.csv(part4b_df_final, "../output/nationality/final_output/part4b_output_allnames_final.csv" )




part5a<-join_parts("../output/nationality/final_output/part5a")
part5b<-join_parts("../output/nationality/final_output/part5b")

part5aold<-read.csv("../output/nationality/final_output/Organized/part5a_output_allnames-old.csv")
part5anew<-read.csv("../output/nationality/final_output/Organized/part5a_output_allnames-new.csv")
part5anew<-part5anew[order(part5anew$finalID),]
part5anew_complete<-part5anew[complete.cases(part5anew),]
part5anew_noncom<-part5anew[!complete.cases(part5anew),]
part5anew_noncom<-part5aold[part5aold$finalID %in% part5anew_noncom$finalID,]
part5afinale<-rbind(part5anew_complete, part5anew_noncom)
#write.csv(part5afinale, "../output/nationality/final_output/Organized/part5a_output_allnames_final.csv")

part6a<-join_parts("../output/nationality/final_output/part6a")
part6b<-join_parts("../output/nationality/final_output/part6b")

part7w<-join_parts("../output/nationality/final_output/part7w")
part7b<-join_parts("../output/nationality/final_output/part7b")

part9a<-join_parts("../output/nationality/final_output/part9a")
part9b<-join_parts("../output/nationality/final_output/part9b")

part10a<-join_parts("../output/nationality/final_output/part10a")
part10b<-join_parts("../output/nationality/final_output/part10b")

part11a<-join_parts("../output/nationality/final_output/part11a")
part11x<-join_parts("../output/nationality/final_output/part11x")

part12a<-join_parts("../output/nationality/final_output/part12a")
part12b<-join_parts("../output/nationality/final_output/part12b")

part13a<-join_parts("../output/nationality/final_output/part13a")
part13b<-join_parts("../output/nationality/final_output/part13b")


# files_output<-list.files(path="../output/nationality/final_output", full.names=TRUE)
# files_output


join_parts("../output/nationality/final_output/part3")



######################################################################################
#
filsa1<-read.csv("../output/nationality/final_output/Organized/a1/part5a_output_allnames_final.csv", stringsAsFactors = FALSE)
filsa1<-filsa1[,-1]
filsa2<-merge.csv("../output/nationality/final_output/Organized/a2")
filesa<-rbind(filsa1,filsa2)
rm(filsa1,filsa2)
filesb<-merge.csv("../output/nationality/final_output/Organized/b")
colnames(filesa)<-colnames(filesb)
filesab<-rbind(filesa,filesb)
#filesab$nationality<-as.character(filesab$nationality)
table(filesab$nationality)

finallist.manual<-list.files("../output/nationality/final_output/Organized/manual", full.names=TRUE)
finallist.manual

colnames(filesab)

fm1<-read.csv(finallist.manual[1], stringsAsFactors = FALSE)
fm1<-fm1[,-ncol(fm1)]
fm1<-fm1[,-6]
colnames(fm1)
filesab<-rbind(filesab,fm1)

fm2<-read.csv(finallist.manual[2], stringsAsFactors = FALSE)
colnames(fm2)
fm2<-fm2[,c(1,2,1,48,49,3:47)]
colnames(fm2)<-colnames(filesab)
filesab<-rbind(filesab,fm2)

fm3<-read.csv(finallist.manual[3], stringsAsFactors = FALSE)
colnames(fm3)
fm3<-fm3[,c(1:3,5,4,6:50)]
colnames(fm3)<-colnames(filesab)
filesab<-rbind(filesab,fm3)


fm4<-read.csv(finallist.manual[4], stringsAsFactors = FALSE)
colnames(fm4)
fm4<-fm4[,c(1:3,5,4,6:50)]
colnames(fm4)<-colnames(filesab)
filesab<-rbind(filesab,fm4)

fm5<-read.csv(finallist.manual[5], stringsAsFactors = FALSE)
colnames(fm5)
fm5<-fm5[,c(1:3,5,4,7:51)]
colnames(fm5)<-colnames(filesab)
filesab<-rbind(filesab,fm5)

fm6<-read.csv(finallist.manual[6], stringsAsFactors = FALSE)
colnames(fm6)
fm6<-fm6[,c(3,2,6,4,5,7:51)]
colnames(fm6)<-colnames(filesab)
filesab<-rbind(filesab,fm6)

fm7<-read.csv(finallist.manual[7], stringsAsFactors = FALSE)
colnames(fm7)
#fm7[as.character(fm7$full1_UPPER)!=as.character(fm7$full_name),]
fm7<-fm7[,c(1,6,3:5,7:51)]
colnames(fm7)<-colnames(filesab)
filesab<-rbind(filesab,fm7)

fm8<-read.csv(finallist.manual[8], stringsAsFactors = FALSE)
colnames(fm8)
fm8<-fm8[,c(1,2,1,48,49,3:47)]
colnames(fm8)<-colnames(filesab)
filesab<-rbind(filesab,fm8)
rm(filesa, filesb, fm1,fm2,fm3,fm4,fm5,fm6,fm7,fm8)

write.csv(filesab, "../output/nationality/final_output/nationality_all_names.csv")


table(filesab$nationality)









