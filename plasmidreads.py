from Bio import SeqIO

read_IDs = {}
blast = open('/scratch4/mcolp/TRANSGENES/LINEAR/BASECALLED/BASECALLED/LT9/LT9_vs_plasmid_tab.out','r')
for line in blast:
	parts = line.split('\t')
	readID = parts[0]
	read_IDs[readID] = ''
	
blast.close()

preads = open('/scratch4/mcolp/TRANSGENES/LINEAR/BASECALLED/BASECALLED/LT9/LT9_plasmid_reads.fasta','a')

with open('/scratch4/mcolp/TRANSGENES/LINEAR/BASECALLED/BASECALLED/LT9/Ac_LT9_all.fasta','r') as allreads:
    for record in SeqIO.parse(allreads, "fasta"):
        if record.id in read_IDs:
            preads.write(">" + str(record.id) + '\n' + str(record.seq) + '\n')
            
preads.close()
