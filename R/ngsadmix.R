## plot ngsadmix
#remotes::install_github('royfrancis/pophelper')
library(pophelper)

# Get ID and pop info for each individual
names_full<-read.table("../data/spal_pca/decloned_full_list", sep="/")
full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
pop_full<-cbind(full_meta[,c(2,3,4)])
pop_full$a<-seq(0:321)
pop_full$sites<-paste(pop_full$V3, pop_full$V4, sep="_")

#(MA for NEWP, NJ for Pinelands, and MD for Delmarva)

names<-cbind(c(unique(pop_full$sites)), c("Rumney", "Rowley", "Belle Isle","Rumney", "Belle Isle","Rowley", "Rowley","Rumney", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)", "Nursery (NJ)", "Nursery (MD)", "Nursery (MA)"),
             c("chartreuse4", "chartreuse4", "coral4", "coral4", "cyan4", "chartreuse4", "cyan4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1","darkslategray4", "grey", "cornsilk2"))

colnames(names)<-c("sites", "names", "colors")

pop<-merge(names, pop_full)

#sort pop
pop_o<-pop[order(pop$a),]

# Plot them (ordered by population)
ord = order(pop_o$a)


# get files in the correct format

sfiles <- list.files(path="../data/spal_ngsadmix_data/", pattern="*.qopt", full.names=T)
slist <- readQ(files=sfiles,indlabfromfile=T)



grpname<-data.frame("site"= pop_o$names)

p1<-plotQ(slist[2:4],imgoutput="join", exportplot = F, returnplot = T, grplab=grpname,
          grplabsize=4, grplabheight = 1, linesize=0.6, pointsize=6, grplabjust=0.5,
          splabsize=12, splab=c("K = 3", "K = 4", "K = 5"),
          showyaxis=T,showticks=T,sortind="Cluster1",sharedindlab=F,showindlab=F,
          barbordercolour="white",barbordersize=0,
          clustercol=c("black", "grey39", "grey48", "grey", "grey89"),
          showsp=T,  grplabangle = 20, ordergrp=T,
          subset=c("Nursery (MA)", "Nursery (MD)", "Nursery (NJ)", "Belle Isle", "Belle Isle (GRH)","Rowley", "Rowley (GRH)", "Rumney", 
                   "Rumney (GRH)"))


plot(p1$plot[[1]])



#### for SPPA
# Get ID and pop info for each individual
names_full<-read.table("../data/sppa_pca/filt_full_list", sep="/")
full_meta<-as.data.frame(do.call(rbind, strsplit(names_full$V7, "_")))
pop_full<-cbind(full_meta[,c(2,3,4)])
pop_full$a<-seq(0:349)
pop_full$sites<-paste(pop_full$V3, pop_full$V4, sep="_")

#(MA for NEWP, NJ for Pinelands, and MD for Delmarva)

# check names
unique(pop_full$sites)

names<-cbind(c(unique(pop_full$sites)), c( "Nursery (MD)",  "Nursery (MA)", "Nursery (NJ)", "Rumney", "Rumney", "Rowley","Rowley", "Belle Isle","Rumney", "Belle Isle","Rowley", "Belle Isle", "Rumney (GRH)", "Rowley (GRH)", "Belle Isle (GRH)"),
             c("chartreuse4", "chartreuse4", "coral4", "coral4", "cyan4", "chartreuse4", "cyan4", "coral4", "cyan4", "chartreuse2", "coral1", "cyan1","darkslategray4", "grey", "cornsilk2"))

colnames(names)<-c("sites", "names", "colors")

pop<-merge(pop_full, names)

#sort pop
pop_o<-pop[order(pop$a),]

# Plot them (ordered by population)
ord = order(pop$names)

#make pretty with pophelper
library(pophelper)

# get files in the correct format

sfiles <- list.files(path="../data/sppa_ngsadmix_data/", pattern="*.qopt", full.names=T)
slist <- readQ(files=sfiles,indlabfromfile=T)


grpname<-data.frame("site"= pop_o$names)



p1<-plotQ(slist[2:4],imgoutput="join", exportplot = F, returnplot = T, grplab=grpname,
          grplabsize=4, grplabheight = 1, linesize=0.6, pointsize=6, grplabjust=0.5,
          splabsize=12, splab=c("K = 3", "K = 4", "K = 5"),
          showyaxis=T,showticks=T,sortind="Cluster1",sharedindlab=F,showindlab=F,
          barbordercolour="white",barbordersize=0,
          clustercol=c("black", "grey39", "grey48", "grey", "grey89"),
          showsp=T,  grplabangle = 20, ordergrp=T,
          subset=c("Nursery (MA)", "Nursery (MD)", "Nursery (NJ)", "Belle Isle", "Belle Isle (GRH)","Rowley", "Rowley (GRH)", "Rumney", 
                   "Rumney (GRH)"))

plot(p1$plot[[1]])
