#spal outflank

library(OutFLANK)
library(vcfR)


vcf.path="/projects/seedpod/container/spal_sample_lists/spal_no_grh_m0.8_keep.recode.vcf"
meta.path="/projects/seedpod/container/spal_sample_lists/meta_no_grh"

data <- read.vcfR(vcf.path)

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")


geno <- extract.gt(data)
dim(geno)

head(geno[,1:10])

G <- geno #we are doing this because we will be running a lot of different things with G, and if we mess up we want to be able to go back to geno

G[geno %in% c("0/0")] <- 0
G[geno  %in% c("0/1")] <- 1
G[geno  %in% c("1/0")] <- 1
G[geno %in% c("1/1")] <- 2
G[is.na(G)] <- 9
tG <- t(G)
dim(tG)
dim(G)
head(G[,1:10])
head(tG[,1:10])

fixed_G<-matrix(as.numeric(tG), ncol=120953)
dim(fixed_G)
row.names(fixed_G)<-meta$V3
fixed_G[is.na(fixed_G)]<-9


fst <- MakeDiploidFSTMat(fixed_G ,locusNames=1:dim(fixed_G)[2], popNames=meta$V3)

OF <- OutFLANK(fst,LeftTrimFraction=0.01,RightTrimFraction=0.01,
               Hmin=0.05,NumberOfSamples=2,qthreshold=0.01)
OutFLANKResultsPlotter(OF,withOutliers=T,
                       NoCorr=T,Hmin=0.1,binwidth=0.005,
                       Zoom=F,RightZoomFraction=0.05,titletext=NULL)

P1 <- pOutlierFinderChiSqNoCorr(fst,Fstbar=OF$FSTNoCorrbar,
                                dfInferred=OF$dfInferred,qthreshold=0.01,Hmin=0.05)
outliers <- P1$OutlierFlag==TRUE #which of the SNPs are outliers?
table(outliers)

plot(P1$LocusName,P1$FST,xlab="Position",ylab="FST",col=rgb(0,0,0,alpha=0.1))
points(P1$LocusName[outliers],P1$FST[outliers],col="magenta")
