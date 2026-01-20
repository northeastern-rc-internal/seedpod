library(hierfstat)
library(vcfR)

#use vcfr to create a genid object for each species
spal_vcf<-read.vcfR("/projects/seedpod/container/spaa_sample_lists/sppa_filt_m0.8_keep.recode.vcf")
spal_genid<-extract.gt(spal_vcf, as.numeric = TRUE)


meta_spal<-read.table("/projects/seedpod/container/spaa_sample_lists/meta_keep_sppa", head=T)



# get metadata in 9 groups
meta_spal$nine<-ifelse(grepl("ROW_",meta_spal$V4),"Rowley",
                       ifelse(grepl("RUM_", meta_spal$V4), "Rumney",
                              ifelse(grepl("BEL_", meta_spal$V4), "Belle Isle",
                                     ifelse(grepl("GRH_BEL", meta_spal$V4), "Belle Isle (GRH)",
                                            ifelse(grepl("GRH_PIS", meta_spal$V4), "Rowley (GRH)",    
                                                   ifelse(grepl("GRH_RUM", meta_spal$V4), "Rumney (GRH)",
                                                          ifelse(grepl("NUR_DEMV", meta_spal$V4), "Nursery (MD)",
                                                                 ifelse(grepl("NUR_NEWP", meta_spal$V4), "Nursery (MA)",
                                                                        ifelse(grepl("NUR_PINE", meta_spal$V4), "Nursery (NJ)",NA)))))))))

spal_pops<-data.frame(meta_spal$nine, t(spal_genid), row.names = NULL)

# run test
pairwise.neifst(spal_pops[,-2], diploid=T)
