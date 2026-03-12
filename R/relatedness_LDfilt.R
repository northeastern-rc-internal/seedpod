## relatedness with LD filtered data
library(rlang)
library(ggplot2)
library(gridExtra)
library(ggsignif)

#read in the data for spal
spal<-read.table("/projects/seedpod/output/ngsRelate_subsetting/LD_filt_spal/newres_full", header=T)

names_full<-read.table("/projects/seedpod/rawdata/bam_lists/spal/filt_full_list", sep="/")

full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
sites_full<-cbind(full_meta[,c(2,3,4)])
sites_full$a<-seq(0:327)
sites_full$b<-seq(0:327)
sites_full$name<-paste(sites_full$V2, sites_full$V3, sites_full$V4, sep="_")
sites_full$sites<-paste(sites_full$V3, sites_full$V4, sep="_")

par(mfrow=c(1,1))
boxplot(spal$rab)

hist(spal$nSites)

hist(spal$rab, breaks=100, ylim=c(0,2000))#where rab is the pairwise relatedness
abline(v=0.98)
max(spal$rab)

library(dplyr)

# Rename your dataframe to avoid conflict with base R's df() function
my_df <- spal # <-- replace with your actual dataframe name

# Shift a and b from 0-based to 1-based to match sites_full's R indexing
my_df <- spal %>% mutate(a = as.integer(a) + 1L, b = as.integer(b) + 1L)
sites_full <- sites_full %>% mutate(a = as.integer(a))

# Create a lookup table keyed on sites_full$a
lookup <- sites_full %>% select(a, name, sites)

# Join twice: once for my_df$a and once for my_df$b, both looking up against sites_full$a
df_labeled <- my_df %>%
  left_join(
    lookup %>% rename(name_a = name, sites_a = sites),
    by = "a"
  ) %>%
  left_join(
    lookup %>% rename(name_b = name, sites_b = sites),
    by = c("b" = "a")
  )

# Optional: move labels to the front for readability
df_labeled <- df_labeled %>%
  relocate(name_a, sites_a, name_b, sites_b, .after = b)


## for sppa

sppa<-read.table("/projects/seedpod/output/ngsRelate_subsetting/LD_filt_sppa/newres", header=T)
names_sppa<-read.table("/projects/seedpod/rawdata/bam_lists/sppa/filt_full_list", sep="/")
full_meta_sppa<-as.data.frame(do.call(rbind, strsplit(names_sppa$V7, "_")))
sites_sppa<-cbind(full_meta_sppa[,c(2,3,4)])
sites_sppa$a<-seq(0:349)
sites_sppa$b<-seq(0:349)
sites_sppa$name<-paste(sites_sppa$V2, sites_sppa$V3, sites_sppa$V4, sep="_")
sites_sppa$sites<-paste(sites_sppa$V3, sites_sppa$V4, sep="_")

par(mfrow=c(1,1))
boxplot(sppa$rab)

#hist(sppa$nSites)

hist(sppa$rab, breaks=100, ylim=c(0,5000)) #where rab is the pairwise relatedness
max(sppa$rab)

## Label individuals

# Rename your dataframe to avoid conflict with base R's df() function
my_df_sppa <- sppa # <-- replace with your actual dataframe name

# Shift a and b from 0-based to 1-based to match sites_full's R indexing
my_df_sppa <- sppa %>% mutate(a = as.integer(a) + 1L, b = as.integer(b) + 1L)
sites_sppa <- sites_sppa %>% mutate(a = as.integer(a))

# Create a lookup table keyed on sites_full$a
lookup <- sites_sppa %>% select(a, name, sites)

# Join twice: once for my_df$a and once for my_df$b, both looking up against sites_full$a
df_labeled_sppa <- my_df_sppa %>%
  left_join(
    lookup %>% rename(name_a = name, sites_a = sites),
    by = "a"
  ) %>%
  left_join(
    lookup %>% rename(name_b = name, sites_b = sites),
    by = c("b" = "a")
  )

# Optional: move labels to the front for readability
df_labeled_sppa <- df_labeled_sppa %>%
  relocate(name_a, sites_a, name_b, sites_b, .after = b)

## New plots from claude

library(ggplot2)

# Recode site codes to plot names
#(MA for NEWP, NJ for Pinelands, and MD for Delmarva)
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
  BEL_ROS  = "Belle Isle",
  BEL_LBE  = "Belle Isle",
  BEL_KEY  = "Belle Isle"
)


threes_map <- c(
  RUM_S3   = "Local",
  RUM_S2   = "Local",
  RUM_S1   = "Local",
  ROW_S2   = "Local",
  ROW_S1B  = "Local",
  ROW_S1   = "Local",
  NUR_PINE = "Nursery",
  NUR_NEWP = "Nursery",
  NUR_DEMV = "Nursery",
  GRH_RUM  = "Greenhouse",
  GRH_PIS  = "Greenhouse",
  GRH_BEL  = "Greenhouse",
  BEL_ROS  = "Local",
  BEL_LBE  = "Local",
  BEL_KEY  = "Local"
)

df_labeled$threes_a <- threes_map[df_labeled$sites_a]
df_labeled$sites_a <- site_map[df_labeled$sites_a]
df_labeled$sites_b <- site_map[df_labeled$sites_b]

# Filter to pairs from the same location
df_same_site <- df_labeled[df_labeled$sites_a == df_labeled$sites_b, ]

# Order the three groups
df_same_site$sites_a <- factor(df_same_site$sites_a,
                                levels = c("Nursery (MD)","Nursery (MA)", "Nursery (NJ)", 
                                           "Belle Isle", "Belle Isle (GRH)",
                                           "Rowley", "Rowley (GRH)",
                                           "Rumney", "Rumney (GRH)"))



A<-ggplot(df_same_site, aes(x = sites_a, y = rab, fill = sites_a, group = sites_a)) +
  geom_boxplot(show.legend = FALSE, outlier.shape = 21,
               outlier.fill = "white", outlier.color = "gray40") +
  scale_x_discrete(
    name = "Site",
    labels =  c("Nursery (MD)","Nursery (MA)", "Nursery (NJ)", 
                "Belle Isle", "Belle Isle (GRH)",
                "Rowley", "Rowley (GRH)",
                "Rumney", "Rumney (GRH)")
  ) +
  scale_fill_manual(values = c("thistle2","thistle4","thistle3",
                               "paleturquoise", "gold", 
                               "paleturquoise3", "gold3",
                               "paleturquoise4", "gold4")) +
  ylim(0, 1) +
  ylab("Pairwise Relatedness") +
  ggtitle("(A) S. alterniflora") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title  = element_text(face = "italic")
  )


#### REPEAT FOR SPPA
# clean up the names
df_labeled_sppa$threes_a <- threes_map[df_labeled_sppa$sites_a]
df_labeled_sppa$sites_a <- site_map[df_labeled_sppa$sites_a]
df_labeled_sppa$sites_b <- site_map[df_labeled_sppa$sites_b]

# Filter to pairs from the same location
df_same_site_sppa <- df_labeled_sppa[df_labeled_sppa$sites_a == df_labeled_sppa$sites_b, ]
# Order the three groups
df_same_site_sppa$sites_a <- factor(df_same_site_sppa$sites_a,
                                    levels = c("Nursery (MD)","Nursery (MA)", "Nursery (NJ)", 
                                               "Belle Isle", "Belle Isle (GRH)",
                                               "Rowley", "Rowley (GRH)",
                                               "Rumney", "Rumney (GRH)"))

B<-ggplot(df_same_site_sppa, aes(x = sites_a, y = rab, fill = sites_a, group = sites_a)) +
  geom_boxplot(show.legend = FALSE, outlier.shape = 21,
               outlier.fill = "white", outlier.color = "gray40") +
  scale_x_discrete(
    name = "Site",
    labels =  c("Nursery (MD)","Nursery (MA)", "Nursery (NJ)", 
                "Belle Isle", "Belle Isle (GRH)",
                "Rowley", "Rowley (GRH)",
                "Rumney", "Rumney (GRH)")
  ) +
  scale_fill_manual(values = c("thistle2","thistle4","thistle3",
                               "paleturquoise", "gold", 
                               "paleturquoise3", "gold3",
                               "paleturquoise4", "gold4")) +
  ylim(0, 1) +
  ylab("Pairwise Relatedness") +
  ggtitle("(B) S. patens") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title  = element_text(face = "italic")
  )

grid.arrange(A, B, nrow=1)

#### By Threes

# Order the three groups
df_same_site$threes_a <- factor(df_same_site$threes_a,
                                levels = c("Nursery", "Local", "Greenhouse"))

# Order the three groups
df_same_site_sppa$threes_a <- factor(df_same_site_sppa$threes_a,
                                levels = c("Nursery", "Local", "Greenhouse"))

## do the stats Tukey HSD post-hoc test
aov_fit <- aov(rab ~ threes_a, data = df_same_site)
tukey   <- TukeyHSD(aov_fit)$threes_a


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
aov_fit_sppa <- aov(rab ~ threes_a, data = df_same_site_sppa)
tukey_sppa   <- TukeyHSD(aov_fit_sppa)$threes_a


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


C<-ggplot(df_same_site, aes(x = threes_a, y = rab, fill = threes_a)) +
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
  ylim(0, 1.35) +
  labs(x = "Site", y = "Pairwise Relatedness", title = "(A) S. alterniflora") +
  theme_minimal() +
  theme(plot.title = element_text(face = "italic"))


D<-ggplot(df_same_site_sppa, aes(x = threes_a, y = rab, fill = threes_a)) +
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
  ylim(0, 1.35) +
  labs(x = "Site", y = "Pairwise Relatedness", title = "(B) S. patens") +
  theme_minimal() +
  theme(plot.title = element_text(face = "italic"))

grid.arrange(C, D, nrow=1)

#run the models

## significance tests

rel_3_sa<-aov(df_same_site$rab~df_same_site$three)
summary(rel_3_sa)
TukeyHSD(rel_3_sa, conf.level = .95, las=2)

rel_3_sp<-aov(df_same_site_sppa$rab~df_same_site_sppa$three)
summary(rel_3_sp)
TukeyHSD(rel_3_sp, conf.level = .95, las=2)

# for 9 groups

rel_9_sa<-aov(df_same_site$rab~df_same_site$sites_a)
summary(rel_9_sa)
TukeyHSD(rel_9_sa, conf.level = .95, las=2)

rel_9_sp<-aov(df_same_site_sppa$rab~df_same_site_sppa$sites_a)
summary(rel_9_sp)
TukeyHSD(rel_9_sp, conf.level = .95, las=2)

## Check for clones in spal

clones_spal<-df_labeled[df_labeled$rab >= 0.999,]
clones_spal[,1:6]


clones_sppa<-df_labeled_sppa[df_labeled_sppa$rab >= 0.94,]
clones_sppa[,1:6]
