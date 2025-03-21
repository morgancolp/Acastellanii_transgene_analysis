#!/bin/bash
#$ -S /bin/bash
. /etc/profile
#$ -cwd
#$ -pe threaded 12


REFERENCE=<path to reference>
READS=<path to reads>
PREFIX=<desired prefix>
THREADS=12


source activate minimap2
minimap2 -Y -t $THREADS -x map-ont $REFERENCE $READS > $PREFIX.paf 
conda deactivate
