## find shared genotype likelihood sites

spal<-read.table("/work/seedpod/output/angsd_spal_SC/filt_full_list.beagle.gz", header = T)
sppa<-read.table("/work/seedpod/output/angsd_sppa_SC/filt_full_list.beagle.gz", header = T)

head(spal$marker)

sites<-intersect(spal$marker, sppa$marker)

combined<-merge(spal, sppa, by="marker")
