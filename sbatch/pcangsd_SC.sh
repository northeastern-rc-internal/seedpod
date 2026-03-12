#!/bin/bash
#SBATCH -N 1
#SBATCH -p short
#SBATCH -t 24:00:00
#SBATCH -n 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user@northeastern.edu

echo "Job started at: $(date)"


DATA_DIR="/projects/seedpod/output/angsd_sppa_SC/"
OUT_PREFIX="/projects/seedpod/output/pcangsd_SC/sppa/"
SINGULARITY_IMAGE="/projects/seedpod/container/seedpod_latest.sif"
site=filt_source


# Define paths
#for filename in /work/seedpod/output/angsd_sppa_SC/filt*list.beagle.gz
#do

#    base=$(basename $filename)
#    echo $base

#echo "Running pcangsd inside Singularity container..."
apptainer exec -B "/projects:/projects" $SINGULARITY_IMAGE pcangsd -b $DATA_DIR/LD_${site}_list.beagle.gz -o $OUT_PREFIX/LD_${site} -t 8 --pcadapt 

echo "Job finished at: $(date)"

done
