#!/bin/bash
#SBATCH -N 1
#SBATCH -p short
#SBATCH -t 24:00:00
#SBATCH -n 1
#SBATCH --mem=50G
#SBATCH --cpus-per-task=12
##SBATCH --array=0-5

echo "Job started at: $(date)"


SINGULARITY_IMAGE="/projects/seedpod/container/seedpod_latest.sif"
BAMLIST="/projects/seedpod/rawdata/bam_lists/sppa/filt_full_list"
#BAMLIST="/work/seedpod/rawdata/bam_lists/combined_species/combined_filt_list"
REF="/projects/seedpod/reference/updated.fasta"
OUTDIR="/projects/seedpod/output/ngsRelate_subsetting/LD_filt_sppa"
#OUTDIR="/work/seedpod/output/ngsRelate_subsetting/filtered_low_read_removed"
#SITEDIR="/work/seedpod/output/ngsRelate_subsetting/all_samples"
GDIR="/projects/seedpod/output/angsd_sppa_SC/"
sites="/projects/seedpod/output/angsd_sppa_SC/SPPALLD_unlinked.pos"

apptainer exec -B "/projects:/projects" $SINGULARITY_IMAGE bash -c "
  set -e
  #sort sites file then index it
  #sort -k 1 -n -b -f -t $'\t' $SITEDIR/sppa_${SLURM_ARRAY_TASK_ID}_sites > $SITEDIR/sppa_${SLURM_ARRAY_TASK_ID}_sites_sorted
  #angsd sites index $SITEDIR/sppa_${SLURM_ARRAY_TASK_ID}_sites_sorted
  angsd -b $BAMLIST -gl 2 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -domajorminor 1 -doGlf 3 -sites $sites -out $GDIR/relatedness_LD_filt
  #angsd -b $BAMLIST -gl 2 -minInd 650 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -domajorminor 1 -doGlf 3 -sites -out $OUTDIR/combined_result
  
  zcat $GDIR/relatedness_LD_filt.mafs.gz | cut -f5 | sed 1d > $OUTDIR/freqs
  
  #zcat $OUTDIR/sppa_${SLURM_ARRAY_TASK_ID}_result.mafs.gz | cut -f5 | sed 1d > $OUTDIR/sppa_${SLURM_ARRAY_TASK_ID}_freq
  
  echo 'Running NgsRelate...'
  #ngsRelate -g $OUTDIR/sppa_${SLURM_ARRAY_TASK_ID}_result.glf.gz -n 350 -f $OUTDIR/sppa_${SLURM_ARRAY_TASK_ID}_freq -O $OUTDIR/sppa_${SLURM_ARRAY_TASK_ID}_newres
  ngsRelate -g $GDIR/relatedness_LD_filt.glf.gz -n 350 -f $OUTDIR/freqs -O $OUTDIR/newres
"
echo "Job finished at: $(date)"
