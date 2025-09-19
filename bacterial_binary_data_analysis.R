# Required packages
library(dplyr)
library(RColorBrewer)
library(cluster)
library(ggplot2)
library(ggtree)
library(ggtreeExtra)
library(pheatmap)
library(vegan)
library(tidyr)
library(ape)
library(viridis)
library(DescTools)

# Keep the samples' ids and phylogroups
id <- file$number
phylogroup <- file$phylogroup

# Remove the ids and phylogroups
data <- file[,c(-1, -2)]

# Change the data's values to numeric ones and save the rownames as ids
data <- data %>% mutate(across(everything(), as.numeric))
rownames(data) <- id

# Calculate the Jaccard distance since the data is binary
jaccard_dist <- vegdist(data, method = "jaccard")

# Draw the dendrogram
hc <- hclust(jaccard_dist, method = "average")
tree <- as.phylo(hc)


meta <- data.frame(label = rownames(data), phylogroup = phylogroup)

ring_data = cbind(label = rownames(data), data)
ring_data_long <- ring_data %>% pivot_longer(cols = -label, names_to = 'variable', values_to = 'value')

# Final tree
p <- ggtree(tree, layout = 'circular') %<+% meta +
  geom_tiplab(aes(color = phylogroup), size = 1.5, offset = 0.04, show.legend = FALSE) +
  geom_tippoint(aes(color = phylogroup), size = 0.6)+
  scale_color_brewer(palette = 'Dark2')+
  theme(legend.position = 'right')



# Final tree with the outside ring
pr <- p + 
  geom_fruit(data = ring_data_long, geom = geom_tile, mapping = aes(y = label, x = variable, fill = as.factor(value)),
             width = 0.005, offset = 0.15, axis.params = list(axis = "none"))+
  scale_fill_manual(values = c('#e6ff81', '#f755ed'))

# Draw Heatmap  
sum_table <- data %>% mutate(phylogroup = file$phylogroup) %>%
  group_by(phylogroup) %>%
  summarise(across(where(is.numeric), ~ mean(.x) * 100))
sum_phylo <- sum_table$phylogroup 
sum_table_without_phylo <- sum_table[, -1]
rownames(sum_table_without_phylo) <- sum_phylo
heatmap <- pheatmap(sum_table_without_phylo, color = rev(hcl.colors(100, "viridis")), cluster_cols = FALSE, cluster_rows = FALSE, display_numbers = F, fontsize = 8)


## Draw Bar Plot
resistance_freq <- colMeans(data) * 100
resistance_freq <- data.frame(resistance_freq)
resistance_freq$Antibiotics <- rownames(resistance_freq)
ggplot(resistance_freq, mapping = aes(x = Antibiotics, y = resistance_freq, fill = resistance_freq))+
  geom_bar(stat = 'identity', position = position_dodge(width = 1.5))+
  scale_fill_viridis(option = 'viridis', direction = -1)+
  theme_minimal(base_size = 15)+
  theme(axis.text.x = element_text(size = 15, angle  = 45, hjust = 1))


# Draw Co-occurrence of antibiotic resistance (Spearman)
## Removing the columns that are similar across all types and can show no correlation 
data_filtered <- data[,apply(data, 2, var) > 0]

co_matrix <- cor(data_filtered, method = 'spearman')
pheatmap(co_matrix, color = rev(hcl.colors(100, 'viridis')))



##  Draw Co-occurrence of antibiotic resistance (Phi for binary data)
phi_matrix <- matrix(NA, ncol = ncol(data_filtered), nrow = ncol(data_filtered))
colnames(phi_matrix) <- colnames(data_filtered)
rownames(phi_matrix) <- colnames(data_filtered)
for (i in 1:ncol(data_filtered)){
  for (j in 1: ncol(data_filtered)){
    phi_matrix[i, j] <- Phi(data_filtered[[i]], data_filtered[[j]])
  }
}

pheatmap(phi_matrix, color = rev(hcl.colors(100, 'viridis')))
