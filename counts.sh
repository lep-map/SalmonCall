#!/bin/bash

#SBATCH --job-name=SNP_Call_Salmon2
#SBATCH --account=project_2000XXX
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --partition=small
#SBATCH --cpus-per-task=2
#SBATCH --nodes=1

module load samtools

echo "Calculating counts..."

samtools mpileup -l all.bed -q10 -Q10 -d200 -s $(cat sorted_bams)|awk -f pileup2counts.awk >counts_200.txt

#samtools mpileup -q10 -Q10 -d500 -s $(cat sorted_bams)|awk -f pileup2counts.awk >acounts.txt
#awk -f counts2gen.awk acounts.txt >allgen.txt
#awk '($2<100 && ($5>0.2 || $6>0.2 || $7>0.2) && ($5<0.8 || $6<0.8 || $7<0.8) && $8>=0.0004 && $9>=0.0004 && $10>=0.0004)' allgen.txt >selectgen.txt
