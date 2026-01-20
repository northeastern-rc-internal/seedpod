## relatedness subsetting

#read in the data for spal
spal<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_0_newres", header=T)
spal_1<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_1_newres", header=T)
spal_2<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_2_newres", header=T)
spal_3<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_3_newres", header=T)
spal_4<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_4_newres", header=T)
spal_5<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/spal_5_newres", header=T)

names_full<-read.table("/projects/seedpod/rawdata/bam_lists/spal/filt_full_list", sep="/")

full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
sites_full<-cbind(full_meta[,c(2,3,4)])
sites_full$a<-seq(0:327)
sites_full$b<-seq(0:327)
sites_full$name<-paste(sites_full$V2, sites_full$V3, sites_full$V4, sep="_")
sites_full$sites<-paste(sites_full$V3, sites_full$V4, sep="_")

par(mfrow=c(1,1))
boxplot(spal_1$rab)

hist(spal$nSites)

hist(spal_1$rab, breaks=100, ylim=c(0,2000))#where rab is the pairwise relatedness
abline(v=0.98)
max(spal_1$rab)


df<-merge(spal, sites_full, by="a")
df_spal_names<-merge(df, sites_full, by=c("b"))
df_1<-merge(spal_1, sites_full, by="a")
df_2<-merge(spal_2, sites_full, by="a")
df_3<-merge(spal_3, sites_full, by="a")
df_4<-merge(spal_4, sites_full, by="a")
df_5<-merge(spal_5, sites_full, by="a")

hist(df$rab, breaks=200, ylim=c(0,5000)) 

reps<-df[df$rab == 1,] #0!
reps_1<-df_1[df_1$rab == 1,] #1!
reps_2<-df_2[df_2$rab == 1,] #2!
reps_3<-df_3[df_3$rab == 1,] #1!
reps_4<-df_4[df_4$rab == 1,] #3!
reps_5<-df_5[df_5$rab == 1,] #9!

lapply(c(135, 166, 302, 372), function(x) sites_full[sites_full$a == x,])

#maybe they don't equal 1 but are close to it

repsl<-df[df$rab >= 0.999,] #193!
repsl_1<-df_1[df_1$rab >= 0.999,] #54!
repsl_2<-df_2[df_2$rab  >= 0.999,] #63!
repsl_3<-df_3[df_3$rab  >= 0.999,] #80!
repsl_4<-df_4[df_4$rab  >= 0.999,] #97!
repsl_5<-df_5[df_5$rab  >= 0.999,] #98!

#find pairs for repsl

repsl$sites_b<-sites_full[c(repsl$b),]$sites
repsl$name_b<-sites_full[c(repsl$b),]$V2
pairs<-as.data.frame(cbind(paste(repsl$V2, repsl$sites, sep="_"), paste(repsl$name_b, repsl$sites_b, sep="_")))

# clones to remove
# remove H07_BEL_KEY and then sample others randomly
new<-pairs[grep(x=pairs$V1, "H07_BEL_KEY" , invert=T),][grep(x=pairs$V2, "H07_BEL_KEY", invert=T),]

# D07_RUM_S1 shows up in three pairs remove it too prior to random sampling
new2<-new[grep(x=new$V1, "D07_RUM_S1" , invert=T),][grep(x=new$V2, "D07_RUM_S1", invert=T),]

sample(new2$V1, 13)

# list of samples being removed
remove<-c("D07_RUM_S1", "H07_BEL_KEY", "D03_RUM_S3","A05_ROW_S2", "D11_RUM_S2",  "B08_BEL_KEY", "B09_BEL_LBE",
          "C01_ROW_S1", "F06_BEL_ROS", "B06_ROW_S1" )


#filter out values with a -1
df_filt<-df[!df$rab == -1,]

df_1_filt<-df_1[!df_1$rab == -1,]
df_2_filt<-df_2[!df_2$rab == -1,]
df_3_filt<-df_3[!df_3$rab == -1,]
df_4_filt<-df_4[!df_4$rab == -1,]
df_5_filt<-df_5[!df_5$rab == -1,]

mean(df_filt$rab)
range(df_filt$rab)
sd(df_filt$rab)

par(mfrow=c(2,3))
boxplot(df_filt$rab~df_filt$sites, main="spal_full_515475", las=2, xlab="")
boxplot(df_1_filt$rab~df_1_filt$sites, main="spal_1_5000", las=2, xlab="")
boxplot(df_2_filt$rab~df_2_filt$sites, main="spal_2_5000", las=2, xlab="")
boxplot(df_3_filt$rab~df_3_filt$sites, main="spal_3_5000", las=2, xlab="")
boxplot(df_4_filt$rab~df_4_filt$sites, main="spal_4_5000", las=2, xlab="")
boxplot(df_5_filt$rab~df_5_filt$sites, main="spal_5_5000", las=2, xlab="")

## for sppa

sppa<-read.table("/projects/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed/sppa_0_newres", header=T)
names_sppa<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_full_list", sep="/")
full_meta_sppa<-as.data.frame(do.call(rbind, strsplit(names_sppa$V7, "_")))
sites_sppa<-cbind(full_meta_sppa[,c(2,3,4)])
sites_sppa$a<-seq(0:349)
sites_sppa$b<-seq(0:349)
sites_sppa$sites<-paste(sites_sppa$V3, sites_sppa$V4, sep="_")

par(mfrow=c(1,1))
boxplot(sppa$rab)

hist(sppa$nSites)

hist(sppa$rab, breaks=100, ylim=c(0,5000)) #where rab is the pairwise relatedness
max(sppa$rab)

df_sppa<-merge(sppa, sites_sppa, by=c("a"))
df_sppa_names<-merge(df_sppa, sites_sppa, by=c("b"))

hist(df_sppa$rab, breaks=200, ylim=c(0,5000)) 

reps_sppa<-df_sppa[df_sppa$rab == 1,] #0!
repsl_sppa<-df_sppa[df_sppa$rab >= 0.94,] #2!

repsl_sppa$sites_b<-sites_sppa[c(repsl_sppa$b),]$sites
repsl_sppa$name_b<-sites_sppa[c(repsl_sppa$b),]$V2
as.data.frame(cbind(paste(repsl_sppa$V2, repsl_sppa$sites, sep="_"), paste(repsl_sppa$name_b, repsl_sppa$sites_b, sep="_")))

#filter out values with a -1
df_filt_sppa<-df_sppa[!df_sppa$rab == -1,]
mean(df_filt_sppa$rab)
range(df_filt_sppa$rab)
sd(df_filt_sppa$rab)

boxplot(df_filt_sppa$rab~df_filt_sppa$sites, main="sppa_full_60726", las=2, xlab="", ylim=c(0,1))

##fix up the names

names<-cbind(c(unique(df_filt_sppa$sites)), c("Rumney", "Rumney", "Rowley","Rowley","Belle Isle", "Rumney","Belle Isle", "Rowley", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nur_DEMV", "Nur_NEWP", "Nur_PINE"),
             c("chartreuse4", "chartreuse4", "coral4", "coral4", "cyan4", "chartreuse4", "cyan4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1","darkslategray4", "grey", "cornsilk2"))

colnames(names)<-c("sites", "names", "colors")


df_filt_sppa_names<-merge(names, df_filt_sppa)

boxplot(df_filt_sppa_names$rab~df_filt_sppa_names$names, col=df_filt_sppa_names$colors, las=2, xlab="", ylim=c(0,1))
library(rlang)
library(ggplot2)
library(gridExtra)

B<-ggplot(df_filt_sppa_names, aes(names, rab, fill=names, group=names))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  ylim(0,1)+
  scale_x_discrete(name="Site", labels=c("Belle Isle", "Bell Isle (GRH)", "Nursery (MD)", "Nursery (MA)", "Nursery (NJ)", "Rowley", "Rowley (GRH)", "Rumney", "Rumney (GRH)"))+
  scale_fill_manual(values=c("paleturquoise3","gold3", "thistle3", "thistle2", "thistle", "paleturquoise2","gold2", "paleturquoise","gold"))+
  ylab("Pairwise Relatedness")+
  ggtitle("(B) S. patens")


df_filt_names<-merge(names, df_filt)

boxplot(df_filt_names$rab~df_filt_names$names, las=2, xlab="", ylim=c(0,1))

A<-ggplot(df_filt_names, aes(names, rab, fill=names, group=names))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  ylim(0,1)+
  scale_x_discrete(name="Site", labels=c("Belle Isle", "Bell Isle (GRH)", "Nursery (MD)", "Nursery (MA)", "Nursery (NJ)", "Rowley", "Rowley (GRH)", "Rumney", "Rumney (GRH)"))+
  scale_fill_manual(values=c("paleturquoise3","gold3", "thistle3", "thistle2", "thistle", "paleturquoise2","gold2", "paleturquoise","gold"))+
  ylab("Pairwise Relatedness")+
  ggtitle("(A) S. alterniflora")

grid.arrange(A, B, nrow=1)


# group by threes
# for spal
df_filt_names$three<-replace( df_filt_names$V3, df_filt_names$V3=="BEL","Source")
df_filt_names$three<-replace( df_filt_names$three, df_filt_names$three=="ROW","Source")
df_filt_names$three<-replace( df_filt_names$three, df_filt_names$three=="RUM","Source")
df_filt_names$three<-replace( df_filt_names$three, df_filt_names$three=="NUR","Nursery")
df_filt_names$three<-replace( df_filt_names$three, df_filt_names$three=="GRH","Greenhouse")

# for sppa
df_filt_sppa_names$three<-replace( df_filt_sppa_names$V3, df_filt_sppa_names$V3=="BEL","Source")
df_filt_sppa_names$three<-replace( df_filt_sppa_names$three, df_filt_sppa_names$three=="ROW","Source")
df_filt_sppa_names$three<-replace( df_filt_sppa_names$three, df_filt_sppa_names$three=="RUM","Source")
df_filt_sppa_names$three<-replace( df_filt_sppa_names$three, df_filt_sppa_names$three=="NUR","Nursery")
df_filt_sppa_names$three<-replace( df_filt_sppa_names$three, df_filt_sppa_names$three=="GRH","Greenhouse")

library(rlang)
library(ggplot2)
library(gridExtra)

## order site levels
df_filt_sppa_names$three <- factor(df_filt_sppa_names$three, levels=c("Source", "Greenhouse", "Nursery"))
df_filt_names$three <- factor(df_filt_names$three, levels=c("Source", "Greenhouse", "Nursery"))

library(wesanderson)
library("viridis")  

C<-ggplot(df_filt_names, aes(three, rab, fill=three, group=three))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  xlab("Site")+
  ylim(0,1)+
  scale_fill_manual(values=c("paleturquoise3", "gold3", "thistle3"))+
  ylab("Pairwise Relatedness")+
  ggtitle("(A) S. alterniflora")

D<-ggplot(df_filt_sppa_names, aes(three, rab, fill=three, group=three))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  xlab("Site")+
  ylim(0,1)+
  scale_fill_manual(values=c("paleturquoise3", "gold3", "thistle3"))+
  ylab("Pairwise Relatedness")+
  ggtitle("(B) S. patens")

grid.arrange(C, D, nrow=1)

#run the models

## significance tests

rel_3_sa<-aov(df_filt_names$rab~df_filt_names$three)
summary(rel_3_sa)
TukeyHSD(rel_3_sa, conf.level = .95, las=2)

rel_3_sp<-aov(df_filt_sppa_names$rab~df_filt_sppa_names$three)
summary(rel_3_sp)
TukeyHSD(rel_3_sp, conf.level = .95, las=2)

# for 9 groups

rel_9_sa<-aov(df_filt_names$rab~df_filt_names$names)
summary(rel_9_sa)
TukeyHSD(rel_9_sa, conf.level = .95, las=2)


rel_9_sp<-aov(df_filt_sppa_names$rab~df_filt_sppa_names$names)
summary(rel_9_sp)
TukeyHSD(rel_9_sp, conf.level = .95, las=2)

### remove clones from spal

#first make sample name vector
df_filt_names$samples<-paste(df_filt_names$V2, df_filt_names$V3, df_filt_names$V4, sep="_")
head(remove)

no_clones<-df_filt_names[!df_filt_names$samples == remove, ]


# make data nice for others
library(dplyr)

# match a/b for sample names


df_updated <- rows_update(x = sites_full, y = spal, by = "a")
print(df_updated)


write.table()



