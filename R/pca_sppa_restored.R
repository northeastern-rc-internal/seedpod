##PCAs

#read in the data
cov_full<-as.matrix(read.table("/work/seedpod/output/pcangsd_SC/sppa/filt_full_list.beagle.gz.cov"))
e_full<-eigen(cov_full)
plot(e_full$vectors[,1:2])
e_full$values/sum(e_full$values)

names_full<-read.table("/work/seedpod/rawdata/bam_lists/sppa/filt_full_list", sep="/")

full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
sites_full<-cbind(full_meta[,c(3,4)])

plot(e_full$vectors[,1:2], group=as.factor(sites_full$V3):as.factor(sites_full$V4), col=rainbow(15), pch=19)

######### make colors consistent   ########

# its gonna get ugly before it can be pretty

sites_full$colors<-ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "PIS", "coral1", 
                          ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "RUM", "chartreuse2", 
                                 ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "BEL", "cyan1", 
                                        ifelse(sites_full$V3 == "BEL", "cyan4", 
                                               ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "NEWP", "grey", 
                                                      ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "PINE", "cornsilk2", 
                                                             ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "DEMV", "black", 
                                                                    ifelse(sites_full$V3 == "ROW" , "coral4",
                                                                           ifelse(sites_full$V3 == "RUM" , "chartreuse4", "na")))))))))

#could have done this first

sites_full$sites<-paste(sites_full$V3, sites_full$V4, sep="_" )

# test it

plot(e_full$vectors[,1:2], col=sites_full$colors, pch=19, xlab="PC1 (4.5%)", ylab="PC2 (3.4%)")



###########
#for source sites
cov_s<-as.matrix(read.table("/work/seedpod/output/pcangsd_SC/sppa/filt_source_grh_list.beagle.gz.cov"))
e_s<-eigen(cov_s)
plot(e_s$vectors[,1:2])
e_s$values/sum(e_s$values)

names_s<-read.table("/work/seedpod/rawdata/bam_lists/sppa/filt_source_list", sep="/")

s_meta<-as.data.frame(do.call(rbind, strsplit(names_s$V7, "_")))
sites_s<-cbind(s_meta[,c(3,4)])


#make the colors
sites_s$colors<-ifelse(sites_s$V3 == "BEL", "cyan4", ifelse(sites_s$V3 == "ROW" , "coral4",
                                                            ifelse(sites_s$V3 == "RUM" , "chartreuse4", "na")))


plot(e_s$vectors[,1:2], col=sites_s$colors, pch=19)

#for greenhouse

cov_g<-as.matrix(read.table("/work/seedpod/output/pcangsd_SC/sppa/filt_grh_list.beagle.gz.cov"))
e_g<-eigen(cov_g)
plot(e_g$vectors[,1:2])
e_g$values/sum(e_g$values)

names_g<-read.table("/work/seedpod/rawdata/bam_lists/sppa/filt_grh_list", sep="/")

g_meta<-as.data.frame(do.call(rbind, strsplit(names_g$V7, "_")))
sites_g<-cbind(g_meta[,c(3,4)])

sites_g$colors<-ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "PIS", "coral1", 
                       ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "RUM", "chartreuse2", 
                              ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "BEL", "cyan1", "na")))

plot(e_g$vectors[,1:2], col=sites_g$colors, pch=19)


#for nursery

cov_n<-as.matrix(read.table("/work/seedpod/output/pcangsd_SC/sppa/filt_nur_list.beagle.gz.cov"))
e_n<-eigen(cov_n)
plot(e_n$vectors[,1:2])
e_n$values/sum(e_n$values)

names_n<-read.table("/work/seedpod/rawdata/bam_lists/sppa/filt_nur_list", sep="/")


n_meta<-as.data.frame(do.call(rbind, strsplit(names_n$V7, "_")))
sites_n<-cbind(n_meta[,c(3,4)])



sites_n$colors<-ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "NEWP", "grey", 
                       ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "PINE", "cornsilk2", 
                              ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "DEMV", "black", "red"
                              )))

plot(e_n$vectors[,1:2], col=sites_n$colors, pch=19)


### plot of greenhouse + source

cov_g_s<-as.matrix(read.table("/work/seedpod/output/pcangsd_SC/sppa/filt_source_grh_list.beagle.gz.cov"))
e_g_s<-eigen(cov_g_s)
plot(e_g_s$vectors[,1:2])
e_g_s$values/sum(e_g_s$values)

names_g_s<-read.table("/work/seedpod/rawdata/bam_lists/sppa/filt_source_grh_list", sep="/")


g_s_meta<-as.data.frame(do.call(rbind, strsplit(names_g_s$V7, "_")))
sites_g_s<-cbind(g_s_meta[,c(3,4)])




sites_g_s$colors<-ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "PIS", "coral1", 
                         ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "RUM", "chartreuse2", 
                                ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "BEL", "cyan1", 
                                       ifelse(sites_g_s$V3 == "BEL", "cyan4", 
                                              ifelse(sites_g_s$V3 == "ROW" , "coral4",
                                                     ifelse(sites_g_s$V3 == "RUM" , "chartreuse4", "na"))))))

plot(e_g_s$vectors[,1:2], col=sites_g_s$colors, pch=19)



l_names<-c("Rumney", "Rowley", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nursery (NJ)", "Nursery (MD)", "Nursery (MA)")
l_cols<-c("chartreuse4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1", "cornsilk2", "black", "grey")

par(mfrow=c(1,5))
plot(e_full$vectors[,1:2], col=sites_full$colors, pch=19, xlab="PC1 (27.1%)", ylab="PC2 (23.2%)", main="All samples")
plot(e_s$vectors[,1:2], col=sites_s$colors, pch=19, xlab="PC1 (3.5%)", ylab="PC2 (2.8%)", main="Source samples")
plot(e_g$vectors[,1:2], col=sites_g$colors, pch=19, xlab="PC1 (5.5%)", ylab="PC2 (3.8%)", main="Greenhouse samples")
plot(e_g_s$vectors[,1:2], col=sites_g_s$colors, pch=19, xlab="PC1 (5.5%)", ylab="PC2 (3.8%)", main="Greenhouse + Source samples")
plot(e_n$vectors[,1:2], col=sites_n$colors, pch=19, xlab="PC1 (10.6%)", ylab="PC2 (3.1%)", main="Nursery samples")

legend("bottomright", legend=l_names, col=l_cols, pch=19)



layout.matrix<- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)

layout(mat = layout.matrix,
       heights = c(4, 2), # Heights of the two rows
       widths = c(4, 2, 2)) # Widths of the two columns



layout.show(6)

plot(e_full$vectors[,1:2], col=sites_full$colors, pch=19, xlab="PC1 (22.8%)", ylab="PC2 (2.3%)", main="(A) All", cex=2, pt.cex=2, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_n$vectors[,1:2], col=sites_n$colors, pch=19, xlab="PC1 (8.4%)", ylab="PC2 (3.2%)", main="(D) Nursery", cex=2, pt.cex=2, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_g_s$vectors[,1:2], col=sites_g_s$colors, pch=19, xlab="PC1 (3.1%)", ylab="PC2 (2.8%)", main="(B) Greenhouse + Source", cex=2, pt.cex=2, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_s$vectors[,1:2], col=sites_s$colors, pch=19, xlab="PC1 (3.1%)", ylab="PC2 (2.8%)", main="(E) Source", cex=2, pt.cex=2, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_g$vectors[,1:2], col=sites_g$colors, pch=19, xlab="PC1 (4.3%)", ylab="PC2 (3.2%)", main="(C) Greenhouse", cex=2, pt.cex=2, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(NULL,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("top", legend=l_names, col=l_cols, pch=19, pt.cex=2.5, cex=1.75, bty='n')
