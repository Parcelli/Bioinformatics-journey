# Fungi identification project
## Data
The data consists of 26 samples from Zanzibar
## Workflow
### Quality check
```
#runfastqc
module load fastqc
fastqc -o ../fastqc-results ./*.fastq.gz
cd ../fastqc-results

#run multiqc
multiqc ./
```
## Quality control
Trimmed using trimmomatic
```
for i in *_R1_001.fastq.gz;
do
    name=$(basename -s _R1_001.fastq.gz ${i})
    trimmomatic PE -threads 20 ${i} ${name}_R2_001.fastq.gz \
                ${name}.R1.fastq.gz ${name}.R1.untrim.fastq.gz \
                ${name}.R2.fastq.gz ${name}.R2.untrim.fastq.gz \
                LEADING:6 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:100 ILLUMINACLIP:NexteraPE-PE.fa:2:30:10
done
rm -r *untrim*
mv *R*.fastq.gz ../trimmed-reads

```
### Post fastqc
```
fastqc -o postfastqc *.fastq.gz
multiqc ./
```
## Importing data into qiime
```
mkdir qiime
cd qiime

pip install send2trash
module load qiime2

# Running automated python script 
python3 ./manifest.py --input_dir ../trimmed-reads
sort Manifest.csv >> sorted.csv
sed '$d' sorted.csv | sed -i '1s/^/sample-id,absolute-filepath,direction\n/' sorted.csv
sed '$d' sorted.csv >> ready.csv
rm Manifest.csv && rm sorted.csv
mv ready.csv Manifest.csv

#Import your data into Qiime2 Artifacts
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path Manifest.csv \
--output-path demux.qza \
--input-format PairedEndFastqManifestPhred33

```
## Training a Classifier
### SILVA Database
```
#download the silva database

wget https://data.qiime2.org/2021.4/common/silva-138-99-seqs.qza
wget https://data.qiime2.org/2021.4/common/silva-138-99-tax.qza

#train the feature classifier

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads silva-138-99-seqs.qza \
  --i-reference-taxonomy silva-138-99-tax.qza \
  --o-classifier classifier.qza
  ```
## Taxonomic classification
```
#taxonomic classification
qiime feature-classifier classify-sklearn \
--i-classifier ./classifier.qza \
--i-reads ./rep-seqs-dada2.qza \
--o-classification ./taxonomy.qza

#Generating taxonomy file
qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv

#creating taxonomy barplots
qiime taxa barplot \
--i-table dada2-table.qza \
--i-taxonomy taxonomy.qza \
--m-metadata-file zanzibar1.tsv \
--o-visualization taxa-bar-plots.qzv

# Filtering the unassigned to species level
qiime taxa filter-table \
  --i-table dada2-table.qza \
  --i-taxonomy taxonomy.qza \
  --p-include s_ \
  --o-filtered-table table-species-level.qza

qiime metadata tabulate \
--m-input-file table-species-level.qza \
--o-visualization taxonomy_species.qzv

qiime taxa barplot \
--i-table table-species-level.qza \
--i-taxonomy taxonomy.qza \
--m-metadata-file zanzibar1.tsv \
--o-visualization taxa-barplot-species.qzv

```

### UNITE Database
#Using a trained classifier
```
# taxonomic classification
qiime feature-classifier classify-sklearn \
--i-classifier ../feature-classifier/qime2/unite-ver8-99-classifier-04.02.2020.qza\
--i-reads ./rep-seqs-dada2.qza \
--o-classification ./taxonomy.qza

#Generating taxonomy file
qiime metadata tabulate \
--m-input-file taxonomy.qza \
--o-visualization taxonomy.qzv

#creating taxonomy barplots
qiime taxa barplot \
--i-table dada2-table.qza \
--i-taxonomy taxonomy.qza \
--m-metadata-file zanzibar1.tsv \
--o-visualization taxa-barplot.qzv

# Filtering the unassigned to species level
qiime taxa filter-table \
  --i-table dada2-table.qza \
  --i-taxonomy taxonomy.qza \
  --p-include s_ \
  --o-filtered-table table-species-level.qza

qiime metadata tabulate \
--m-input-file table-species-level.qza \
--o-visualization taxonomy_species.qzv

qiime taxa barplot \
--i-table table-species-level.qza \
--i-taxonomy taxonomy.qza \
--m-metadata-file zanzibar1.tsv \
--o-visualization taxa-barplot-species.qzv

```
#### Results
* Phyla present

**SILVA** 

![image](https://drive.google.com/uc?export=view&id=1eBiAmFAoNLRblnvAUocaW1mdIY2WLiFy)

**UNITE**

![image](https://drive.google.com/uc?export=view&id=1Xoe9CvQMoFyD76DKrIockvFTTllLFMgC)








## Denoising using Dada2
 
 Challenge | Solution
 --------- | --------
 basename command | *basename -s _R1_001.fastq.gz file-name*
 Trimmomatic jar file | provided path  */opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar*
 Adapter path | */opt/apps/trimmomatic/0.39/adapters/NexteraPE-PE.fa*
 Illumina clip | provide the argues NexteraPE-PE.fa:2:30:10
 Pip command | unload all modules ,then *pip install send2trash*
 
 
