##PCAs

#read in the data
cov_full<-as.matrix(read.table("/projects/seedpod/output/pcangsd_SC/sppa/LD_filt.cov"))
e_full<-eigen(cov_full)
plot(e_full$vectors[,1:2])
e_full$values/sum(e_full$values)

names_full<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_full_list", sep="/")

full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
sites_full<-cbind(full_meta[,c(3,4)])

######### make colors consistent   ########

# its gonna get ugly before it can be pretty

sites_full$colors<-ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "PIS", "gold3", 
                          ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "RUM", "gold4", 
                                 ifelse(sites_full$V3 == "GRH" & sites_full$V4 == "BEL", "gold", 
                                        ifelse(sites_full$V3 == "BEL", "paleturquoise", 
                                               ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "NEWP", "thistle4", 
                                                      ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "PINE", "thistle3", 
                                                             ifelse(sites_full$V3 == "NUR" & sites_full$V4 == "DEMV", "thistle2", 
                                                                    ifelse(sites_full$V3 == "ROW" , "paleturquoise3",
                                                                           ifelse(sites_full$V3 == "RUM" , "paleturquoise4", "na")))))))))

#could have done this first

sites_full$sites<-paste(sites_full$V3, sites_full$V4, sep="_" )

## add in pch to sites_full
sites_full$pchers<-ifelse(sites_full$V3 == "RUM", 21, ifelse(sites_full$V3 == "ROW", 22, ifelse(sites_full$V3 == "BEL", 23, 
                                                                                                ifelse(sites_full$sites=="GRH_RUM", 21, ifelse(sites_full$sites == "GRH_PIS", 22, ifelse(sites_full$sites == "GRH_BEL", 23, 
                                                                                                                                                                                         ifelse(sites_full$V3 == "NUR", 24, 11)))))))

# test it

plot(e_full$vectors[,1:2], col=sites_full$colors, pch=sites_full$pchers, xlab="PC1 (22.8%)", ylab="PC2 (2.3)")



###########
#for source sites
cov_s<-as.matrix(read.table("/projects/seedpod/output/pcangsd_SC/sppa/LD_filt_source_grh.cov"))
e_s<-eigen(cov_s)
plot(e_s$vectors[,1:2])
e_s$values/sum(e_s$values)

names_s<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_source_list", sep="/")

s_meta<-as.data.frame(do.call(rbind, strsplit(names_s$V7, "_")))
sites_s<-cbind(s_meta[,c(3,4)])


#make the colors
sites_s$colors<-ifelse(sites_s$V3 == "BEL", "paleturquoise", ifelse(sites_s$V3 == "ROW" , "paleturquoise3",
                                                            ifelse(sites_s$V3 == "RUM" , "paleturquoise4", "na")))
sites_s$pchers<-ifelse(sites_s$V3 == "RUM", 21, ifelse(sites_s$V3 == "ROW", 22, ifelse(sites_s$V3 == "BEL", 23, 11)))


plot(e_s$vectors[,1:2], col=sites_s$colors, pch=19)

#for greenhouse

cov_g<-as.matrix(read.table("/projects/seedpod/output/pcangsd_SC/sppa/LD_filt_grh.cov"))
e_g<-eigen(cov_g)
plot(e_g$vectors[,1:2])
e_g$values/sum(e_g$values)

names_g<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_grh_list", sep="/")

g_meta<-as.data.frame(do.call(rbind, strsplit(names_g$V7, "_")))
sites_g<-cbind(g_meta[,c(3,4)])

sites_g$colors<-ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "PIS", "gold3", 
                       ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "RUM", "gold4", 
                              ifelse(sites_g$V3 == "GRH" & sites_g$V4 == "BEL", "gold", "na")))
sites_g$pchers<-ifelse(sites_g$V4 == "RUM", 21, ifelse(sites_g$V4 == "PIS", 22, ifelse(sites_g$V4 == "BEL", 23, 11)))


plot(e_g$vectors[,1:2], col=sites_g$colors, pch=19)


#for nursery

cov_n<-as.matrix(read.table("/projects/seedpod/output/pcangsd_SC/sppa/LD_filt_nur.cov"))
e_n<-eigen(cov_n)
plot(e_n$vectors[,1:2])
e_n$values/sum(e_n$values)

names_n<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_nur_list", sep="/")


n_meta<-as.data.frame(do.call(rbind, strsplit(names_n$V7, "_")))
sites_n<-cbind(n_meta[,c(3,4)])



sites_n$colors<-ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "NEWP", "thistle4", 
                       ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "PINE", "thistle3", 
                              ifelse(sites_n$V3 == "NUR" & sites_n$V4 == "DEMV", "thistle2", "na"
                              )))

plot(e_n$vectors[,1:2], col=sites_n$colors, pch=24)


### plot of greenhouse + source

cov_g_s<-as.matrix(read.table("/projects/seedpod/output/pcangsd_SC/sppa/LD_filt_source_grh.cov"))
e_g_s<-eigen(cov_g_s)
plot(e_g_s$vectors[,1:2])
e_g_s$values/sum(e_g_s$values)

names_g_s<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_source_grh_list", sep="/")


g_s_meta<-as.data.frame(do.call(rbind, strsplit(names_g_s$V7, "_")))
sites_g_s<-cbind(g_s_meta[,c(3,4)])

## add in pch to sites_g_s
sites_g_s$pchers<-ifelse(sites_g_s$V3 == "RUM", 21, ifelse(sites_g_s$V3 == "ROW", 22, ifelse(sites_g_s$V3 == "BEL", 23, 
                                                                                             ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "PIS", 22, 
                                                                                                    ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "RUM", 21, 
                                                                                                           ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "BEL", 23,11)))))) 


sites_g_s$colors<-ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "PIS", "gold3", 
                         ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "RUM", "gold4", 
                                ifelse(sites_g_s$V3 == "GRH" & sites_g_s$V4 == "BEL", "gold", 
                                       ifelse(sites_g_s$V3 == "BEL", "paleturquoise", 
                                              ifelse(sites_g_s$V3 == "ROW" , "paleturquoise3",
                                                     ifelse(sites_g_s$V3 == "RUM" , "paleturquoise4", "na"))))))


plot(e_g_s$vectors[,1:2], col=sites_g_s$colors, pch=19)



l_names<-c("Rumney", "Rowley", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nursery (NJ)", "Nursery (MD)", "Nursery (MA)")
l_cols<-c("paleturquoise4", "paleturquoise3", "paleturquoise", "gold4", "gold3", "gold", "thistle3", "thistle2", "thistle4")
l_pchs<-c(21, 22, 23, 21, 22, 23, 24,24,24)


par(mfrow=c(1,5))
plot(e_full$vectors[,1:2], col=sites_full$colors, pch=l_pchs, xlab="PC1 (27.1%)", ylab="PC2 (23.2%)", main="All samples")
plot(e_s$vectors[,1:2], col=sites_s$colors, pch=19, xlab="PC1 (3.5%)", ylab="PC2 (2.8%)", main="Local samples")
plot(e_g$vectors[,1:2], col=sites_g$colors, pch=19, xlab="PC1 (5.5%)", ylab="PC2 (3.8%)", main="Greenhouse samples")
plot(e_g_s$vectors[,1:2], col=sites_g_s$colors, pch=19, xlab="PC1 (5.5%)", ylab="PC2 (3.8%)", main="Greenhouse + Local samples")
plot(e_n$vectors[,1:2], col=sites_n$colors, pch=19, xlab="PC1 (10.6%)", ylab="PC2 (3.1%)", main="Nursery samples")

legend("bottomright", legend=l_names, col=l_cols, pch=19)



layout.matrix<- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, ncol = 3)

layout(mat = layout.matrix,
       heights = c(4, 2), # Heights of the two rows
       widths = c(4, 2, 2)) # Widths of the two columns

the_def<-cbind.data.frame("colors"=l_cols, "names"=l_names, "pchs"=l_pchs)
pch_full<-merge(the_def, sites_full)
pch_n<-merge(the_def, sites_n)
pch_s<-merge(the_def, sites_s)
pch_g_s<-merge(the_def, sites_g_s)
pch_g<-merge(the_def, sites_g)


layout.show(6)

plot(e_full$vectors[,1:2], bg=sites_full$colors, col="grey", pch=sites_full$pchers, xlab="PC1 (46.8%)", ylab="PC2 (1.5%)", main="(A) All", cex=2.5, pt.cex=1.5, cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_n$vectors[,1:2], bg=sites_n$colors, col="grey", pch=24, xlab="PC1 (12.0%)", ylab="PC2 (3.4%)", main="(D) Nursery", cex=2.5, pt.cex=1.5,  cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_g_s$vectors[,1]~e_g_s$vectors[,2], bg=sites_g_s$colors,col="grey", pch=sites_g_s$pchers, xlab="PC1 (3.3%)", ylab="PC2 (3.1%)", main="(B) Greenhouse + Local", cex=2.5, pt.cex=1.5,  cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_s$vectors[,1:2], bg=sites_s$colors, col="grey", pch=sites_s$pchers, xlab="PC1 (3.4%)", ylab="PC2 (3.1%)", main="(E) Local", cex=2.5, pt.cex=1.5,  cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(e_g$vectors[,1:2], bg=sites_g$colors, col="grey", pch=sites_g$pchers, xlab="PC1 (4.4%)", ylab="PC2 (3.8%)", main="(C) Greenhouse", cex=2.5, pt.cex=1.5,  cex.axis=1.5, cex.lab=1.5, cex.main=2)
plot(NULL,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("center", 
       legend=l_names,
       pch=c(21, 22, 23, 21, 22, 23, 24,24,24),
       pt.bg=c("paleturquoise4", "paleturquoise3", "paleturquoise", "gold4", "gold3", "gold", "thistle3", "thistle2", "thistle4"),
       pt.cex=2, cex=1.5, bty='n')
