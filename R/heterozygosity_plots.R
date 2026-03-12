# heterozygosity

#data that we want is in ipyrad output and starts with this
## Final Sample stats summary

## Final Sample stats summary
#[s.caplins@login-01 output]$ grep -in "## Final" spal_ipyrad/spal_outfiles/spal_stats.txt
#824:## Final Sample stats summary
#  [s.caplins@login-01 output]$ grep -in "## Final" sppa_ipyrad/sppa_outfiles/sppa_stats.txt
#867:## Final Sample stats summary

#tail -n 392 sppa_ipyrad/sppa_outfiles/sppa_stats.txt | head -n 387 > het_ipyrad/sppa_het_table.txt

spal_het<-read.table("/projects/seedpod/output/het_ipyrad/keep_spal_het_table.txt", header=T)
sppa_het<-read.table("/projects/seedpod/output/het_ipyrad/keep_sppa_het_table.txt", header=T)

spal_meta<-as.data.frame(do.call(rbind, strsplit(spal_het$name, "_")))
sites_spal<-cbind(spal_meta[,c(2,3,4)])
spal_het$sites<-paste(sites_spal$V3, sites_spal$V4, sep="_")
spal_het$site_simple<-spal_meta$V3

sppa_meta<-as.data.frame(do.call(rbind, strsplit(sppa_het$name, "_")))
sites_sppa<-cbind(sppa_meta[,c(2,3,4)])
sppa_het$sites<-paste(sites_sppa$V3, sites_sppa$V4, sep="_")
sppa_het$site_simple<-sppa_meta$V3

#hist(spal_het$O.HOM./(spal_het$N_SITES+spal_het$E.HOM.))
hist(sppa_het$hetero_est)

mean(spal_het$hetero_est)
mean(spal_het$error_est)



# make plots
library(rlang)
library(ggplot2)

sppa_het$three<-replace( sppa_het$site_simple, sppa_het$site_simple=="BEL","Local")
sppa_het$three<-replace( sppa_het$three, sppa_het$three=="ROW","Local")
sppa_het$three<-replace( sppa_het$three, sppa_het$three=="RUM","Local")
sppa_het$three<-replace( sppa_het$three, sppa_het$three=="NUR","Nursery")
sppa_het$three<-replace( sppa_het$three, sppa_het$three=="GRH","Greenhouse")


ggplot(sppa_het, aes(three, hetero_est, fill=three, group=three))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  xlab("Site")+
  ylab("Heterozygosity Estimate")+
  ggtitle("S. patens")


# for spal

spal_het$three<-replace( spal_het$site_simple, spal_het$site_simple=="BEL","Local")
spal_het$three<-replace( spal_het$three, spal_het$three=="ROW","Local")
spal_het$three<-replace( spal_het$three, spal_het$three=="RUM","Local")
spal_het$three<-replace( spal_het$three, spal_het$three=="NUR","Nursery")
spal_het$three<-replace( spal_het$three, spal_het$three=="GRH","Greenhouse")


ggplot(spal_het, aes(three, hetero_est, fill=three, group=three))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  xlab("Site")+
  ylab("Heterozygosity Estimate")+
  ggtitle("S. alterniflora")

#All 9 sites

names<-cbind(c(unique(spal_het$sites)), c("Rowley", "Rumney", "Rowley","Belle Isle", "Rumney","Belle Isle", "Rowley","Rumney", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nur_PINE", "Nur_DEMV", "Nur_NEWP"),
             c("chartreuse4", "chartreuse4", "coral4", "coral4", "cyan4", "chartreuse4", "cyan4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1","darkslategray4", "grey", "cornsilk2"))

colnames(names)<-c("sites", "names", "colors")


#fix up name order

sppa_het$three <- factor(sppa_het$three, levels=c("Local", "Greenhouse", "Nursery"))
spal_het$three <- factor(spal_het$three, levels=c("Local", "Greenhouse", "Nursery"))

spal_het_names<-merge(names, spal_het)

A<-ggplot(spal_het_names, aes(names, hetero_est, fill=names, group=names))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  scale_x_discrete(name="Site", labels=c("Belle Isle", "Bell Isle (GRH)", "Nursery (MD)", "Nursery (MA)", "Nursery (NJ)", "Rowley", "Rowley (GRH)", "Rumney", "Rumney (GRH)"))+
  scale_fill_manual(values=c("paleturquoise","gold", "thistle2", "thistle4", "thistle3", "paleturquoise3","gold3", "paleturquoise4","gold4"))+
  ylab("Heterozygosity Estimate")+
  ggtitle("(A) S. alterniflora")

names2<-cbind(c(unique(sppa_het$sites)), c("Rumney", "Rumney", "Rowley","Rowley","Belle Isle", "Rumney", "Belle Isle", "Rowley", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nur_DEMV", "Nur_NEWP", "Nur_PINE"),
             c("chartreuse4", "chartreuse4", "coral4", "coral4", "cyan4", "chartreuse4", "cyan4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1","darkslategray4", "grey", "cornsilk2"))

colnames(names2)<-c("sites", "names", "colors")

sppa_het_names<-merge(names2, sppa_het)

B<-ggplot(sppa_het_names, aes(names, hetero_est, fill=names, group=names))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  scale_x_discrete(name="Site", labels=c("Belle Isle", "Bell Isle (GRH)", "Nursery (MD)", "Nursery (MA)", "Nursery (NJ)", "Rowley", "Rowley (GRH)", "Rumney", "Rumney (GRH)"))+
  scale_fill_manual(values=c("paleturquoise","gold", "thistle2", "thistle4", "thistle3", "paleturquoise3","gold3", "paleturquoise4","gold4"))+
  ylab("Heterozygosity Estimate")+
  ggtitle("(B) S. patens")

library(gridExtra)


grid.arrange(A, B, nrow=1)
# do stats

mean(sppa_het$hetero_est)
mean(sppa_het$error_est)

#### BY THREES

# Order the three groups
spal_het_names$three <- factor(spal_het_names$three,
                                levels = c("Nursery", "Local", "Greenhouse"))

# Order the three groups
sppa_het_names$three <- factor(sppa_het_names$three,
                                     levels = c("Nursery", "Local", "Greenhouse"))


## For the stats

## do the stats Tukey HSD post-hoc test
aov_fit <- aov(hetero_est ~ three, data = spal_het_names)
tukey   <- TukeyHSD(aov_fit)$three


# Define comparisons explicitly in factor level order (level1, level2)
comps <- list(
  c("Local", "Nursery"),
  c("Local", "Greenhouse"),
  c("Nursery", "Greenhouse")
)


# Look up p-values by trying both name orderings
get_p <- function(a, b, tukey) {
  nm <- rownames(tukey)
  key <- if (paste0(b, "-", a) %in% nm) paste0(b, "-", a) else paste0(a, "-", b)
  tukey[key, "p adj"]
}

p_vals <- sapply(comps, function(x) get_p(x[1], x[2], tukey))
p_labels <- sapply(p_vals, function(p) {
  if (p == 0)    "p < 2.2e-16"
  else if (p < 0.001) paste0("p = ", formatC(p, format = "e", digits = 2))
  else paste0("p = ", round(p, 3))
})

#Tukey HSD post-hoc test
aov_fit_sppa <- aov(hetero_est~ three, data = sppa_het_names)
tukey_sppa   <- TukeyHSD(aov_fit_sppa)$three


# Look up p-values by trying both name orderings
get_p_sppa <- function(a, b, tukey_sppa) {
  nm_sppa <- rownames(tukey_sppa)
  key_sppa <- if (paste0(b, "-", a) %in% nm_sppa) paste0(b, "-", a) else paste0(a, "-", b)
  tukey_sppa[key_sppa, "p adj"]
}

p_vals_sppa <- sapply(comps, function(x) get_p(x[1], x[2], tukey_sppa))
p_labels_sppa <- sapply(p_vals_sppa, function(p) {
  if (p == 0)    "p < 2.2e-16"
  else if (p < 0.001) paste0("p = ", formatC(p, format = "e", digits = 2))
  else paste0("p = ", round(p, 3))
})

library(ggsignif)

C<-ggplot(spal_het_names, aes(x = three, y = hetero_est, fill = three)) +
  geom_boxplot(show.legend = FALSE, outlier.shape = 21,
               outlier.fill = "white", outlier.color = "gray40") +
  scale_fill_manual(values = c("Local"      = "paleturquoise3",
                               "Nursery"    = "thistle3",
                               "Greenhouse" = "gold3")) +
  geom_signif(comparisons  = comps,
              annotations  = p_labels,
              step_increase = 0.12,
              tip_length   = 0.01,
              textsize     = 3) +
  ylim(0, 0.012) +
  labs(x = "Site", y = "Heterozygosity estimate", title = "(A) S. alterniflora") +
  theme_minimal() +
  theme(plot.title = element_text(face = "italic"))


D<-ggplot(sppa_het_names, aes(x = three, y = hetero_est, fill = three)) +
  geom_boxplot(show.legend = FALSE, outlier.shape = 21,
               outlier.fill = "white", outlier.color = "gray40") +
  scale_fill_manual(values = c("Local"      = "paleturquoise3",
                               "Nursery"    = "thistle3",
                               "Greenhouse" = "gold3")) +
  geom_signif(comparisons  = comps,
              annotations  = p_labels_sppa,
              step_increase = 0.12,
              tip_length   = 0.01,
              textsize     = 3) +
  ylim(0, 0.012) +
  labs(x = "Site", y = "Heterozygosity estimate", title = "(B) S. patens") +
  theme_minimal() +
  theme(plot.title = element_text(face = "italic"))

grid.arrange(C, D, nrow=1)



## significance tests

sig_3_sa<-aov(spal_het_names$hetero_est~spal_het_names$three)
summary(sig_3_sa)
TukeyHSD(sig_3_sa, conf.level = .95, las=2)

sig_3_sp<-aov(sppa_het_names$hetero_est~sppa_het_names$three)
summary(sig_3_sp)
TukeyHSD(sig_3_sp, conf.level = .95, las=2)

# for 9 groups

sig_9_sa<-aov(spal_het_names$hetero_est~spal_het_names$names)
summary(sig_9_sa)
TukeyHSD(sig_9_sa, conf.level = .95, las=2)

sig_9_sp<-aov(sppa_het_names$hetero_est~sppa_het_names$names)
summary(sig_9_sp)
TukeyHSD(sig_9_sp, conf.level = .95, las=2)

#make tables
library(rlang)
library(jtools)


## remove clones from spal

remove<-c("D07_RUM_S1", "H07_BEL_KEY", "D03_RUM_S3","A05_ROW_S2", "D11_RUM_S2",  "B08_BEL_KEY", "B09_BEL_LBE",
          "C01_ROW_S1", "F06_BEL_ROS", "B06_ROW_S1" )

# remove the Plate number and SA from the sample name

#function to fix names in spal

remove_pattern <- function(input_string) {
  # Remove everything up to and including the first underscore
  result <- sub("^[^_]*_", "", input_string)
  
  # Remove the suffix "_SA"
  result <- sub("_SA$", "", result)
  
  return(result)
}

# Example usage

# Apply the function and store results in a new column
spal_het_names$processed_name <- sapply(spal_het_names$name, remove_pattern)

# Print before and after for verification
for (i in 1:nrow(spal_het_names)) {
  cat("Original:", spal_het_names$name[i], "→ Result:", spal_het_names$processed_name[i], "\n")
}

# do for sppa also just to make metadata match
# Apply the function and store results in a new columnmet
sppa_het_names$processed_name <- sapply(sppa_het_names$name, remove_pattern)

# Print before and after for verification
for (i in 1:nrow(sppa_het_names)) {
  cat("Original:", sppa_het_names$name[i], "→ Result:", sppa_het_names$processed_name[i], "\n")
}


no_clones<-spal_het_names[!spal_het_names$processed_name %in% remove,]

#plot of threes

Cnoclones<-ggplot(no_clones, aes(three, hetero_est, fill=three, group=three))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  xlab("Site")+
  ylim(0,0.01)+
  scale_fill_manual(values=c("paleturquoise3", "gold3", "thistle3"))+
  ylab("Heterozygosity Estimate")+
  ggtitle("(A) S. alterniflora")

grid.arrange(Cnoclones, D, nrow=1)

#plot of 9s

Anoclones<-ggplot(no_clones, aes(names, hetero_est, fill=names, group=names))+
  geom_boxplot(show.legend=F)+
  theme_minimal()+
  scale_x_discrete(name="Site", labels=c("Belle Isle", "Bell Isle (GRH)", "Nursery (MD)", "Nursery (MA)", "Nursery (NJ)", "Rowley", "Rowley (GRH)", "Rumney", "Rumney (GRH)"))+
  scale_fill_manual(values=c("paleturquoise3","gold3", "thistle3", "thistle2", "thistle", "paleturquoise2","gold2", "paleturquoise","gold"))+
  ylab("Heterozygosity Estimate")+
  ggtitle("(A) S. alterniflora")

grid.arrange(Anoclones, B, nrow=1)


## significance tests

sig_3_sa_nc<-aov(no_clones$hetero_est~no_clones$three)
summary(sig_3_sa_nc)
TukeyHSD(sig_3_sa_nc, conf.level = .95, las=2)

# for 9 groups

sig_9_sa_nc<-aov(no_clones$hetero_est~no_clones$names)
summary(sig_9_sa_nc)
TukeyHSD(sig_9_sa_nc, conf.level = .95, las=2)

#make tables
library(rlang)
library(jtools)


