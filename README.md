# Bioinformatic analysis of artificial transgenes in _Acanthamoeba castellanii_

This repository serves to document the bioinformatic analyses conducted for the study 'The fate of artificial transgenes in _Acanthamoeba castellanii_' (full reference to come). The process as performed for the study was somewhat ad hoc and as such there is no fully formed pipeline reported here, although some or all steps may be amenable to further automation. Analyses were run on an HPC at Dalhousie University that uses an Oracle Grid Engine queue system and anaconda-based Python environment management, so most bash (.sh) scripts are formatted as submission scripts for this queue system and may need to be adapted to the needs of the user. The usage of the bioinformatic tools themselves can be found after the initial block of text used by the queueing system in these scripts.

Associated data: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15019835.svg)](https://doi.org/10.5281/zenodo.15019835)

## Searching for possible transgene integrations

This process was performed independently for the nanopore read sets from 'mixed transformants' and each of the clones analyzed in the study. For each read set, plasmidreads.py and minimap2_integrations.sh should be modified accordingly. File names are currently hard-coded into these scripts, but users may prefer modifying the Python script to accept options on the command line.

1. On a computer or server with BLAST installed, `blastn -query <transformant reads> -db <wild-type genome> -out <outfile> -outfmt 6` to identify all reads with hits to the plasmid and output in tabulated format.

2. `python plasmidreads.py` to retrieve all of the reads identified above in a separate multi-FASTA file.

3. `qsub minimap2_integrations.sh` to map the plasmid-matching reads against the reference genome using [minimap2](https://github.com/lh3/minimap2) with soft-clipping allowed, using the script [minimap2_integrations.sh](minimap2_integrations.sh)

4. The mapping was visualized in [IGV](https://github.com/igvteam/igv) as an easy way to browse each potential transgene integration and record them manually in a spreadsheet. Because soft-clipping was allowed, reads containing both plasmid and genomic sequence map to their corresponding genomic locus without interference from the plasmid-derived portion of the read.

  BLAST was used to double-check that the soft-clipped part was actually plasmid sequence. I did this manually by comparing the putative integration reads with the plasmid sequence in the BLAST web interface but there is no reason a combination of command line BLAST and scripts could not be used to streamline the process.


## Rate of read chimerism analysis

These steps use the analysis of Clone LT9 and its associated file names as an example. The only necessary change to the commands below for analysis of another clone is to replace any file name starting with LT9 with the relevant file name, and to modify minimap2_chimerism.sh and chim_reads.pl accordingly. File names are currently hard-coded into these scripts, but users may prefer modifying the perl script to accept options on the command line. 

1. `qsub minimap2_chimerism.sh` to map nanopore reads against the reference genome plus the plasmid sequence using [minimap2](https://github.com/lh3/minimap2) with [minimap2_chimerism.sh](minimap2_chimerism.sh)

2. `grep -v c350_g1_i2 LT9_vs_combined.paf > LT9_vs_combined_no_plasmid.paf` to produce a new PAF file without the mappings to the plasmid. 'c350_g1_i2' is a string unique to the FASTA header of the plasmid sequence in these analyses. 

3. `cut -f1 LT9_vs_combined_no_plasmid.paf | sort | uniq -c | sort -n > LT9_mappings_per_read` to produce a text file with counts of each read represented in the output of the previous step.

4. `grep " 2 " LT9_mappings_per_read > LT9_double_map_reads` to retrieve a list of read IDs for which exactly two mappings are found.
   
5. `perl chim_reads.pl | wc -l` running this perl script will list all unique reads that satisfy the chimerism criteria. Piping into `wc -l` will output the number of reads in the 'lines' field of the wc output.

6. `cut -f1 LT9_vs_combined_no_plasmid.paf | sort | uniq | wc -l` to output the total number of reads that mapped to the genome (but not the plasmid) in the 'lines' field of the wc output.

7. The outputs of steps 5 and 6 can be used to calculate the estimated rate of chimerism in the sequencing run.

8. `grep c350_ LT9_vs_combined.paf | cut -f1 | sort | uniq | wc` to output the number of reads in the sequencing run that map to the plasmid. 

9. Multiply the estimated rate of chimerism by the number of plasmid-mapping reads to estimate the number of putative plasmid-genome junctions that could be explained by artificially chimeric reads.



