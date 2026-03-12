#!/bin/bash
#SBATCH -N 1
#SBATCH -p short
#SBATCH -t 5:00:00
#SBATCH -n 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user@northeastern.edu
echo "Job started at: $(date)"


species=sppa
site=filt_nur
ind=30

SITES="/projects/seedpod/output/SPPALLD_unlinked.pos"
SINGULARITY_IMAGE="/projects/seedpod/container/seedpod_rstudio.sif"
BAMLIST="/projects/seedpod/rawdata/bam_lists/${species}/${site}_list"
REF="/projects/seedpod/reference/updated.fasta"
OUTDIR="/projects/seedpod/output/angsd_${species}_SC"
#ANGSD_OPTIONS="-GL 2 -doMaf 2 -SNP_pval 1e-6 -doMajorMinor 1 -doGeno 32 -doPost 1 -postCutoff 0.95 -minMaf 0.05 -minInd 300 -minMapQ 30 -minQ 20"
ANGSD_OPTIONS="-sites $SITES -GL 2 -doMajorMinor 1  -doGlf 2 -doMaf 2 -SNP_pval 1e-6 -minMapQ 30 -minQ 20 -minMaf 0.05 -minInd $ind"
# Default to 32 CPUs if SLURM_CPUS_PER_TASK is not set
SLURM_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK:-8}

echo "Using ${SLURM_CPUS_PER_TASK} CPUs for ANGSD."

apptainer exec -B "/projects:/projects" $SINGULARITY_IMAGE \
	 angsd -b $BAMLIST -ref $REF -out $OUTDIR/LD_${site}_list $ANGSD_OPTIONS -P ${SLURM_CPUS_PER_TASK} 

