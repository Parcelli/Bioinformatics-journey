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
 ## Denoising using Dada2
 
 Challenge | Solution
 --------- | --------
 basename command | *basename -s _R1_001.fastq.gz file-name*
 Trimmomatic jar file | provided path  */opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar*
 Adapter path | */opt/apps/trimmomatic/0.39/adapters/NexteraPE-PE.fa*
 Illumina clip | provide the argues NexteraPE-PE.fa:2:30:10
 Pip command | unload all modules ,then *pip install send2trash*
 
 
