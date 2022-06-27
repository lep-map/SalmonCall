#!/bin/bash

#SBATCH --job-name=SNP_Call_Salmon2
#SBATCH --account=project_2000XXX
#SBATCH --time=12:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --partition=small
#SBATCH --cpus-per-task=16
#SBATCH --nodes=1

ulimit -n 32000

module load gcc
module load bwa
module load samtools
module load parallel

echo "Mapping reads..."

bwa index sequence3.fasta

#bwa mem + samtools
for i in *.fastq.gz
do 
	echo "bwa mem sequence3.fasta $i 2>>err|samtools view -b -|samtools sort - -T $(basename $i .fastq).tmp -o $(basename $i .fastq.gz).bam"
done|parallel --jobs 16

echo "Indexing bams..."

for i in *.bam
do
	echo "samtools index $i"
done|parallel --jobs 16


#modified Lep-MAP3 pipeline
ls *.bam >sorted_bams
sed -e 's/.bam$//g' sorted_bams >mapping.txt

echo "Calculating allele counts..."


cut -f 1,2 selectgen.txt >all.bed
samtools mpileup -a -l all.bed -q10 -Q10 -d500 -s $(cat sorted_bams)|awk -f pileup2counts.awk >counts.txt

echo "Calling variants..."

awk -f call.awk selectgen.txt counts.txt >calls.txt
awk -f toNumeric.awk calls.txt >calls.1234

echo "Computing allele ratios..."

awk -f ratios.awk counts.txt >ratios.txt
module load r-env-singularity
cat ratios.R|R --vanilla

echo "All done."

#create selectgen.txt and all.bed
#samtools mpileup -q10 -Q10 -d500 -s $(cat sorted_bams)|awk -f pileup2counts.awk >acounts.txt
#awk -f counts2gen.awk acounts.txt >allgen.txt
#awk '($2<100 && ($5>0.2 || $6>0.2 || $7>0.2) && ($5<0.8 || $6<0.8 || $7<0.8) && $8>=0.0004 && $9>=0.0004 && $10>=0.0004)' allgen.txt >selectgen.txt
#manually edit selectgen.txt
