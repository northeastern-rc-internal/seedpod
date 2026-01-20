combined<-read.table("/projects/seedpod/output/ngsRelate_combined/combined__newres", header=T)
all_names<-read.table("/projects/seedpod/rawdata/bam_lists/combined_species/combined_filt_list", sep="/")

comb_meta<-as.data.frame(do.call(rbind, strsplit(all_names$V7, "-")))
comb_meta2<-as.data.frame(do.call(rbind, strsplit(comb_meta$V4, "_")))
sites_comb<-cbind(comb_meta2[,c(3,4)])
sites_comb$a<-seq(0:677)
sites_comb$sites<-paste(comb_meta2$V3, comb_meta2$V4, sep="_")
sites_comb$species<-ifelse(grepl("SP", comb_meta$V4), "SP", "SA")


df_comb<-merge(combined, sites_comb, by="a")

# how many clones?
reps_comb<-df_comb[df_comb$rab == 1,] #179


df_comb_filter<-df_comb[!df_comb$rab == -1,]

boxplot(df_comb_filter$rab~df_comb_filter$species)

### filter

par(mfrow=c(2,1))
hist(df_comb_filter[df_comb_filter$species == "SP",]$rab)
hist(df_comb_filter[df_comb_filter$species == "SA",]$rab)

plot(df_comb_filter$nSites~df_comb_filter$rab)

plot(df_comb_filter[df_comb_filter$species == "SP",]$nSites~df_comb_filter[df_comb_filter$species == "SP",]$rab, ylab="number of sights", main="S. patens")
plot(df_comb_filter[df_comb_filter$species == "SA",]$nSites~df_comb_filter[df_comb_filter$species == "SA",]$rab, ylab="number of sights", main="S. alterniflora")

hist(df_comb_filter$nSites)

hist(df_comb_filter[df_comb_filter$species == "SA",]$rab)

# boxplot
boxplot(df_comb_filter[df_comb_filter$species == "SP",]$rab~df_comb_filter[df_comb_filter$species == "SP",]$V3)
boxplot(df_comb_filter[df_comb_filter$species == "SA",]$rab~df_comb_filter[df_comb_filter$species == "SA",]$V3)


# clean up the names

df_comb_filter$three<-replace( df_comb_filter$V3, df_comb_filter$V3=="BEL","Source")
df_comb_filter$three<-replace( df_comb_filter$three, df_comb_filter$V3=="ROW","Source")
df_comb_filter$three<-replace( df_comb_filter$three, df_comb_filter$V3=="RUM","Source")
df_comb_filter$three<-replace( df_comb_filter$three, df_comb_filter$V3=="sorted.bam","greenhouse")
df_comb_filter$three<-replace( df_comb_filter$three, df_comb_filter$V3=="NUR","Nursery")
df_comb_filter$three<-replace( df_comb_filter$three, df_comb_filter$V3=="GRH","greenhouse")

# boxplot
boxplot(df_comb_filter[df_comb_filter$species == "SP",]$rab~df_comb_filter[df_comb_filter$species == "SP",]$three, ylab="pairwise relatedness (rab)", main="S. patens")
boxplot(df_comb_filter[df_comb_filter$species == "SA",]$rab~df_comb_filter[df_comb_filter$species == "SA",]$three, ylab="pairwise relatedness (rab)", main="S. alterniflora")

