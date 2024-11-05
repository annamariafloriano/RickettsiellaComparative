# Load necessary packages
library(tidyr)
library(ggplot2)

# Read the data
df <- read.table("Counts.tsv", header = TRUE, sep = "\t")

# Transform data from wide to long format
df_long <- df %>%
  pivot_longer(cols = c("Intact_genes", "Pseudogenes"), names_to = "Gene_Type", values_to = "Count")

# Create the grouped barplot with vertical x-axis text
p <- ggplot(df_long, aes(x = Organism, y = Count, fill = Gene_Type)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  labs(title = "Counts of Intact Genes and Pseudogenes by Organism",
       x = "Organism",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  scale_fill_manual(values = c("Intact_genes" = "#390099", "Pseudogenes" = "#9e0059"))

# Print the plot
print(p)

# Save the plot as PDF
ggsave("Counts_plot.pdf", plot = p, width = 10, height = 6)

