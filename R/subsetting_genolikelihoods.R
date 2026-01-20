#subsetting for spal genolikelihood files

#input data

genolike<-read.table("/work/seedpod/output/ngsRelate_subsetting/all_samples/spal_1_result.mafs", header=T)

spal_1<-genolike[sample(nrow(genolike), 5000, replace = F),]
spal_2<-genolike[sample(nrow(genolike), 5000, replace = F),]
spal_3<-genolike[sample(nrow(genolike), 5000, replace = F),]
spal_4<-genolike[sample(nrow(genolike), 5000, replace = F),]
spal_5<-genolike[sample(nrow(genolike), 5000, replace = F),]

write.table(spal_5[,1:2], "../output/ngsRelate_subsetting/spal_5_sites", row.names = F)

write.table(genolike[,1:2],"../output/ngsRelate_subsetting/spal_0_sites", row.names = F)

#test reading in the binary file
glf<-read.table("/work/seedpod/output/ngsRelate_subsetting/spal_1_result.glf.gz")


#subsetting for sppa genolikelihood files

#input data

genolike_patens<-read.table("/work/seedpod/output/angsd_sppa_SC/full_list.mafs.gz", header=T)


sppa_1<-genolike_patens[sample(nrow(genolike_patens), 1000, replace = F),]
sppa_2<-genolike_patens[sample(nrow(genolike_patens), 1000, replace = F),]
sppa_3<-genolike_patens[sample(nrow(genolike_patens), 1000, replace = F),]
sppa_4<-genolike_patens[sample(nrow(genolike_patens), 1000, replace = F),]
sppa_5<-genolike_patens[sample(nrow(genolike_patens), 1000, replace = F),]

write.table(sppa_5[,1:2], "../output/ngsRelate_subsetting/sppa_5_sites", row.names = F)
