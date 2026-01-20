## relatedness subsetting

#read in the data
spal<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_0_newres", header=T)
spal_1<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_1_newres", header=T)
spal_2<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_2_newres", header=T)
spal_3<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_3_newres", header=T)
spal_4<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_4_newres", header=T)
spal_5<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_5_newres", header=T)

names_full<-read.table("/projects/seedpod/rawdata/bam_lists/spal/filt_full_list", sep="/")

full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
sites_full<-cbind(full_meta[,c(3,4)])
sites_full$a<-seq(0:327)
sites_full$sites<-paste(sites_full$V3, sites_full$V4, sep="_")

par(mfrow=c(1,1))
boxplot(spal_1$rab)

hist(spal_1$nSites)

hist(spal_1$rab, breaks=100) #where rab is the pairwise relatedness
max(spal_1$rab)


df<-merge(spal, sites_full, by="a")
df_1<-merge(spal_1, sites_full, by="a")
df_2<-merge(spal_2, sites_full, by="a")
df_3<-merge(spal_3, sites_full, by="a")
df_4<-merge(spal_4, sites_full, by="a")
df_5<-merge(spal_5, sites_full, by="a")


reps<-df[df$rab == 1,] #3!
reps_1<-df_1[df_1$rab == 1,] #25!
reps_2<-df_2[df_2$rab == 1,] #104!
reps_3<-df_3[df_3$rab == 1,] #36!
reps_4<-df_4[df_4$rab == 1,] #26!
reps_5<-df_5[df_5$rab == 1,] #145!

lapply(c(135, 166, 302, 372), function(x) sites_full[sites_full$a == x,])


#filter out values with a -1
df_filt<-df[!df$rab == -1,]

df_1_filt<-df_1[!df_1$rab == -1,]
df_2_filt<-df_2[!df_2$rab == -1,]
df_3_filt<-df_3[!df_3$rab == -1,]
df_4_filt<-df_4[!df_4$rab == -1,]
df_5_filt<-df_5[!df_5$rab == -1,]


par(mfrow=c(3,3))
boxplot(df_filt$rab~df_filt$sites, main="spal_full_515475", las=2, xlab="")
boxplot(df_1_filt$rab~df_1_filt$sites, main="spal_1_5000", las=2, xlab="")
boxplot(df_2_filt$rab~df_2_filt$sites, main="spal_2_5000", las=2, xlab="")
boxplot(df_3_filt$rab~df_3_filt$sites, main="spal_3_5000", las=2, xlab="")
boxplot(df_4_filt$rab~df_4_filt$sites, main="spal_4_5000", las=2, xlab="")
boxplot(df_5_filt$rab~df_5_filt$sites, main="spal_5_5000", las=2, xlab="")

