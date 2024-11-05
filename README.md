# RickettsiellaComparative
Commands and pipelines for comparative genomics of Rickettsiella.

Not included in this pipeline: quality check (e.g., FastQC), trimming and adapter removal (e.g., Trimmomatic).
Published tools not provided here.

STEP 1: Blobology
This is a slightly modified version of the Blobology pipeline, published by Kumar and colleagues (https://doi.org/10.3389/fgene.2013.00237), to accomodate the project and its computational requirements.
The changes are: an initial filtering of host reads (lines 48-72), use of the only-assembler SPAdes function, and setting k-mer length for the preliminary assembly to reduce RAM requirements; obtaining a plot of the contigs by GC content and length in additon to the plot by GC content and coverage; the selection of target contigs by taxonomy and/or length in addition to GC content and coverage; the detection of mitochondrial contigs; the refinement of the assembly through Bandage. (https://doi.org/10.1093/bioinformatics/btv383).
This step requires host reference genome(s) and mitochondrial reference genome(s) in two separate files.

Run 2.0_filt_p1.sh first. This requires also: the scripts 2.0_Rplot.R and gc_cov_annotate.pl; the tools SPAdes (https://doi.org/10.1089/cmb.2012.0021), bowtie2 (https://doi.org/10.1038/nmeth.1923), samtools (https://doi.org/10.1093/bioinformatics/btp352).

Analyse the plots and select target contigs in R (I provided Oerr_Rcomm_sel.txt and Opha_Rcommands_sel.txt, and the respective plots, in OerrOpha_plots_sels as an example).

Once that is done, run 2.1_reassemble.sh (modify it as requested). As mentioned in this script, open the assembly graph in Bandage and further select contigs to improve the assembly quality. Additionally, you can map the selected reads against this assembly and assemble the mapped reads.

STEP 2: completeness estimation.
Performed with miComplete v.1.1.1 (--hmms Bact105) (https://doi.org/10.1093/bioinformatics/btz664)

STEP 3: Annotation.
Rickettsiella genomes were annotated with Prokka. Genbank files were used as inputs for pseudogene prediction (step 4)
prokka [INPUT_FASTA] --outdir OUTPUT_ANNOTATION --locustag [ORGNAME] --compliant --cpus 12 --prefix [ORGNAME]

STEP 4: Pseudogene prediction.
This was performed with an ad-hoc reference database of Legionellales (GCF_003350455.1, GCF_001431295.2, GCF_001431315.2, NC_002971.4) and and E. coli genome (GCF_000005845.2). Ran as:
for i in gb_Francisella/*.gbk; do python3 pseudofinder-master/pseudofinder.py annotate -g $i -db Legionellales_ref.faa -op $i.pf; done
The predicted pseudogenes and intact genes were counted, reported in a table, and plotted using 4.1_PseudoPlots.R.

STEP 5: Metabolic annotation.
Intact genes and pseudogenes of each organism were annotated using BlastKoala v.3.0. Outputs were then processed as follows:
i. intact genes and pseudogenes outputs were put in two separate folders.
ii. in both directories, the script searchKnumbers.py and the list Knumb.lst were copied, and searchKnumbers.py was run. When run, this script requires manual input of Knumbers file name (Knumb.lst) and output file (intact.tsv for intact genes, pseudos.tsv for pseudogenes). This step creates, for both intact genes and pseudogenes, a summary table presenting KEGG IDs and presence/absence in each organism of the dataset (YES/NO).
iii. intact.tsv and pseudos.tsv were put in a different directory where Integrate_ynTables.py. This script integrates the results into integrated_table.tsv, so that a "YES" in intact.tsv is a "YES" in integrated_table.tsv, a "NO" in intact.tsv is replaced by a "NO *" when a "YES" is found in pseudos.tsv, and a "NO" is printed in integrated_table.tsv when "NO" is found in both intact.tsv and pseudos.tsv. This script is simply run as: python3 Integrate_ynTables.py.

STEP 6: Phylogenetic inferences.
Phylogenomics: see 0_commands_phylogenomics.txt.
16S rRNA-based phylogeny: see 0_commands_16S.txt. The obtained tree was opened in iTol to collapse tree branches not closely related to the target Rickettsiella strains, names were adjusted and font and font size were also modified. 
Thiamine phylogenies: see 0_comm_thiamine.txt.

STEP 7: Intersections of orthologs plots.
The plots were obtained with the R package UpSet (see 7_Commands_UpSet.R and 7_Commands_UpSet_PLOTALLINTERSECTIONS.R). The key components of these plots are:
i. Horizontal Bar Plot (Left Side):
	Each bar represents the total number of orthogroups present in each species.
ii. Vertical Bar Plot (Top):
	These bars represent the number of orthogroups that belong to specific intersections of species. The height of each bar indicates how many orthogroups are in that particular intersection (i.e., shared by those species).
	Each bar represents the number of orthogroups that are shared by the combination of species indicated by the intersection matrix below.
iii. Intersection Matrix (Bottom):
Each row represents a species, and each column represents a possible intersection of those species.
Filled circles indicate that the species in that row are part of the intersection shown in the corresponding column.
The lines connecting the filled circles indicate which species are included in each specific intersection.

STEP 8:
OrthoFinder was run on the translated sequences all genes, intact genes, and pseudogenes of organisms belonging to different nodes of the phylogenomics tree. The obtained Orthogroups.GeneCount.tsv outputs were then analysed and plotted in R. Please see the Venn branch for the commands.

STEP 9: A heatmap of specific metabolic pathways was created and plotted next to phylogenomics tree using the commands in the script 9_R_tree_htmap2.R (by Adil El-Filali).

The phylogenomics tree, the heatmap of step 9, and the Venn diagram of step 8 were merged into a single figure using Inkscape. Font and font size were also altered in Inkscape for clarity.

STEP 10: Cytoplasmic incompatibility analysis.
Please see the folder CI for details.


