# load libraries from container
library(pcadapt, lib.loc = "/usr/local/lib/R/site-library")
library(qvalue, lib.loc = "/usr/local/lib/R/site-library")



############. source and nursey

#load in the data paths
vcf.path="/work/seedpod/container/spal_sample_lists/spal_source_nursery_filt_keep.recode.vcf"
meta.path="/work/seedpod/container/spal_sample_lists/keep_nursery_source_spal"
bed.path="/work/seedpod/container/spal_sample_lists/spal_source_nursery_filt_keep.bed"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")

qval_spal_sn <- qvalue(x$pvalues)$qvalues
outliers_spal_sn <- which(qval_spal_sn<0.1)
length(outliers_spal_sn)


############ source and greenhouse

bed.path="/work/seedpod/container/spal_sample_lists/spal_source_grh_filt_keep.bed"
meta.path="/work/seedpod/container/spal_sample_lists/keep_source_grh_spal"

meta <- read.table(meta.path)
meta<-as.data.frame(do.call(rbind, strsplit(meta$V1, "_")))
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")

qval_spal_sg <- qvalue(x$pvalues)$qvalues
outliers_spal_sg <- which(qval_spal_sg<0.1)
length(outliers_spal_sg)


######## Just Source

#load in the data paths
bed.path="/work/seedpod/container/spal_sample_lists/spal_source_filt_keep.bed"
meta.path="/work/seedpod/container/spal_sample_lists/keep_source_spal"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=10)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")

qval_spal_s <- qvalue(x$pvalues)$qvalues
outliers_spal_s <- which(qval_spal_s<0.1)
length(outliers_spal_s)


######## Just greenhouse

bed.path="/work/seedpod/container/spal_sample_lists/spal_grh_filt_keep.bed"
meta.path="/work/seedpod/container/spal_sample_lists/keep_GRH_spal"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")


qval_spal_g <- qvalue(x$pvalues)$qvalues
outliers_spal_g <- which(qval_spal_g<0.1)
length(outliers_spal_g)


######## Just nursery

bed.path="/work/seedpod/container/spal_sample_lists/spal_nursery_filt_keep.bed"
meta.path="/work/seedpod/container/spal_sample_lists/keep_nursery_spal"

meta <- read.table(meta.path, sep="_")
meta$sites<-paste(meta$V3, meta$V4, sep="_")

genos<-read.pcadapt(bed.path, type="bed")

x <- pcadapt(input=genos,K=5)
plot(x,option="screeplot")

plot(x,option="scores",pop=meta$sites)

plot(x,option="manhattan")


qval_spal_n <- qvalue(x$pvalues)$qvalues
outliers_spal_n <- which(qval_spal_n<0.1)
length(outliers_spal_n)

## Combine to one dataframe

outliers_spal<-as.data.frame(cbind(qval_spal_g, qval_spal_n, qval_spal_s, qval_spal_sg, qval_spal_sn))
write.table(outliers_spal, "/work/seedpod/container/spal_sample_lists/outliers_qval_spal", row.names = F)

v<-list("greenhouse"=as.character(outliers_spal_g), "nursery"=as.character(outliers_spal_n), 
        "source"=as.character(outliers_spal_s), "source_nursery"=as.character(outliers_spal_sn))


#write output to save it
## Compute maximum length
max.length <- max(sapply(v, length))
## Add NA values to list elements
l <- lapply(v, function(x) { c(x, rep(NA, max.length-length(x)))})
## Rbind
listy<-do.call(rbind, l)


write.table(listy, "/work/seedpod/container/spal_sample_lists/spal_outliers", sep="\t")

# plot it as a venndiagram
library(ggVennDiagram)

ggVennDiagram(v, label_alpha = 0,
              category.names = c("Greenhouse","Nursery","Source", "Source + Nursery")
) +
  ggplot2::scale_fill_gradient(low="white",high = "cornflowerblue")


## just for paired tests (source vs grh, source vs nursery)
v2<-list(as.character(outliers_spal_sg),as.character(outliers_spal_sn))



ggVennDiagram(v2, label_alpha = 0,
              category.names = c("Source + Greenhouse", "Source + Nursery")
) +
  ggplot2::scale_fill_gradient(low="white",high = "cornflowerblue")


