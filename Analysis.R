 Setup environment
library(phyloseq)
library(ggplot2)
library(ape)

# Read in OTU table
otu_table_in <- read.csv("otu_table.tsv", sep = "\t", row.names = 1)
otu_table_in <- as.data.frame(t(otu_table_in))
otu_table_in <- as.matrix(otu_table_in)

# Read in taxonomy
# Separated by kingdom, phylum, class, order, family, genus, species
taxonomy <- read.csv("taxonomy.tsv", sep = "\t", row.names = 1)
taxonomy <- as.matrix(taxonomy)

# Read in metadata
metadata <- read.table("/data/asatsa/qime2/try2/phyloseq/beemetadata.txt", row.names = 1, header = TRUE)


# Import all as phyloseq objects
OTU <- otu_table(otu_table_in, taxa_are_rows = TRUE)
TAX <- tax_table(taxonomy)
META <- sample_data(metadata)

# Sanity checks for consistent OTU names
taxa_names(TAX)
taxa_names(OTU)

# Same sample names
sample_names(OTU)
sample_names(META)

# Finally merge!
ps <- phyloseq(OTU, TAX, META)
ps



library(vegan)
library(ggplot2)
library(dplyr)
library(scales)
library(grid)
library(reshape2)
library(phyloseq)

library('phyloseq')
#renaming with ASV instead of a Dna string
sequences <- Biostrings::DNAStringSet(taxa_names(ps))
names(sequences) <- taxa_names(ps)
phyloseq_object <- merge_phyloseq(ps, sequences)
phyloseq_object
#paste a unique identifier
taxa_names(phyloseq_object) <- paste0("ASV", seq(ntaxa(phyloseq_object)))

#save phyloseq object
saveRDS(phyloseq_object,"phyloseq_object.rds")

#visualising alpha diversity

diversitybycountry <-plot_richness(ps, x="bee", measures=c("Shannon", "Simpson"), color="Country") + theme_bw()
saveRDS(diversitybycountry,"diversitybycountry.png")
diversitybycountry
#Alpha diversity statistics

R <- estimate_richness(ps,split = TRUE,measures = c("Observed","Shannon"))
R

R1 <- estimate_richness(ps,split = TRUE,measures = c("Observed","simpson"))
R1

#Plotting alpha diversity

s <- plot_richness(ps, x="bee", measures=c("Observed", "Shannon")) + geom_boxplot()
saveRDS(s,"shanon_plot.jpeg")
s
#beta diversity
#PCoA plot
ps_pcoa <- ordinate(
  physeq = ps,
  method = "PCoA",
  distance = "bray")
ps_pcoa
PCoA <- plot_ordination(physeq=ps,ordination = ps_pcoa,color = "bee",shape = "Country",title = "PCoA of Fungalcommunities")+ geom_point(aes(color = bee), alpha = 0.7, size = 4)+ geom_point(colour = "grey90",size = 1.5) 
  
saveRDS(PCoA,"ordinations.jpeg")
PCoA
