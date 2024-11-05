library(VennDiagram)
library(tidyverse)
a=read.delim("Orthogroups.GeneCount.tsv")
RIrd6 <- subset(a, a$Rickettsiella_Ir_d6>0)
RIrd6_l <- RIrd6$Orthogroup
RIric <- subset(a, a$Rickettsiella_Iric>0)
RIric_l <- RIric$Orthogroup
Rmas <- subset(a, a$Rmassiliensis_GCF_000257395.1>0)
Rmas_l <- Rmas$Orthogroup
orth <- list(Rickettsiella_Ird6 = RIrd6_l, Rickettsiella_Iric = RIric_l, Rmassiliensis = Rmas_l)
set.seed(1)
venn.diagram(orth, filename="Comparison_Node15_pseudos.png", height=2000, width=2000, cex=0.5, cat.cex=0.5, fill=c("#8cb369","#f4e285", "#f4a259"), col="white")
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

savehistory("VennCommands_Node15_pseudos.R")
