# load libraries
library(pcadapt, lib.loc = "/usr/local/lib/R/site-library")
library(qvalue, lib.loc = "/usr/local/lib/R/site-library")

## remove greenhouse samples from this analyses


#load in the data paths
vcf.path="/work/seedpod/container/spaa_sample_lists/sppa_filt_m0.8_keep.log"
meta.path="/work/seedpod/container/spaa_sample_lists/meta_no_grh"
bed.path="/work/seedpod/container/spaa_sample_lists/sppa_nursery_source_keep.bed"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")

qval_sppa_ns <- qvalue(x$pvalues)$qvalues
outliers_sppa_ns <- which(qval_sppa_ns<0.1)
length(outliers_sppa_ns)


######## Just Source

#load in the data paths
bed.path="/work/seedpod/container/spaa_sample_lists/sppa_sourc_keep.bed"
meta.path="/work/seedpod/container/spaa_sample_lists/keep_source_sppa"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=10)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")

qval_sppa_s <- qvalue(x$pvalues)$qvalues
outliers_sppa_s <- which(qval_sppa_s<0.1)
length(outliers_sppa_s)


######## Just greenhouse

bed.path="/work/seedpod/container/spaa_sample_lists/sppa_grh_keep.bed"
meta.path="/work/seedpod/container/spaa_sample_lists/keep_GRH_sppa"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")


qval_sppa_g <- qvalue(x$pvalues)$qvalues
outliers_sppa_g <- which(qval_sppa_g<0.1)
length(outliers_sppa_g)


######## Just nursery

bed.path="/work/seedpod/container/spaa_sample_lists/sppa_nursery_keep.bed"
meta.path="/work/seedpod/container/spaa_sample_lists/keep_nnursery_sppa"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")


qval_sppa_n <- qvalue(x$pvalues)$qvalues
outliers_sppa_n <- which(qval_sppa_n<0.1)
length(outliers_sppa_n)


# save output


outliers_sppa<-as.data.frame(cbind(qval_sppa_g, qval_sppa_n, qval_sppa_s, qval_sppa_ns))
write.table(outliers_sppa, "/work/seedpod/container/spaa_sample_lists/outliers_qval_sppa", row.names = F)


#make a venndiagram
library(ggplot2,  lib.loc="/home/s.caplins/R/x86_64-pc-linux-gnu-library/4.4/")
library(ggVennDiagram, lib.loc="/home/s.caplins/R/x86_64-pc-linux-gnu-library/4.4/")

v<-list("greenhouse"=as.character(outliers_sppa_g), "nursery"=as.character(outliers_sppa_n), 
        "source"=as.character(outliers_sppa_s), "nursery_source"=as.character(outliers_sppa_ns))

#write output to save it
## Compute maximum length
max.length <- max(sapply(v, length))
## Add NA values to list elements
l <- lapply(v, function(x) { c(x, rep(NA, max.length-length(x)))})
## Rbind
listy<-do.call(rbind, l)


write.table(listy, "/work/seedpod/container/spaa_sample_lists/sppa_outliers", sep="\t")



ggVennDiagram(v, label_alpha = 0,
              category.names = c("Greenhouse","Nursery","Source", "Source + Nursery")
) +
  ggplot2::scale_fill_gradient(low="white",high = "cornflowerblue")


