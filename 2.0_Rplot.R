#!/bin/env Rscript


library(ggplot2);
library(reshape2);

tab=read.delim("blobplot.tab");

png(paste("GC_LogLen","png",sep="."),res=100);
g1<-ggplot(tab, aes(x=log10(tab$len), y=tab$gc, colour=tab$taxlevel_superkingdom))+geom_point(size=0.7)+labs(x="Log10Len",y="GC%");
g1;
dev.off();

tab1000=subset(tab, tab$len>=1000);


png(paste("LogCov_GC","png",sep="."),res=100);
g2<-ggplot(tab1000,aes(x=tab1000$gc, y=log10(tab1000$cov_contigs.fasta.bowtie2.bam), colour=tab1000$taxlevel_superkingdom))+geom_point(size=0.7)+labs(x="GC%", y="Log10Coverage");
g2;
dev.off();


