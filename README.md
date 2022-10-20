

# # MegaSSR

MegaSSR is a robust online server that identifies Simple Sequence Repeats (SSR) and enables the design of SSR markers in high-throughput data. MegaSSR perfectly matches any target genome (including Plantae, Protozoa, Animalia, Chromista, Fungi, Archaea, and Bacteria). The pipeline is freely available at [https://bioinformatics.um6p.ma/MegaSSR](https://bioinformatics.um6p.ma/MegaSSR) and [github repository](https://github.com/MoradMMokhtar/MegaSSR). 

The computational pipeline consists of the SSR identification tool [MISA](https://academic.oup.com/bioinformatics/article/33/16/2583/3111841) and [Primer3](https://academic.oup.com/nar/article/40/15/e115/1223759) for design PCR primers . Other processes, such as SSR classification, annotation, and motif comparisons, were performed using custom scripts written in various programming languages such as [Perl](https://www.perl.org/), [Python](https://www.python.org/), and [shell script](https://www.shellscript.sh/).

MegaSSR running with two options:

> 1: Simple Sequence Repeat identification, classification, and SSR marker design.
> 
> 2: Simple Sequence Repeat identification, classification, gene-based annotation, motif comparison, and SSR marker design.
> 
## #The local standalone version of MegaSSR
MegaSSR has been tested on Ubuntu 18.04 and 20.04.

 1. Install
 2. Required data
 3. Usage
 4. Run Example
 5. Output files
 6. Output files example
#
### **Install**
The installation require conda. You can install all dependencies for running MegaSSR in a new conda environment using the MegaSSR.yml and plots.yml files. If you do not have conda, please follow [this tutorial](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html).

1- Download repository from github 
>`git clone https://github.com/MoradMMokhtar/MegaSSR.git` 

2- Go to the MegaSSR folder 
>`cd MegaSSR ` 

3- Create the MegaSSR environment with all dependencies   
>`conda env create -f MegaSSR.yml`
>`conda env create -f plots.yml`

### Required data
#
|Data|Option 1|Option 2|
|--|--|--|--|
| Genome sequence - Fasta file with chromosomes/scaffolds/contigs sequences | Required |Required  |
| Genome annotation - GFF/GFF3 file with genome annotations (gene,CDS,mRNA) | Not Required |Required  |
|  |  |  |  |

###  Usage
Go to the MegaSSR folder


    
    bash MegaSSR.sh -A [1 or 2] -F [Genome in FASTA Format] -G [GFF/GFF3 File]
    
    #Required arguments:
	-A		The analysis type [1 or 2] 
	1 (for Simple Sequence Repeat identification, classification, and SSR marker design 'This analysis needs FASTA file only') 
	2 (for Simple Sequence Repeat identification, classification, gene-based annotation, motif comparison, and SSR marker design 'This analysis needs FASTA and GFF files') 	       
	-F		Your path to the genome sequence (Fasta file). 
	-G		Your path to the genome annotation (GFF/GFF3 file). Required with argument -A 2 only.
	
    #Optional arguments:
	-P     Outfileprefix, default is results.
	-1     Mininum number of Mononucleotide motifs, default is 10
	-2     Mininum number of Dinucleotide motifs, default is 6
	-3     Mininum number of Trinucleotide motifs, default is 5
	-4     Mininum number of Tetranucleotide motifs, default is 4
	-5     Mininum number of Pentanucleotide motifs, default is 3
	-6     Mininum number of Hexanucleotide motifs, default is 3
	-C     Maximum difference between the two motifs by base pairs, default is 100
	-s     Mininum primer length, default is 18
	-S     Maxinum primer length, default is 22
	-O     Optimal primer length, default is 18, default is 20
	-R     PCR product size range, default is 100-500]
	-v     Print MegaSSR version and exit
	-h     Print this Help
    
    Default parameters:bash MegaSSR.sh -A 2 -F /path/to/genome_fasta_file  -G /path/to/gff_file -P results -1 20 -2 10 -3 9 -4 5 -5 4 -6 4 -C 100 -s 18 -O 20 -S 22 -R 100-500
 


### Run Example

    bash MegaSSR_For_Test.sh -A 2 -G NC_003070.9_Arabidopsis_thaliana.gff.zip -F NC_003070.9_Arabidopsis_thaliana.fna.zip -P test -1 20 -2 10 -3 9 -4 5 -5 4 -6 4 -C 100 -s 18 -O 20 -S 22 -R 100-500

### Output files
We have collected the main output files in the Results folder in the main output directory. The results are presented in the form of tables and images as follows:
#
| # |File name  |Option 1  |Option 2  |
|--|--|--|--|
|1  |Identified SSR motifs table.csv  |&#10003;  |&#10003;  |
|2  | The distribution of the different SSR classes.csv |&#10003;  |&#10003;  |
| 3 | Summary of identified SSR motifs.csv |&#10003;  |&#10003;  |
| 4 | Frequency of the identified SSR motifs.csv |&#10003;  |&#10003;  |
| 5 |Frequency of identified SSR motifs considering complementarity.csv  |&#10003;  |&#10003;  |
| 6 |Desinged genic SSR primer.csv  | &#88;  |&#10003;  |
| 7 | Genic SSR primer statistics.csv |&#88;   |&#10003;  |
| 8 | SSR primer statistics.csv |&#10003;   |&#88;   |
| 9 | Desinged SSR primer.csv |&#10003;   |&#88;   |
| 10 |Genic SSR repeats with annotations.csv  |&#88;   |&#10003;  |
| 11 | non-genic SSR repeats with annotations.csv |&#88;   |&#10003;  |
| 12 |Desinged non-genic SSR primers.csv  |&#88;   |&#10003;  |
| 13 |Statistics of non-genic SSR primers.csv  | &#88;  |&#10003;  |
| 14 | Motif sequences shared between genic and non-genic regions.csv |&#88;   |&#10003;  |
| 15 |Reprate sequences Unique to genic regions.csv  |&#88;   |&#10003;  |
| 16 | Reprate sequences Unique to non-genic regions.csv |&#88;   |&#10003;  |
| 17 |Common reprate between genic and non-genic regions.png  |&#88;   |&#10003;  |
| 18 | SSR distribution considering sequence complementarity.png |&#10003;  |&#10003;  |
| 19 | Unique repeats in the genic region.png |&#88;   |&#10003;  |
| 20 |Unique repeats of the non-genic region.png  |&#88;   |&#10003;  |
| 21 | Distribution of the different SSR classes.png |&#10003;  |&#10003;  |
| 22 | Frequency of the identified SSR motifs.png |&#10003;  |&#10003;  |

 #
 ### Output files example (images)
 
 - Distribution of the different SSR classes
 ![Distribution of the different SSR classes](https://bioinformatics.um6p.ma/MegaSSR/images/Distribution_of_various_SSR_classes.png)
 - SSR distribution considering sequence complementarity
![SSR distribution considering sequence complementarity](https://bioinformatics.um6p.ma/MegaSSR/images/SSR_distribution_considering_sequence_complementary.png)
 - Frequency of the identified SSR motifs
![Frequency of the identified SSR motifs](https://bioinformatics.um6p.ma/MegaSSR/images/Frequency_of_identified_SSR_motifs.png)
 - Common reprate between genic and non-genic regions
![Common reprate between genic and non-genic regions](https://bioinformatics.um6p.ma/MegaSSR/images/Shared_reprats_between_genic_and_non-genic_regions.png)
 - Unique repeats in the genic region
![Unique repeats in the genic region](https://bioinformatics.um6p.ma/MegaSSR/images/Unique_repeats_of_the_genic_region.png)
 - Unique repeats of the non-genic region
![Unique repeats of the non-genic region](https://bioinformatics.um6p.ma/MegaSSR/images/Unique_repeats_of_the_non-genic_region.png)
#
### For more information and help
To report bugs and give us suggestions, you can open an [issue](https://github.com/MoradMMokhtar/MegaSSR) on the github repository. Feel free also to contact us by e-mail ([morad.mokhtar@um6p.ma](morad.mokhtar@um6p.ma)); ([achraf.elallali@um6p.ma](achraf.elallali@um6p.ma)).
