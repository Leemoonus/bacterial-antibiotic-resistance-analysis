# Bacterial Antibiotic Resistance Analysis
This project explores patterns of antibiotic resistance across bacterial strains using binary resistance data. The goal is to visualize relationships among strains, analyze co-occurrence of resistances, and demonstrate computational data analysis skills in R.

---
## 🧫 Data Features
Binary presence/absence of resistance to multiple antibiotics for a set of bacterial isolates.
Note: The original dataset is not publicly shared due to privacy; example or simulated data can be used to reproduce the analysis.

---
## ♟ Methods

- Distance calculation: Jaccard distance for clustering strains based on binary resistance profiles.

- Clustering: Hierarchical clustering (average linkage) visualized as a circular dendrogram.
---
## 📊 Visualization:

- Circular dendrogram showing phylogroups of strains.

- First heatmap showing average resistance per phylogroup.

- Co-occurrence heatmaps using Spearman correlation and Phi coefficient for binary correlations.

- Additional analysis: Bar plots showing frequency of resistance per antibiotic.

---
## 🔧 Usage

Place your dataset (binary resistance matrix) in the working directory.

Adjust the file path in the code:
```R

file <- read.csv("your_data.csv")
```
---
## 📝Notes

The Jaccard distance was chosen because it is suitable for binary presence/absence data, focusing on shared resistance rather than shared susceptibility.

The Phi coefficient was used for co-occurrence analysis to measure associations between pairs of antibiotics.

---
## 🧰 Packages Used
```R
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
```
---
## 📝 Example Data
The dataset included in this repository is a synthetic example file created for demonstration purposes only. It mimics the structure of the original dataset used in the analysis, but contains randomly generated values. This allows users to run the code and reproduce the workflow without access to the real data (which cannot be shared due to confidentiality and publication restrictions).
