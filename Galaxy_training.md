# QUALITY CONTROL
Sequencing of RNA and DNA involves the determination of nucleotide sequence by a sequencer.For each fragment in the library a short sequence is generated also known as **reads**.No sequencing technology is perfect as all generate different types and amounts of errors.It is therefore important to assess the quality of the reads to avoid effect on downstream analysis.
## Inspecting reads in Galaxy
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

![Fastq](https://drive.google.com/uc?export=view&id=1DlEwlwcGEIH1ASliUfvxwjswYi6VtuwL) 

The fastq file usually has 4 lines for each read as follows;

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

## Assessing quality using **fastQC**

A html report is generated after running FastQC.The report consists of a modular set of analysis that gives a quick view of the overall quality of the reads.

* Per Base sequence quality

![image](https://drive.google.com/uc?export=view&id=1Ti-wMfhu-zsWSyoIyozQFZCDaL9SDcDr) 

On the y axis is the phred quality score which on the background is divided to very good quality scores(green),scores of reasonable quality(orange) and reads of poor quality(red). 

On the x- axis,are the base position in the read.For each position, a boxplot is drawn with:
 
 * the median value, represented by the central red line
 * the inter-quartile range (25-75%), represented by the yellow box
 * the 10% and 90% values in the upper and lower whiskers
 * the mean quality, represented by the blue line

The quality of reads in most platforms tends to drop towards the end due to **signal decay** or **phasing**.
 * Signal decay
 
The flourescent signal intensity decays with each cycle of sequencing process.Therefore,the proportion of the signal emitted continues to decrease with each cycle yielding to a decrease of quality scores at the 3' end. 
* Phasing
 
The signal starts to blur with increase of number of cycles because the cluster looses synchronicity as the cycle progress.Some strands get random failures of nucleotide to incorporate due to ;
 a) Incomplete removal of 3' terminators and fluorophores
 b) Incorporation of nucleotides without effective 3' terminators
 
 ## Filter and trim
 The quality of the reads dropped towards the end of the sequence.
 

 

