library(VennDiagram)
library(tidyverse)
a=read.delim("Orthogroups.GeneCount.tsv")
CN15 <- subset(a, a$Rickettsiella_Ir_d6.gbk.pf_intact > 0 & a$Rickettsiella_Iric.gbk.pf_intact > 0 & a$Rmassiliensis_GCF_000257395.1.gbk.pf_intact > 0)
CN13 <- subset(a, a$Rickettsiella_Opha.gbk.pf_intact > 0 & a$Rviridis_GCF_003966755.1.gbk.pf_intact > 0 & a$RendoDgallinae_GCF_019285595.1.gbk.pf_intact > 0)
CN10 <- subset(a, a$Rgrylli_GCF_000168295.1.gbk.pf_intact > 0 & a$Risopodorum_GCF_001881495.1.gbk.pf_intact > 0 & a$Rickettsiella_Ir_d1.gbk.pf_intact > 0 & a$Rickettsiella_Oerr.gbk.pf_intact > 0)
CN15_l <- CN15$Orthogroup
CN10_l <- CN10$Orthogroup
CN13_l <- CN13$Orthogroup

orth <- list(CoreNode15 = CN15_l, CoreNode13 = CN13_l, CoreNode10 = CN10_l)
set.seed(1)
venn.diagram(orth, filename="CoreRickettsiellaIntact.tiff", height=2000, width=2000, cex=0.5, cat.cex=0.5, fill=c("#EFDD8D", "#247ba0", "#5C415D")
, col="white")
venn_list <- calculate.overlap(orth)
save_list_to_file <- function(list_name, list_data) {
  write.table(
    list_data,
    file = paste0(list_name, ".txt"),
    quote = FALSE,
    row.names = FALSE,
    col.names = FALSE
  )
}
for (name in names(venn_list)) {
  save_list_to_file(name, venn_list[[name]])
}

savehistory("Rcomm_CoreRickettsiella_Node8intact.R")
