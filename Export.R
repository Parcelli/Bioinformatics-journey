#! bin/bash
# 1 Export OTU table
#- table-no-mitochondria-no-chloroplast.qza replace with your file
# - phyloseq => replace with where you'd like to output directory
#mkdir phyloseq1

qiime tools export \
  --input-path  table-species-level.qza \
  --output-path phyloseq1

# OTU tables exports as feature-table.biom so convert to .tsv
# - Change -i and -o paths accordingly

biom convert \
-i phyloseq1/feature-table.biom \
-o phyloseq1/otu_table.tsv \
--to-tsv
  
cd phyloseq1
sed -i '1d' otu_table.tsv
sed -i 's/OTU ID/OTUID/' otu_table.tsv
cd ../


# 2 Export taxonomy table
qiime tools export \
--input-path taxonomy.qza \
--output-path phyloseq1
  
# Manually change "feature ID" to "OTUID"


  
# 4 Merge files
# Filtered sequences will make taxonomy and OTU tables have different lengths
