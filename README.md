# Acastellanii_transgene_analysis

## Rate of read chimerism analysis

### 

`qsub minimap2.sh` to map nanopore reads against the reference genome plus the plasmid sequence using minimap2. 

`grep -v c350_g1_i2 LT9_vs_comb.paf > LT9_vs_comb_no_plasmid.paf` to produce a new PAF file without the mappings to the plasmid. 

`cut -f1 LT9_vs_comb_no_plasmid.paf | sort | uniq -c | sort -n > LT9numbersforpafswithoutplasmid`
`grep " 2 " LT9numbersforpafswithoutplasmid > LT9doubleswithoutplasmid`
`perl chim_reads.pl | wc -l`

cut -f1 
