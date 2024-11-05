install.packages("tidyverse", dependencies = TRUE)

install.packages("VennDiagram", dependencies = TRUE)

library(VennDiagram)
library(tidyverse)
a=read.delim("Orthogroups.GeneCount.tsv")
RDG <- subset(a, a$RendoDgallinae_GCF_019285595.1>0)
RDG_l <- RDG$Orthogroup
ROpha <- subset(a, a$Rickettsiella_Opha>0)
ROpha_l <- ROpha$Orthogroup
Rvir <- subset(a, a$Rviridis_GCF_003966755.1>0)
Rvir_l <- Rvir$Orthogroup
orth <- list(Rickettsiella_Dgallinae = RDG_l, Rickettsiella_Opha = ROpha_l, Rviridis = Rvir_l)
venn.diagram(orth, filename="Comparison_Node13.png", height=2000, width=2000, cex=0.5, cat.cex=0.5, fill=c("#f15bb5","#9b5de5", "#80ed99"), col="white")
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
savehistory("Venn_Node13_all_commands.R")
