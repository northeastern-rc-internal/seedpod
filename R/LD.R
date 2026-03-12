spal_lD<-read.delim("/projects/seedpod/output/spal_ngsLD", header=T)

sppa_lD<-read.delim("/projects/seedpod/output/sppa_ngsLD", header=T)

con_sppa<-sppa_lD[which(sppa_lD[,"r2"] >= 0.5),]

con_spal<-spal_lD[which(spal_lD[,"r2"] >= 0.5),]

length(unique(con_sppa$site1))
#1192
length(unique(con_spal$site1))
#6529