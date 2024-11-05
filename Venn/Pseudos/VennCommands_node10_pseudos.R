library(VennDiagram)
library(tidyverse)
a=read.delim("Orthogroups.GeneCount.tsv")
RG <- subset(a, a$Rgrylli_GCF_000168295.1>0)
RG_l <- RG$Orthogroup
RIrd1 <- subset(a, a$Rickettsiella_Ir_d1>0)
RIrd1_l <- RIrd1$Orthogroup
ROerr <- subset(a, a$Rickettsiella_Oerr>0)
ROerr_l <- ROerr$Orthogroup
Riso <- subset(a, a$Risopodorum_GCF_001881495.1>0)
Riso_l <- Riso$Orthogroup
orth <- list(Rgrylli = RG_l, Rickettsiella_Ird1 = RIrd1_l, Rickettsiella_Oerr = ROerr_l, Risopodorum = Riso_l)
set.seed(1)
venn.diagram(orth, filename="Comparison_Node10_pseudos.png", height=2000, width=2000, cex=0.5, cat.cex=0.5, fill=c("#ef476f","#ffd166", "#06d6a0", "#118ab2"), col="white")
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
savehistory("VennCommands_node10_pseudos.R")
