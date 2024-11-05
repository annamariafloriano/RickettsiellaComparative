# Load necessary packages
library(UpSetR)
library(dplyr)

# Load the data
orthogroups <- read.table("Orthogroups.GeneCount.tsv", header = TRUE, sep = "\t", check.names = FALSE)

# Remove the 'Total' column if it exists
if ("Total" %in% colnames(orthogroups)) {
    orthogroups <- orthogroups[ , !(colnames(orthogroups) %in% "Total")]
}

# Extract Orthogroup IDs
orthogroup_ids <- orthogroups$Orthogroup

# Convert the gene counts to presence/absence (binary) data
binary_data <- orthogroups
binary_data[binary_data > 0] <- 1
binary_data <- binary_data[ , -1] # Remove the original Orthogroup column

# Specify the desired order of the organisms
SpOrder <- c("Baphidicola_GCF_003099975.1.ffn.ren","Bcookevillensis_GCF_001431315.2.ffn.ren","Baquae_GCF_001431295.2.ffn.ren","CeAS_UFV_CP033868.ffn.ren","Cburnetii_RSA493_NC_002971.4.ffn.ren","Coxiella_Omar.ffn.ren","Alusitana_GCF_003350455.1.ffn.ren","Rickettsiella_Oerr.ffn.ren","Rickettsiella_Ir_d1.ffn.ren","Risopodorum_GCF_001881495.1.ffn.ren","Rgrylli_GCF_000168295.1.ffn.ren","RendoDgallinae_GCF_019285595.1.ffn.ren","Rviridis_GCF_003966755.1.ffn.ren","Rickettsiella_Opha.ffn.ren","Rmassiliensis_GCF_000257395.1.ffn.ren","Rickettsiella_Ir_d6.ffn.ren","Rickettsiella_Iric.ffn.ren","Lpne_GCF_001753085.1.ffn.ren")

# Ensure the column order of the binary data matches the specified order
binary_data <- binary_data[, SpOrder, drop = FALSE]

# Add back the Orthogroup IDs for extraction purposes
binary_data <- cbind(Orthogroup = orthogroup_ids, binary_data)

# Convert to matrix to ensure correct data type for UpSetR
binary_data_matrix <- as.matrix(binary_data[ , -1])
row.names(binary_data_matrix) <- binary_data$Orthogroup

# Generate and save the UpSet plot with specified order
pdf("FinalUpSetPlot.pdf", width = 25, height = 15)
upset(as.data.frame(binary_data_matrix), 
      sets = SpOrder,
      keep.order = TRUE, 
      order.by = "freq", 
      nintersects = 60,
      number.angles = 30, 
      point.size = 3.5, 
      line.size = 2, 
      main.bar.color = "black", 
      sets.bar.color = "black", 
      text.scale = c(2, 1.5, 1.5, 1.5, 1.5, 1.5),
      mainbar.y.label = "Orthogroup Intersections",
      sets.x.label = "Orthogroups per species")
dev.off()

# Function to identify shared orthogroups
get_shared_orthogroups <- function(data, species_subset = NULL) {
  if (is.null(species_subset)) {
      # If no subset is specified, find orthogroups shared across all species
      shared <- data[rowSums(data[, -1]) == (ncol(data) - 1), "Orthogroup"]
  } else {
      # Find orthogroups shared among the specified subset of species
      shared <- data[rowSums(data[, species_subset]) == length(species_subset), "Orthogroup"]
  }
  return(shared)
}

# Function to identify species-specific orthogroups
get_species_specific_orthogroups <- function(data, species) {
  specific <- data[data[, species] == 1 & rowSums(data[, -1]) == 1, "Orthogroup"]
  return(specific)
}

# Identify orthogroups shared by all species
shared_by_all <- get_shared_orthogroups(binary_data)

# Identify species-specific orthogroups for each species
species_specific <- lapply(colnames(binary_data)[-1], function(species) {
  get_species_specific_orthogroups(binary_data, species)
})
names(species_specific) <- colnames(binary_data)[-1]

# Save the shared orthogroups to a file
write.table(shared_by_all, "shared_by_all_orthogroups.txt", row.names = FALSE, col.names = FALSE, quote = FALSE)

# Save species-specific orthogroups to separate files
for (species in names(species_specific)) {
  write.table(species_specific[[species]], paste0("species_specific_", species, ".txt"), row.names = FALSE, col.names = FALSE, quote = FALSE)
}

