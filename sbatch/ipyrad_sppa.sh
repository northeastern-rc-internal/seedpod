#!/bin/bash
#SBATCH -N 1
#SBATCH -p short
#SBATCH -t 24:00:00
#SBATCH --exclusive
#SBATCH -n 1
#SBATCH --cpus-per-task=32
#SBATCH --mail-type=ALL
#SBATCH --mail-user=user@northeastern.edu
#SBATCH --output=/work/seedpod/test/sppa_%j.out  # Log file for stdout
#SBATCH --error=/work/seedpod/test/sppa_%j.err   # Log file for stderr

echo "Job started at: $(date)"

module load singularity/3.10.3

SINGULARITY_IMAGE="/work/seedpod/test/seedpod_R.sif"
cd /work/seedpod/container

singularity exec -B "/work:/work" $SINGULARITY_IMAGE bash -c "
  set -e
  echo 'Activating Conda environment...'
  . /opt/miniconda/etc/profile.d/conda.sh
  conda activate ipyrad
  echo 'Environment activated.'

  echo 'Stopping any running ipcluster instances...'
  ipcluster stop --profile=sppa || echo 'No ipcluster to stop.'
  echo 'Starting ipcluster...'
  ipcluster start --profile=sppa  --n 24 --daemonize
  sleep 10  # Give ipcluster some time to start

  echo 'Running ipyrad...'
  ipyrad -p /work/seedpod/test/params-sppa.txt -s  567  -f -c 32    

  echo 'Stopping ipcluster...'
  ipcluster stop --profile=sppa
"

echo "Job finished at: $(date)"i
