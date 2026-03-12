library(hierfstat)
library(vcfR)
library(pheatmap)

#use vcfr to create a genid object for each species
spal_vcf<-read.vcfR("/projects/seedpod/output/LD_vcf/spal/LD_filt_full.recode.vcf")
spal_genid<-extract.gt(spal_vcf, as.numeric = TRUE)


meta_spal<-read.table("/projects/seedpod/rawdata/metadata/spal/decloned_spal.csv", sep=",", head=F)

# get metadata in 9 groups
site_map <- c(
  RUM_S3   = "Rumney",
  RUM_S2   = "Rumney",
  RUM_S1   = "Rumney",
  ROW_S2   = "Rowley",
  ROW_S1B  = "Rowley",
  ROW_S1   = "Rowley",
  NUR_PINE = "Nursery (NJ)",
  NUR_NEWP = "Nursery (MA)",
  NUR_DEMV = "Nursery (MD)",
  GRH_RUM  = "Rumney (GRH)",
  GRH_PIS  = "Rowley (GRH)",
  GRH_BEL  = "Belle Isle (GRH)",
  GRH_RUM_FAR = "Rumney (GRH)",
  GRH_RUM_TER = "Rumney (GRH)",
  GRH_PIS_STA = "Rowley (GRH)",
  GRH_PIS_PAT = "Rowley (GRH)",
  GRH_PIS_LAW = "Rowley (GRH)",
  GRH_RUM_HAM = "Rumney (GRH)",
  GRH_BEL_ROS = "Belle Isle (GRH)",
  GRH_BEL_KEY = "Belle Isle (GRH)",
  BEL_ROS  = "Belle Isle",
  BEL_LBE  = "Belle Isle",
  BEL_KEY  = "Belle Isle"
)

meta_spal$nines <- site_map[meta_spal$V3]

spal_pops<-data.frame(meta_spal$nines, t(spal_genid), row.names = NULL)

# run test
mat_spal<-pairwise.neifst(spal_pops[,-2], diploid=T)
#heatmap(as.matrix(mat_spal[,-1]), col = cm.colors(256), scale = "row", labRow = mat_spal$names,
#        labCol = mat_spal$names, margins = c(10,4))

mean(as.matrix(mat_spal[,-1]), na.rm=T)
sd(as.matrix(mat_spal[,-1]), na.rm=T)


# Prepare the matrix (remove first column which contains row names)
data_matrix <- as.matrix(mat_spal[,-1])
#rownames(data_matrix) <- mat_spal$names
#colnames(data_matrix) <- mat_spal$names

# Option 1: Using pheatmap (most similar to your original)
# This automatically includes a color scale legend
pheatmap(data_matrix, 
         color = cm.colors(256),
         breaks = seq(0,0.1, by=0.0005),
         scale="none",
         display_numbers = T,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         show_colnames = TRUE,
         main = "Pairwise Fst S. alterniflora")


### For SPPA


#use vcfr to create a genid object for each species
sppa_vcf<-read.vcfR("/projects/seedpod/output/LD_vcf/sppa/LD_filt_full.recode.vcf")
sppa_genid<-extract.gt(sppa_vcf, as.numeric = TRUE)


meta_sppa<-read.table("/projects/seedpod/rawdata/metadata/sppa/filt_metadata_sppa.csv", sep=",",head=F)

# get metadata in 9 groups
meta_sppa$nines <- site_map[meta_sppa$V3]

sppa_pops<-data.frame(meta_sppa$nines, t(sppa_genid), row.names = NULL)

# fix nas 
sppa_pops[is.na(sppa_pops)]<-0

# run test
mat_sppa<-pairwise.neifst(sppa_pops[,-2], diploid=T)
#heatmap(as.matrix(mat_sppa[,-1]), col = cm.colors(256), scale = "row",labRow = mat_sppa$name,
#        labCol = mat_sppa$name, margins = c(10,4))

mean(as.matrix(mat_sppa[,-1]), na.rm=T)
sd(as.matrix(mat_sppa[,-1]), na.rm=T)


data_matrix <- as.matrix(mat_sppa[,-1])
#rownames(data_matrix) <- mat_sppa$name
#colnames(data_matrix) <- mat_sppa$name

pheatmap(data_matrix, 
         color = cm.colors(256),
         scale = "none",
         breaks = seq(0,0.1, by=0.0005),
         display_numbers = T,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_rownames = TRUE,
         show_colnames = TRUE,
         main = "Pairwise Fst S. patens")


