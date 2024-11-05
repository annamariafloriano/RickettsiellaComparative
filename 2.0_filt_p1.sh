#!/bin/bash

###requires taxdump and taxids in the nt 
###careful with reads directory name and path!!!

##launch: 2.0_filt_p1.sh -t [hostreference] -m [mitoreference]

while getopts t:m: flag
do
    case "${flag}" in
        t) host=${OPTARG};;
        m) mito=${OPTARG};;
    esac
done


SPAdes="/PATH/TO/SPADES/spades.py"
TAXDUMP="/PATH/TO/taxdump"
NT="/PATH/TO/NT/nt"
GC_COV_annotate="/PATH/TO/gc_cov_annotate.pl"

### !!! Have the reference genomes of host and mitochondria in the directory where you run this script

### first create dirs for each sample and create symb links for the reads in the different dirs

## doing this with a subset of reads samples
### CAREFUL: check if these commands work before running the script (fields of interest may change)

ls /PATH/TO/READS/*.gz | cut -d "/" -f6 | cut -d "_" -f1,2 | sort | uniq > list
mapfile -t arr < list; mkdir -p "${arr[@]%/*}" ## create dirs for each sample from the list

for r in /PATH/TO/READS/*gz
do
    rname=${r##*/}
    rname=${rname%_L001*}
    dir=${rname}
    if [[ -d $dir ]]; then
        cp "$r" "$dir"/
    fi
done


### map reads against a host reference genome, and run blobology on the reads not aligning to the host nuclear genome


alldirs=$(ls -d -- */)

for dir in $alldirs
do
    cd $dir
    echo "in $dir"
    fw="*R1*"
    rv="*R2*"
    ## Map against host genome
    echo "mapping to host genome START"
    echo $(date -u)
    bowtie2 -x ../$host --very-fast-local -k 1 -t -p 15 --reorder --mm -1 $fw -2 $rv -S HostMap.sam ##map
    echo "mapping to host genome FINISH"
    echo $(date -u)
    samtools view -SbT ../$host HostMap.sam > HostMap.bam ##convert SAM to BAM
    rm HostMap.sam ##rm SAM
    echo "Converted to BAM"
    echo $(date -u)
    samtools view -b -f 4 HostMap.bam > NotHost.bam ##get reads not aligned to host genome
    samtools sort -n NotHost.bam -o NotHost.bam.sort ##get forward and reverse reads in FASTQ format
    samtools fastq -1 NotHost_fw.fq -2 NotHost_rv.fq -0 /dev/null -s /dev/null -N NotHost.bam.sort
    echo "got unaligned reads"
    echo $(date -u)
    rm $fw
    rm $rv
    rm NotHost.bam
    rm NotHost.bam.sort
    ##assemble the reads not aligned to the host genome
    echo "preliminary assembly START"
    echo $(date -u)
    python $SPAdes -1 NotHost_fw.fq -2 NotHost_rv.fq --only-assembler -k 101 -t 15 -m 450 -o PreliminaryAssembly ## assemble reads
    rm -r PreliminaryAssembly/tmp ## remove tmp folder
    rm -r PreliminaryAssembly/misc ## remove misc folder
    rm -r PreliminaryAssembly/K* ## remove Kmers folder
    PrelAssembly="PreliminaryAssembly/contigs.fasta" ## this is the preliminary assembly
    echo "preliminary assembly END"
    echo $(date -u)
    ## Get taxonomic annotation (taxids)
    echo "BLAST START"
    echo $(date -u)
    blastn -task megablast -query $PrelAssembly -db $NT -evalue 1e-5 -num_threads 15 -max_target_seqs 1 -outfmt '6 qseqid staxids' -out preliminary.megablast ## blast prel. assembly to get taxids
    echo "BLAST END"
    echo $(date -u)
    echo "build ref bowtie START"
    echo $(date -u)
    bowtie2-build $PrelAssembly $PrelAssembly ##mapping to get coverage: build reference preliminary assembly
    echo "build ref bowtie END"
    echo $(date -u)
    bowtie2 -x $PrelAssembly --very-fast-local -k 1 -t -p 15 --reorder --mm -1 NotHost_fw.fq -2 NotHost_rv.fq -S mapped.sam ##mapping to get coverage: actual mapping
    echo "mapping END"
    echo $(date -u)
    gzip NotHost_fw.fq
    gzip NotHost_rv.fq
    samtools view -SbT $PrelAssembly mapped.sam > contigs.fasta.bowtie2.bam ##convert to BAM
    echo "Converted to BAM"
    echo $(date -u)
    rm mapped.sam ##remove the big SAM file
    
    ## Obtain the blobplot table (to be plotted later in R)
    perl $GC_COV_annotate --blasttaxid preliminary.megablast --assembly $PrelAssembly --bam contigs.fasta.bowtie2.bam --out blobplot.tab --taxdump $TAXDUMP --taxlist species genus order phylum superkingdom
    echo "obtain blobplot table"
    echo $(date -u)
    Rscript ../2.0_Rplot.R  
    echo "plots created"
    echo $(date -u)
    blastn -task megablast -query $PrelAssembly -db ../$mito -evalue 1e-5 -num_threads 15 -max_target_seqs 1 -outfmt '6 qseqid sseqid' -out preliminary_mitohit.tab
    echo "mito hits obtained"
    echo $(date -u)
    gzip preliminary.megablast
    gzip $PrelAssembly
    cd PreliminaryAssembly/
    gzip *.gfa
    gzip *.fastg
    cd ..
    cd ..
done












