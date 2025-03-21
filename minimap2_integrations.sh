#!/bin/bash
#$ -S /bin/bash
. /etc/profile
#$ -cwd
#$ -pe threaded 12


REFERENCE=<path to reference>
READS=<path to forward reads>
PREFIX=<prefix>
THREADS=<threads>
THREADS_MINUS_ONE=<threads minus one>


source activate minimap2
minimap2 -a -Y -t $THREADS -x map-ont $REFERENCE $READS > $PREFIX.sam 
conda deactivate


/usr/bin/samtools view -@ $THREADS_MINUS_ONE -b -o $PREFIX.bam $PREFIX.sam
/usr/bin/samtools sort -@ $THREADS_MINUS_ONE -o $PREFIX.sorted.bam $PREFIX.bam
/usr/bin/samtools index -b $PREFIX.sorted.bam $PREFIX.sorted.bam.bai
