#!/bin/bash
#SBATCH --job-name=ngsAdmix_job
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --time=24:00:00

# Load Singularity module

# Define paths
CONTAINER_IMAGE="/projects/seedpod/container/seedpod_rstudio.sif"
DATA_DIR="/projects/seedpod/output/angsd_sppa_SC"
OUT_DIR="/projects/seedpod/output/ngsadmix_SC/sppa"
LIKES_FILE=LD_filtfilt_full_list.beagle.gz
OUTPUT_PREFIX="${OUT_DIR}/LD_filt_full_admix_5"

# Run ngsAdmix within Singularity container
singularity exec -B "/projects:/projects" $CONTAINER_IMAGE /opt/angsd/misc/NGSadmix \
    -likes $DATA_DIR/$LIKES_FILE \
    -K 5 \
    -o $OUTPUT_PREFIX \
    -printInfo \
    -seed123 \
    -P 4 \
    -method 1 \
    -misTol 0.05 \
    -tolLike50 0.0001 \
    -tol 0.0001 \
    -dymBound 1 \
    -maxiter 5000 \
    -minMaf 0.05 \
    -minLrt 0.05 

