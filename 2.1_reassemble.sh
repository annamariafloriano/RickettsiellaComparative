## Commands for refined assembly after blobology

SPAdes="/PATH/TO/spades.py"
Extract_SelectedReads="/PATH/TO/bowtie2_extract_reads_mapped_to_specific_contigs.pl"

## remove the header from the table
sed -i '1d' SELECTED_BLOB_CONTIGS.tab

## obtain a list of contigs (select first column)
cut -f1 SELECTED_BLOB_CONTIGS.tab > SELECTED_BLOB_CONTIGS.list

## Extract the reads mapping on the selected contigs
perl $Extract_SelectedReads -s <(samtools view contigs.fasta.bowtie2.bam) -id SELECTED_BLOB_CONTIGS.list
## output: SELECTED_BLOB_CONTIGS.list.mapped.reads.fq.gz

## Assemble the reads

python $SPAdes --12 SELECTED_BLOB_CONTIGS.list.mapped.reads.fq.gz --careful -t 10 -o Reassembly

###### !!! Open the assembly graph (.fastg or .gfa SPAdes-generated file) in Bandage to improve assembly quality by selecting contigs with blast hits on the target organism and contigs connected to them in the graph. At this point it is also possible to map the Selected_blob_contigs.list.mapped.reads.fq.gz reads on this selection, extract them again, and assemble again with SPAdes.
