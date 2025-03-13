#!/usr/bin/perl 

%HOLD=();

open (FI,"C1_deep_vs_comb_no_plasmid.paf");
while (<FI>)
{
$fline=$_; #assigning each line of the PAF to $fline
chomp($fline);
@fields=split; #splitting the PAF line into its columns
$name=$fields[0]; #the first field in the PAF line is the read name
	if ($HOLD{$name} =~/[0-9]/)  #if this read name has already been processed and added to HOLD, the value of $name will contain numbers
		{
		$HOLD{$name}=$HOLD{$name}."\#".$fline; #in this case the present line is appended to $HOLD{$name} with a # to separate it from the previous
		}
	else
		{
		
		$HOLD{$name}=$fline; #if $HOLD{$name} did not contain numbers it means this read has not yet been processed, so this line of the PAF is simply added to $HOLD
		
		}


}
close FI;



open (FI,"doubleswithoutplasmid"); #opening a list of read IDs that have only 2 mappings to the genome and do not contain plasmid sequence
while (<FI>)
{
$fline=$_; #assigning each line of the list to $fline
chomp($fline);
@dfields=split; #each line contains a count in the first column and a read ID in the second


@paflines=split(/\#/,$HOLD{$dfields[1]}); #looks up the read ID in $HOLD and splits at #, then assigns to $paflines
	@map1=split(/\t/,$paflines[0]); #since we are only considering reads that have exactly two mappings, we can assign the two indices in paflines to @map1 and @map2
	@map2=split(/\t/,$paflines[1]);

		$map1start=$map1[2]; #within each of the PAF lines, index 2 is the coordinate on the read where the mapping starts
		$map1end=$map1[3]; #within each of the PAF lines, index 3 is the coordinate on the read where the mapping ends
		$map2start=$map2[2]; #doing the same for the second mapping
        $map2end=$map2[3];
			if ((($map2start >= $map1start) && ($map2start <= $map1end)) ||(($map1start >= $map2start) && ($map1start <= $map2end)) ||(($map1end >= $map2start) && ($map1end <= $map2end)) ||(($map2end >= $map1start) && ($map2end <= $map1end)))
				{
				next; #if the read satisfies the if statement, it cannot meet our criteria for chimerism
				}

			else
				{
				
				$map1startp=$map1[7]; #within each PAF line, index 7 is the coordinate on the genome where the mapping starts
				$map1endp=$map1[8]; #within each PAF line, index 8 is the coordinate on the genome where the mapping ends
				$map2startp=$map2[7]; #repeating for the second mapping
        		$map2endp=$map2[8];
                    #the following if statement checks if the start or end coordinate of either mapping is within the coordinates of the other, provided they map to the same scaffold
                    #essentially, checking if the two mappings for the read overlap on the genome, which excludes them from our chimerism criteria    		
        			if ((($map2startp >= $map1startp) && ($map2startp <= $map1endp) && ($map1[5] eq $map2[5])) ||(($map1startp >= $map2startp) && ($map1startp <= $map2endp) && ($map1[5] eq $map2[5])) ||(($map1endp >= $map2startp) && ($map1endp <= $map2endp) && ($map1[5] eq $map2[5])) ||(($map2endp >= $map1startp) && ($map2endp <= $map1endp) && ($map1[5] eq $map2[5])))
						{
						next;
						}
					else
						{

						$scaff1length=$map1[6]; #within a PAF line, the scaffold length is at index 6
						$scaff2length=$map2[6];
						#now checking if either of the mappings are within 100 bp of the end of a scaffold
						#if they are, they are excluded from our chimerism criteria
						if ((($map1startp<100) || ($scaff1length-$map1endp<100)) && (($map2startp<100) || ($scaff2length-$map2endp<100)))
							{
							next;
									
							}
						else
							{
							#sorting the read coordinates of the mappings
							$READMAPS[0]=$map1start;
							$READMAPS[1]=$map1end;
							$READMAPS[2]=$map2start;
							$READMAPS[3]=$map2end;
							@sortedreadmaps =sort {$a <=> $b} @READMAPS;
								
							#sorting the genomic coordinates of the mappings	
							$GENOMEMAPS[0]=$map1startp;
							$GENOMEMAPS[1]=$map1endp;
							$GENOMEMAPS[2]=$map2startp;
							$GENOMEMAPS[3]=$map2endp;
							@sortedgenomemaps= sort {$a <=> $b} @GENOMEMAPS;
							
							#since we already checked that the mappings don't overlap, the distance between indices 1 and 2 will be the distance between the mappings	
							$read_distance=$sortedreadmaps[2]-$sortedreadmaps[1];
							$genome_distance=$sortedgenomemaps[2]-$sortedgenomemaps[1];
							
							#if the mappings are on the same scaffold we need to check how far apart they are
							if ($map1[5] eq $map2[5])
								{
								#checking whether the mappings are less than 500 bp apart on the genome, and whether their distance on the genome is less than than (distance on the read + 100)
								
								if ((($genome_distance <500) || (($read_distance+100) >$genome_distance)))
									{
									#if either of these are true, this read is excluded from our chimerism criteria		
									next;
									}
								
								else
									{
									#if these are not true, the mappings are not too close together on the genome
									#at this point the read has met all of our chimerism criteria so we print its ID
									print "$paflines[0]\n";
									}
											
								}
							
							else
								{
								#at this point the read has met all of our chimerism criteria so we print its ID
								print "$paflines[0]\n ";
								}
									
							}
						
						
						}
        			
				
				
				}


}
close FI;

