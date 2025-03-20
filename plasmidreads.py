from Bio import SeqIO

read_IDs = {}
blast = open('<tabulated BLAST output>','r')
for line in blast:
	parts = line.split('\t')
	readID = parts[0]
	read_IDs[readID] = ''
	
blast.close()

preads = open('<FASTA file of reads that hit to plasmid>','a')

with open('<all nanopore reads from the clone>','r') as allreads:
    for record in SeqIO.parse(allreads, "fasta"):
        if record.id in read_IDs:
            preads.write(">" + str(record.id) + '\n' + str(record.seq) + '\n')
            
preads.close()
