# seedpod
Co-Op project to containerize an entire bioinformatic workflow into a seedpod.


We built a bioinformatics container image which includes the following software:

* FastQC/MultiQC
* Miniconda
* ipyrad
* ANGSD
* PCAngsd
* plink2
* R
vcftools
bcftools
ngsrelate
FEEMS

The image is available for use at: containers.rc.northeastern.edu/seedpod/seedpod:rstudio

It can be pulled down to an HPC system with the following command:

apptainer pull --docker-login docker://containers.rc.northeastern.edu/seedpod/seedpod:rstudio
