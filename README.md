# Acastellanii_transgene_analysis

## Rate of read chimerism analysis

### 

1. `qsub minimap2.sh` to map nanopore reads against the reference genome plus the plasmid sequence using minimap2. 

2. `grep -v c350_g1_i2 LT9_vs_comb.paf > LT9_vs_comb_no_plasmid.paf` to produce a new PAF file without the mappings to the plasmid. 

3. `cut -f1 LT9_vs_comb_no_plasmid.paf | sort | uniq -c | sort -n > LT9numbersforpafswithoutplasmid` to produce a text file with counts of each read represented in the output of the previous step.

4. `grep " 2 " LT9numbersforpafswithoutplasmid > LT9doubleswithoutplasmid` to retrieve a list of read IDs for which exactly two mappings are found.
   
5. `perl chim_reads.pl | wc -l` running this perl script will list all unique reads that satisfy the chimerism criteria. Piping into wc -l will output the number of reads in the 'lines' field of the wc output.

6. `cut -f1 LT9_vs_comb_no_plasmid.paf | sort | uniq | wc -l` to output the total number of reads that mapped to the genome (but not the plasmid) in the 'lines' field of the wc output.

7. The outputs of steps 5 and 6 can be used to calculate the estimated rate of chimerism in the sequencing run.

8. `grep c350_ LT9_vs_comb.paf | cut -f1 | sort | uniq | wc` to output the number of reads in the sequencing run that map to the plasmid.

9. Multiply the estimated rate of chimerism by the number of plasmid-mapping reads to estimate the number of putative plasmid-genome junctions that could be explained by artificially chimeric reads.

## 
