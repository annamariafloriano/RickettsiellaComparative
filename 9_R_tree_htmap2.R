### This script was made by Adil El-Filali, adil.el-filali@univ-lyon1.fr

tree.htmap <- function(newick_file,path_file,couleur=c("#ced4da", "#EAC435", "#80ed99")){

	library(ggplot2)
	library(ggtree)
	
	newick_tree <- read.tree(newick_file)
	pathway = read.table(path_file,sep="\t",h=T,row.names=1)
	
	pathway=t(pathway)
#	rownames(pathway)=unlist(lapply(strsplit(rownames(pathway),"_user"),"[",1))
#	colnames(pathway) = pathway[1,]
#	pathway= pathway[-1,]

	p= ggtree(newick_tree, mrsd="2008-01-01") + geom_treescale(x=2008, y=1, offset=4) + geom_tiplab(size=3)

	gh = gheatmap(p, pathway, offset=1, width=1.5, font.size=3, colnames_angle=-90)

#	gh + scale_fill_manual(labels=c("NO", "NO*", "YES"), values=couleur)
    	gh + scale_fill_manual(values=couleur)
}
  
 file_newick="Rickettsiella_tree.nwk"
 file_path="InterestingPaths_filled_un.tsv"
  
  pdf("R_InterestingPathways.pdf",12,20)
  tree.htmap(file_newick,file_path)
  dev.off()
  

