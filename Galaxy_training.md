# QUALITY CONTROL
Sequencing of RNA and DNA involves the determination of nucleotide sequence by a sequencer.For each fragment in the library a short sequence is generated also known as **reads**.No sequencing technology is perfect as all generate different types and amounts of errors.It is therefore important to assess the quality of the reads to avoid effect on downstream analysis.
## Assessing reads in Galaxy
* Upload data from 
```
Copy the link location(https://zenodo.org/record/61771/files/GSM461178_untreat_paired_subset_1.fastq)

Open the Galaxy Upload Manager (galaxy-upload on the top-right of the tool panel)

Select Paste/Fetch Data

Paste the link into the text field

Press Start

Close the window
```
* Inspect the fastq file

The fastq file usually have 4 lines for each read as follows;

Line | Description
---- | ----
1 | Begins with @ and gives the information about the run
2 | The actual nucleic sequence
3 | Begins with a +
4 | Consists of a string of characters which represent the quality scores of each base of the nucleic sequence

The string of characters represents quality scores encoded in the ASCII character table below;

![image](https://training.galaxyproject.org/topics/sequence-analysis/images/quality_score_encoding.png)

The first sequence in our file is;
image

### Questions

1. Which ASCII character corresponds to the worst Phred score for Illumina 1.8+? ( **!** )
  
2. What is the Phred quality score of the 3rd nucleotide of the 1st sequence? (**40**)

3. What is the accuracy of this 3rd nucleotide? (**99.99%**)
