#!/bin/bash
#####################################################################################################
# Created by: Morad M. Mokhtar                                                                      #
# Emails: morad.mokhtar@ageri.sci.eg or morad.mokhtar@um6p.ma or morad.ageri.e@gmail.com            #
# This script is not intended for commercial use   
# Citation: https://doi.org/10.3389/fpls.2023.1219055                                               #
#####################################################################################################

if [ $# -eq 0 ]
   then
      echo "Parameters -A and -F is required, use [bash MegaSSR.sh -help] for more detalis"
      exit
fi
userpath=$(pwd)
Script=$userpath/bin/Script
chmod 775 $Script/usearch11.0.667_i86linux32 #Give execulting permissions for LTRretriever
test=$(pwd)/Data_For_Test
eval "$(conda shell.bash hook)"
############################################################
# Set variables                                            #
############################################################
##{
       Analysistype=2
       Fasta=""
       Gff=""
       organis_name=results
       mono=10
       di=6
       tri=5
       tetra=4
       penta=3
       hexa=3
       compound=100
       Min=18
       opt=20
       max=22
       range=250-500
       threads=4
       alleles=no
       max_allele_length=1000
       primer_image=50
       genic=gene
##}
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "MegaSSR is a pipeline designed for high-throughput Simple Sequence Repeat (SSR) identification, classification, gene-based annotation, motif comparison, and SSR marker design for any target genome (including Plantae, Protozoa, Animalia, Chromista, Fungi, Archaea, and Bacteria)."
   echo
   echo "     MegaSSR v2.1.0"
   echo
   echo "     Options:"
   echo "     -h     Print this Help."
   echo "     -A     The analysis type [1 or 2] 1 (for Simple Sequence Repeat identification, classification, and SSR marker design 'This analysis needs FASTA file only') 2 (for Simple Sequence Repeat identification, classification, gene-based annotation, motif comparison, and SSR marker design 'This analysis needs FASTA and GFF files') , default is 2"
   echo "     -F     Your path to Fasta file."
   echo "     -G     Your path to GFF file."
   echo "     -g     Classify SSR as genic based on the GFF file with one of the following [gene or mRNA or CDS], default is gene."
   echo "     -P     Outfileprefix, default is results."
   echo "     -1     Mininum number of Mononucleotide motifs, default is 10"
   echo "     -2     Mininum number of Dinucleotide motifs, default is 6"
   echo "     -3     Mininum number of Trinucleotide motifs, default is 5"
   echo "     -4     Mininum number of Tetranucleotide motifs, default is 4"
   echo "     -5     Mininum number of Pentanucleotide motifs, default is 3"
   echo "     -6     Mininum number of Hexanucleotide motifs, default is 3"
   echo "     -C     Maximum difference between the two motifs by base pairs, default is 100"
   echo "     -s     Mininum primer length, default is 18"
   echo "     -S     Maxinum primer length, default is 22"
   echo "     -O     Optimal primer length, default is 18, default is 20]."
   echo "     -R     PCR product size range, default is 100-500]."
   echo "     -v     Print MegaSSR version and exit."
   echo "     -t     Indicate how many CPU/threads you want to run MegaSSR, default is 4."
   echo "     -B     Calculate the number of alleles for each SSR primer and plot the migration patterns of the DNA bands [yes|no], default is no"   
   echo "     -L     The maximum length by base pair for allele search, default value is 1000"   
   echo "     -I     The maximum number of primers in each image. Note that only primers with more than one band are drawn. The default value is 50"
   echo
   echo "Default parameters:bash MegaSSR.sh -A $Analysistype -F Your_path_to_FASTA_file -G Your_path_to_GFF_file -P $organis_name -1 $mono -2 $di -3 $tri -4 $tetra -5 $penta -6 $hexa -C $compound -s $Min -O $opt -S $max -R $range -t $threads -B $alleles -L $max_allele_length -I $primer_image"
   exit
}
version()
{
   echo "MegaSSR v2.1.0"
   echo
   exit
}
       ############################################################
       # Process the input options.                               #
       ############################################################
       check=0
       while getopts h:A:F:G:g:P:1:2:3:4:5:6:C:s:S:O:R:v:t:B:L:I: options
       do
              case $options in
              h) Help;;
              v) version;;
              A) Analysistype=$OPTARG;((check=check+1));;
              F) Fasta=$OPTARG;((check=check+1));;
              G) Gff=$OPTARG;;
              g) genic=$OPTARG;;
              P) organis_name=$OPTARG;;
              1) mono=$OPTARG;;
              2) di=$OPTARG;;
              3) tri=$OPTARG;;
              4) tetra=$OPTARG;;
              5) penta=$OPTARG;;
              6) hexa=$OPTARG;;
              C) compound=$OPTARG;;
              s) Min=$OPTARG;;
              S) max=$OPTARG;;
              O) opt=$OPTARG;;
              R) range=$OPTARG;;
              t) threads=$OPTARG;;
              B) alleles=$OPTARG;;
              L) max_allele_length=$OPTARG;;
              I) primer_image=$OPTARG;;
              *) echo "Error: Invalid option" ;;
              esac
       done

       ###############################################################
       #### MegaSSR process the start.                               #
       ###############################################################
       sequence_acc=$organis_name
       outdir= mkdir -p $userpath/Results/$organis_name
       outdir=$userpath/Results/$organis_name
       Fasta=$test/$Fasta
       Gff=$test/$Gff
       conda activate MegaSSR
       now="$(date)" 
       echo
       printf "\t#############################################\n\t##############  MegaSSR v2.1.0  ##############\n\t#############################################\n\n\tContributors: Morad M Mokhtar, Alsamman M. Alsamman, Achraf El Allali\n\n"
       printf "\t$now \t Start time %s\n"  ### print current date
       echo
       printf "\tParameters:bash MegaSSR.sh -A $Analysistype -F $Fasta -G $Gff -g $genic -P $organis_name -1 $mono -2 $di -3 $tri -4 $tetra -5 $penta -6 $hexa -C $compound -s $Min -O $opt -S $max -R $range -t $threads -B $alleles -L $max_allele_length -I $primer_image\n\n"

       if [ $check -ne 2 ]
              then
              printf "\tParameters -A and -F is required, use [bash MegaSSR.sh -help] for more detalis\n"
              exit
       fi

       if [[ $Fasta =~ \.gz$ ]]; then
              cd $outdir
              echo
              printf "\tCheck the FASTA File format.\n"
              gunzip -c "$Fasta" >$outdir/"$sequence_acc"_genomic.fa           
              perl $Script/checkfasta.pl $outdir/"$sequence_acc"_genomic.fa ### Check the FASTA File format
              elif [[ $Fasta =~ \.zip$ ]]; then
              echo
              printf "\tCheck the FASTA File format.\n"
              gunzip -c "$Fasta" >$outdir/"$sequence_acc"_genomic.fa
              perl $Script/checkfasta.pl $outdir/"$sequence_acc"_genomic.fa ### Check the FASTA File format
              elif ([ $(stat -c%s "$Fasta") -gt 50 ]); then
              printf "\tCheck the FASTA File format.\n"
              perl $Script/checkfasta.pl $Fasta ### Check the FASTA File format
              cp $Fasta $outdir/"$sequence_acc"_genomic.fa #### copy fasta file tRNA files
              else
              printf "\n\tCheck the FASTA File format.\n"
              printf "\n\tPlease use -F to provide a valid FASTA file [-F FASTA_file_path].\n"
              exit
       fi

       if ([ $Analysistype -eq 2 ] && [[ $Gff == "" ]]); then
              printf "\n\tPlease use -G to provide a valid GFF file [-G GFF_file_path].\n"
              exit
       fi
       if ([[ $Analysistype -eq 2 ]] && [ $(stat -c%s "$Gff") -lt 500 ]); then
              printf "\n\tPlease use -G to provide a valid GFF file [-G GFF_file_path].\n"
              exit
       fi

       if ([ $Analysistype -eq 2 ] && [[ $Gff =~ \.gz$ ]]); ### mode 3
              then
              gunzip -c "$Gff" >$outdir/$sequence_acc.gff
              elif ([ $Analysistype -eq 2 ] && [[ $Gff =~ \.zip$ ]]); then
              gunzip -c "$Gff" >$outdir/$sequence_acc.gff
              elif ([[ $Analysistype -eq 2 ]] && [ $(stat -c%s "$Gff") -gt 500 ]); then
              cp $Gff $outdir/$sequence_acc.gff #### copy gff file
       fi
       ###############################################################
       FASTA= mkdir -p $outdir/FASTA
       FASTA=$outdir/FASTA
       intermediate_File_step_1= mkdir -p $outdir/intermediate_Files_step_1
       intermediate_File_step_1=$outdir/intermediate_Files_step_1
       sql= mkdir -p $outdir/"$organis_name"-MegaSSR_Results
       sql=$outdir/"$organis_name"-MegaSSR_Results
       ###############################################################
       plotread= mkdir -p $outdir/plot_read
       plotread=$outdir/plot_read
       plots= mkdir -p $outdir/plots
       plots=$outdir/plots
       ###############################################################
	fordownload= mkdir -p $outdir/$organis_name
       fordownload=$outdir/$organis_name
       primersearch= mkdir -p $outdir/primersearch
       primersearch=$outdir/primersearch
       primersearchresults= mkdir -p $outdir/primersearchresults
       primersearchresults=$outdir/primersearchresults
       designprimer= mkdir -p $outdir/designprimer
       designprimer=$outdir/designprimer
       designprimerresults= mkdir -p $outdir/designprimerresults
       designprimerresults=$outdir/designprimerresults
       gdesignprimer= mkdir -p $outdir/gdesignprimer
       gdesignprimer=$outdir/gdesignprimer
       gdesignprimerresults= mkdir -p $outdir/gdesignprimerresults
       gdesignprimerresults=$outdir/gdesignprimerresults
       USERCH= mkdir -p $outdir/USERCH
       USERCH=$outdir/USERCH

       ###############################################################
       python3 $Script/changeini_.py $mono  $di $tri $tetra $penta $hexa $compound $outdir
       python3 $Script/changeperl_.py $range $Min  $opt  $max $outdir
       python3 $Script/changeperl_geneic.py $range $Min  $opt  $max $outdir
       cd $FASTA || exit
       sed -i 's/ .*//' $outdir/"$sequence_acc"_genomic.fa
       # Split the files using csplit
       csplit -s -z "$outdir/"$sequence_acc"_genomic.fa" '/>/' '{*}'
       # Function to replace special characters (including colons) with hyphens (-)
       replace_special_chars() {
       local str="$1"
       # Replace special characters (including colons) with hyphen
       echo "${str//[^[:alnum:]_-:]/-}"
       }
       # Iterate through the split files and rename them using the mv command
       for i in xx* ; do
       # Extract the name for the new file (excluding special characters)
       n=$(sed 's/>// ; s/ .*// ; 1q' "$i")
       # Call the function to replace special characters (including colons) with hyphens (-) for the main part of the filename
       new_name=$(replace_special_chars "$n")
       # Replace all colons with hyphens in the main part of the filename
       main_part=$(echo "$n" | sed 's/:/-/g' | sed 's/|/-/g')
       # Combine the main part and file extension with a period
       new_name="${main_part}"
       # Use the mv command to rename the file
       mv "$i" "${new_name}.fa"
       done

       if [ $Analysistype -eq 1 ] # #####  General-SSR #########
              then
              ##{ Identifying SSR MISA
              now2="$(date)"
              printf "\n\n\t$now2 \tSimple Sequence Repeat identification started %s\n\n"
              # SSR mining by use MISA (genome fasta)
              python3 $Script/MISA_threads.py $FASTA $threads $Script/misa.pl $outdir 2>/dev/null
              # move MISA file result to intermediate_File
              cp $FASTA/all_results.misa $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa # move MISA file result to intermediate_File
              awk -F'\t' -v org=$organis_name '{ print 'org'"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7 }'  $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa > $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7 }'  $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa > $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp1\t/\tMono\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $sql/$organis_name.genomic.fa.misa.txt

              now3="$(date)"
              printf "\n\n\t$now3 \tIdentifying SSR Done %s\n\n"
              #########################################################
              awk -F'\t'  '{ print "\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8 }'  $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt > $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp1\t/\tMono\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt

              ######################## statistics ############################          
              now4="$(date)"
              printf "\n\n\t$now4 \tPreparing statistics files %s\n\n"

              for i in $FASTA/*.fa.statistics
              do
                     name=$(basename $i ".fa.statistics")
                     grep -f $Script/patterns $FASTA/$name.fa.statistics >$FASTA/$name.RESULTS_OF_MICROSATELLITE_SEARCH.txt
                     grep -Pzo "(?s)((?<=Unit size\tNumber of SSRs\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $FASTA/$name.fa.statistics  >$FASTA/$name.Distribution_to_different_repeat_type_classes.txt1
                     sed '$d'  $FASTA/$name.Distribution_to_different_repeat_type_classes.txt1 >$FASTA/$name.Distribution_to_different_repeat_type_classes.txt
                     awk 'NF > 0' $FASTA/$name.Distribution_to_different_repeat_type_classes.txt > $FASTA/$name.Distribution_to_different_repeat_type_classes.txt2

                     sed 's/1\t/Mono\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.txt2 >$FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/2\t/Di\t/g'  $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/3\t/Tri\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/4\t/Tetra\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/5\t/Penta\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/6\t/Hexa\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt

                     grep -Pzo "(?s)((?<=Frequency of identified SSR motifs\n)(.*?)(?=(\nFrequency of classified repeat types \(considering sequence complementary\)|\Z)))" $FASTA/$name.fa.statistics >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     tail -n +3 $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt> $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt2
                     tail -n +4 $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt2 >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt3
                     sed -i '$d' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt3
                     grep -Pzo "(?s)((?<=Frequency of classified repeat types \(considering sequence complementary\)\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $FASTA/$name.fa.statistics >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt
                     tail -n +3 $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt> $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
                     awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt2
                     tail -n +4 $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt2 > $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
                     awk '{print $0"\t"length($3)}' $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3 >$FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt4
                     sed '1d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt >$FASTA/"$name"_Frequency_SSR_motifs.complementary.txt  
                     sed -i -E 's/\:\s+/\t/g' $FASTA/$name.RESULTS_OF_MICROSATELLITE_SEARCH.txt          
              done

              python3 $Script/ssr_merge.py $FASTA  _Frequency_SSR_motifs.complementary.txt
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd_Frequency_SSR_motifs.complementary.txt >  $sql/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt

              python3 $Script/ssr_merge.py $FASTA  _Frequency_of_identified_SSR_motifs.txt3
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd_Frequency_of_identified_SSR_motifs.txt3 > $sql/$organis_name.Frequency_of_identified_SSR_motifs.txt

              python3 $Script/ssr_merge.py $FASTA  .Distribution_to_different_repeat_type_classes.stat.txt
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd.Distribution_to_different_repeat_type_classes.stat.txt > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt2
              python3 $Script/ssr_merge.py $FASTA  .RESULTS_OF_MICROSATELLITE_SEARCH.txt
              cp $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt

              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt > $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt

              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt2 > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table3""\t"'org'"\t"$1"\t"$NF }' $sql/$organis_name.Frequency_of_identified_SSR_motifs.txt >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4
              awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $sql/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt4
              sed -i '1d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4
              sed -i '1d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt4
              sed -i '1d' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt

              cat $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt
              grep "Total number of identified SSRs" $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt >$FASTA/For_SSR_Stat  ##Total number of identified SSRs
              awk -F "\t" '{print $2}' $FASTA/For_SSR_Stat >$FASTA/For_SSR_Stat.status ##Total number of identified SSRs
              numberofssr=$(cat $FASTA/For_SSR_Stat.status)  ##Total number of identified SSRs

              if [ $numberofssr -eq 0 ] ### Total number of identified SSRs
                     then  

                     printf "\n\n\tNo SSR was found, MegaSSR is stopped\n\n"
                     else
       
              now6="$(date)"
              printf "\n\n\t$now6 \tDesign SSR primers started%s\n\n"
              ############################ SSR Primers##############################              
              cd $designprimer
              split -d -l 500 $sql/$organis_name.Accept_Intergenic_SSR.txt 

                     for i in $FASTA/*.fa
                     do
                     name=$(basename $i ".fa")
                            python3 $Script/designprimer_threads.py $i  $designprimer $designprimerresults $threads $Script/extractseq-id-start-end-intergenic.pl $outdir/modified_p3_in.pl 
                     done
              cat $designprimerresults/*.fa >$sql/$organis_name."SSR flanking sequence.fa"
	      
                     ######## for SSR.non-redundant.fa #################
                     cp $sql/$organis_name."SSR flanking sequence.fa" $USERCH/SSR_with_flanking_regions.fa
                     $Script/usearch11.0.667_i86linux32  -sortbylength $USERCH/SSR_with_flanking_regions.fa --fastaout $USERCH/SSR_with_flanking_regions_sorted.fa --log $USERCH/usearch.log >>$USERCH/screen
                     $Script/usearch11.0.667_i86linux32  -cluster_fast  $USERCH/SSR_with_flanking_regions_sorted.fa --id 0.9 --centroids $USERCH/my_centroids.fa --uc $USERCH/result.uc -consout $USERCH/SSR.non-redundant.fa -msaout $USERCH/aligned.fasta --log $USERCH/usearch2.log >>$USERCH/screen
                     # rm $USERCH/aligned.* 
                     sed '2d' $USERCH/usearch2.log >$outdir/"$organis_name"-MegaSSR_Results/SSR.non-redundant.log
                     sed -i '3d' $outdir/"$organis_name"-MegaSSR_Results/SSR.non-redundant.log
                     sed -i '11d' $outdir/"$organis_name"-MegaSSR_Results/SSR.non-redundant.log
                     cp $USERCH/SSR.non-redundant.fa $outdir/"$organis_name"-MegaSSR_Results/"Non-redundant SSR library.fasta"
                     now100="$(date)"
                     printf "\n\n\t$now101 \tNon-redundant SSR library done%s\n\n"

              ############################primer-design##############################
              python3 $Script/designprimer3_threads.py $designprimer $designprimerresults $threads $Script/extractseq-id-start-end-intergenic.pl $outdir/modified_p3_in.pl $organis_name $Script/modified_p3_out-intergenic.pl $Script/print-primers-line-nongenicCCC.pl $intermediate_File_step_1

              awk '!seen[$9]++' $intermediate_File_step_1/$organis_name.interGenic-primers3.txt > $intermediate_File_step_1/$organis_name.interGenic-primers3_2.txt
              awk '!seen[$13]++' $intermediate_File_step_1/$organis_name.interGenic-primers3_2.txt > $sql/$organis_name.interGenic-primers.txt
              wc -l $sql/$organis_name.interGenic-primers.txt >$intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat
              sed -i 's/\s/\t/g' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat
              awk -F "\t" -v txt="No. of desinged SSR primers" -v org=$organis_name '{print "\t"'org'"\t"'txt'"\t"$1}' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat >$sql/$organis_name.intergenic.primers.stat.txt
              
              now7="$(date)"
              printf "\n\n\t$now7 \tDesign SSR primers Done%s\n\n"
              #########################################################
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\n/' $sql/$organis_name.genomic.fa.misa.txt
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\n/' $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i '1s/^/\tProcess Id\tRepeat Type\tTotal No. of present\n/' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\t\n/' $sql/$organis_name.interGenic-primers.txt
              ###########################plots###############################
                                   
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*Distribution_to_different_repeat_type_classes.stat.txt > $plotread/Distribution_to_different_repeat_type_classes.stat.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs_with_complementary.txt $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs.txt $plotread/Frequency_of_identified_SSR_motifs.txt
              python3 -W ignore $Script/Distribution_to_different_repeat_type_classes.stat.py $plotread/Distribution_to_different_repeat_type_classes.stat.txt $plots/"Distribution of the different SSR classes".png 
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs_with_complementary.py $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt $plots/"SSR distribution considering sequence complementarity".png
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs.py $plotread/Frequency_of_identified_SSR_motifs.txt $plots/"Frequency of the identified SSR motifs".png
              cp  $plots/*.png  $outdir/"$organis_name"-MegaSSR_Results    
              now8="$(date)"
              printf "\n\n\t$now8 \tDrawing plots Done %s\n\n"
              ########################################################

              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"The distribution of the different SSR classes".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Frequency_of_identified_SSR_motifs.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of the identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of identified SSR motifs considering complementarity".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genomic.fa.misa.txt  $outdir/"$organis_name"-MegaSSR_Results/"Identified SSR motifs table".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.intergenic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"SSR primer statistics".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.interGenic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged SSR primer".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Summary of identified SSR motifs".csv
              awk -F "\t" '{print $2"_"$4"\t"$10"\t"$14}' $sql/"Desinged SSR primer.csv" >$intermediate_File_step_1/$organis_name.interGenic-primers.txtsearch
              awk -F "\t" '{print $2"_"$4"\t"$10"\t"$14}' $sql/"Desinged SSR primer.csv" >$intermediate_File_step_1/$organis_name.interGenic-primers.txtsearch
              cp $intermediate_File_step_1/$organis_name.interGenic-primers.txtsearch  $intermediate_File_step_1/$organis_name.primers.forprimersearch
              #########################################################
              now9="$(date)"
                     printf "\t$now9 \tThe results saved in $outdir %s\n"
              fi
       fi

       if [ $Analysistype -eq 2 ] # #####  genic-SSR #########
              then
              awk -F '\t' '$3~/'$genic'/' $outdir/$sequence_acc.gff > $intermediate_File_step_1/$organis_name.fet2

              awk -F "\t" '{print $1}' $intermediate_File_step_1/$organis_name.fet2 >$intermediate_File_step_1/$organis_name.fet.ids
              awk '!x[$0]++'  $intermediate_File_step_1/$organis_name.fet.ids >$intermediate_File_step_1/$organis_name.fet.ids2
              grep ">" $outdir/"$sequence_acc"_genomic.fa >$intermediate_File_step_1/fasta.ids
              sed -i 's/>//g' $intermediate_File_step_1/fasta.ids
              awk 'NR==FNR{seen[$0]=1; next} seen[$0]' $intermediate_File_step_1/$organis_name.fet.ids2 $intermediate_File_step_1/fasta.ids >$intermediate_File_step_1/sheard.ids

              sheardfile=$intermediate_File_step_1/sheard.ids

              if [ ! -s "${sheardfile}" ]; then

              printf "\n\tThe sequence IDs between FASTA and GFF files do not match, so MegaSSR has been stopped. Please check this, otherwise use option -A 1 to identify SSR without classifying into genic and non-genic SSR\n\n"
              
              else
              # SSR mining by use MISA (genome fasta)
              now2="$(date)"
              printf "\n\n\t$now2 \tSimple Sequence Repeat identification started %s\n\n"
              # SSR mining by use MISA (genome fasta)
              python3 $Script/MISA_threads.py $FASTA $threads $Script/misa.pl $outdir 2>/dev/null
              # move MISA file result to intermediate_File
              cp $FASTA/all_results.misa $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa # move MISA file result to intermediate_File
              awk -F'\t' -v org=$organis_name '{ print 'org'"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7 }'  $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa > $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7 }'  $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa > $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp1\t/\tMono\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $sql/$organis_name.genomic.fa.misa.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $sql/$organis_name.genomic.fa.misa.txt

              now3="$(date)"
              printf "\n\n\t$now3 \tIdentifying SSR Done %s\n\n"
              ################### Genic_SSR_with_feature

              perl $Script/get-genic-SSR.pl $sql/$organis_name.genomic.fa.misa.txt $intermediate_File_step_1/$organis_name.fet2  $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature.txt  $sql/$organis_name.Genic_SSR_with_feature.txt $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt
              awk -F '\t'  '{ print "\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$14"\t"$16 }' $sql/$organis_name.Genic_SSR_with_feature.txt >$sql/table11_Genic_misa_feature.txt

              ######## # Determine_Intergenic SSR (print found in file 2 [.misa] an not found in file 1 [feature])
              grep -F -x -v -f $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt $sql/$organis_name.genomic.fa.misa.txt >$intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt
              cp $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt  $sql/$organis_name.Accept_Intergenic_SSR.txt
              ################################################## Step_2 #######                    
              sed 's/).*//' $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_1.txt #delete all after ")"                    
              sed 's/.*(//' $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_1.txt > $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_2.txt #delete all before ")"             
              cat $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_2.txt | awk ' { tot[$1]++ } END { for (i in tot) print tot[i],i } ' | sort | tr ' ' \\t > $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt # count duplicate line                    
              sed 's/).*//' $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt > $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_1.txt #delete all after ")"                     
              sed 's/.*(//' $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_1.txt > $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_2.txt #delete all before ")"                    
              cat $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_2.txt  | awk ' { tot[$1]++ } END { for (i in tot) print tot[i],i } ' | sort | tr ' ' \\t > $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt # Count_duplicate_line                    
              awk '{ print $2 }' $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt #Print_Specific_column in file                   
              awk '{print $2}' $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt #Print_Specific_column in file                   
              grep -F -x -v -f $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt > $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic.txt # found in file 2 and not in file one (uniq in intergenic region)                  
              grep -F -x -v -f  $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt> $intermediate_File_step_1/"$sequence_acc"_uniq-genic.txt # found in file 2 and not in file one (uniq in genic region)                    
              awk 'NR==FNR{a[$1]++;next} a[$1] ' $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt> $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt # get over-lab between two files (the over-lab between genic and intergenic)                   
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_uniq-genic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt #search the file for a specific column and output a repeat with the number of entries found (uniq-genic.txt)
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt > $sql/$organis_name.uniq-genic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table6""\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt > $intermediate_File_step_1/table6.uniq-genic.txt
                     
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt #search the file for a specific column and print the repeat with the number of found (uniq-intergenic.txt)
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt > $sql/$organis_name.uniq-intergenic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table7""\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt > $intermediate_File_step_1/table7.uniq-intergenic.txt

              ##########search the file for a specific column and output a repeat with the number of entries found (uniq-genic.txt)
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_1.txt
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_2.txt

              ############## collect the Overlab Seq and Total Num in Genic then Total Num in Intergenic
              perl $Script/Overlab-Num.pl $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_2.txt $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_1.txt > $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2"\t"$3 }'  $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt > $sql/$organis_name.overlab-all-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table8""\t"'org'"\t"$1"\t"$2"\t"$3 }'  $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt > $intermediate_File_step_1/table8.overlab.txt

              ######################## statistics ############################          
              now4="$(date)"
              printf "\n\n\t$now4 \tPreparing statistics files %s\n\n"
              for i in $FASTA/*.fa.statistics
              do
                     name=$(basename $i ".fa.statistics")
                     grep -f $Script/patterns $FASTA/$name.fa.statistics >$FASTA/$name.RESULTS_OF_MICROSATELLITE_SEARCH.txt
                     
                     grep -Pzo "(?s)((?<=Unit size\tNumber of SSRs\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $FASTA/$name.fa.statistics  >$FASTA/$name.Distribution_to_different_repeat_type_classes.txt1
                     sed '$d'  $FASTA/$name.Distribution_to_different_repeat_type_classes.txt1 >$FASTA/$name.Distribution_to_different_repeat_type_classes.txt
                     awk 'NF > 0' $FASTA/$name.Distribution_to_different_repeat_type_classes.txt > $FASTA/$name.Distribution_to_different_repeat_type_classes.txt2

                     sed 's/1\t/Mono\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.txt2 >$FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/2\t/Di\t/g'  $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/3\t/Tri\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/4\t/Tetra\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/5\t/Penta\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt
                     sed -i 's/6\t/Hexa\t/g' $FASTA/$name.Distribution_to_different_repeat_type_classes.stat.txt

                     grep -Pzo "(?s)((?<=Frequency of identified SSR motifs\n)(.*?)(?=(\nFrequency of classified repeat types \(considering sequence complementary\)|\Z)))" $FASTA/$name.fa.statistics >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     tail -n +3 $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt> $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.grep >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt2
                     tail -n +4 $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt2 >$FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt3
                     sed -i '$d' $FASTA/"$name"_Frequency_of_identified_SSR_motifs.txt3
                     grep -Pzo "(?s)((?<=Frequency of classified repeat types \(considering sequence complementary\)\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $FASTA/$name.fa.statistics >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep
                     awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt
                     tail -n +3 $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt> $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
                     awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.grep >$FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt2
                     tail -n +4 $FASTA/"$name"_Frequency_of_classified_repeat_with_complementary.txt2 > $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
                     sed -i '$d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
                     awk '{print $0"\t"length($3)}' $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3 >$FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt4
                     sed '1d'  $FASTA/"$name"_Frequency_of_identified_SSR_motifs_with_complementary.txt >$FASTA/"$name"_Frequency_SSR_motifs.complementary.txt 
                     sed -i -E 's/\:\s+/\t/g' $FASTA/$name.RESULTS_OF_MICROSATELLITE_SEARCH.txt           
              done

              python3 $Script/ssr_merge.py $FASTA  _Frequency_SSR_motifs.complementary.txt
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd_Frequency_SSR_motifs.complementary.txt >  $sql/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt

              python3 $Script/ssr_merge.py $FASTA  _Frequency_of_identified_SSR_motifs.txt3
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd_Frequency_of_identified_SSR_motifs.txt3 > $sql/$organis_name.Frequency_of_identified_SSR_motifs.txt

              python3 $Script/ssr_merge.py $FASTA  .Distribution_to_different_repeat_type_classes.stat.txt
              sed '1s/^/Repeats\ttotal\n/' $FASTA/mergerd.Distribution_to_different_repeat_type_classes.stat.txt > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt2
              python3 $Script/ssr_merge.py $FASTA  .RESULTS_OF_MICROSATELLITE_SEARCH.txt
              cp $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt

              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt > $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt
                     
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt2 > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table3""\t"'org'"\t"$1"\t"$NF }' $sql/$organis_name.Frequency_of_identified_SSR_motifs.txt >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4
              awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $sql/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt4
              sed -i '1d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4
              sed -i '1d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt4
              sed -i '1d' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt

              cat $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt
              grep "Total number of identified SSRs" $FASTA/mergerd.RESULTS_OF_MICROSATELLITE_SEARCH.txt >$FASTA/For_SSR_Stat  ##Total number of identified SSRs
              awk -F "\t" '{print $2}' $FASTA/For_SSR_Stat >$FASTA/For_SSR_Stat.status ##Total number of identified SSRs
              numberofssr=$(cat $FASTA/For_SSR_Stat.status)  ##Total number of identified SSRs

              if [ $numberofssr -eq 0 ] ### Total number of identified SSRs
                     then  
                     printf "\n\n\tNo SSR was found, MegaSSR is stopped\n\n"
                     else
              now4="$(date)"
              printf "\n\n\t$now4 \tClassification, gene-based annotation and motif comparisons done%s\n\n"

               ############################ SSR Primers##############################

              cd $designprimer ### intergenic
              split -d -l 500 $sql/$organis_name.Accept_Intergenic_SSR.txt 

                     for i in $FASTA/*.fa
                     do
                     name=$(basename $i ".fa")
                            python3 $Script/designprimer_threads.py $i  $designprimer $designprimerresults $threads $Script/extractseq-id-start-end-intergenic.pl $outdir/modified_p3_in.pl 
                     done

              cd $gdesignprimer  ##genic primer-design
              split -d -l 500 $sql/table11_Genic_misa_feature.txt 

                     for i in $FASTA/*.fa
                     do
                     name=$(basename $i ".fa")
                            python3 $Script/gdesignprimer_threads.py $i  $gdesignprimer $gdesignprimerresults $threads $Script/extractseq-id-start-end-genic.pl $outdir/modified_p3_in_genic.pl 
                     done
              cat $designprimerresults/*.fa >$sql/$organis_name."SSR flanking sequence.fa"
              cat $gdesignprimerresults/*.fa >>$sql/$organis_name."SSR flanking sequence.fa"
	      
                     ######## for SSR.non-redundant.fa #################
                     cp $sql/$organis_name."SSR flanking sequence.fa" $USERCH/SSR_with_flanking_regions.fa
                     $Script/usearch11.0.667_i86linux32  -sortbylength $USERCH/SSR_with_flanking_regions.fa --fastaout $USERCH/SSR_with_flanking_regions_sorted.fa --log $USERCH/usearch.log >>$USERCH/screen
                     $Script/usearch11.0.667_i86linux32  -cluster_fast  $USERCH/SSR_with_flanking_regions_sorted.fa --id 0.9 --centroids $USERCH/my_centroids.fa --uc $USERCH/result.uc -consout $USERCH/SSR.non-redundant.fa -msaout $USERCH/aligned.fasta --log $USERCH/usearch2.log >>$USERCH/screen
                     # rm $USERCH/aligned.* 
                     sed '2d' $USERCH/usearch2.log >$sql/SSR.non-redundant.log
                     sed -i '3d' $sql/SSR.non-redundant.log
                     sed -i '11d' $sql/SSR.non-redundant.log
                     cp $USERCH/SSR.non-redundant.fa $sql/"Non-redundant SSR library.fasta"
                     now100="$(date)"
                     printf "\n\n\t$now101 \tNon-redundant SSR library done%s\n\n"

              ############################primer-design##############################
              python3 $Script/gdesignprimer2_threads.py $gdesignprimer $gdesignprimerresults $threads $Script/extractseq-id-start-end-genic.pl $outdir/modified_p3_in_genic.pl $organis_name $Script/modified_p3_out-genic.pl $Script/print-primers-line-genicCCC.pl $intermediate_File_step_1
                                                                 
              #######prepear genic primers table with repeat and gene info (only desinged primers)#########                           

              awk '!seen[$15]++' $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results2.txt > $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results2_2.txt
              awk '!seen[$19]++' $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results2_2.txt > $sql/$organis_name.Genic-primers.txt
              wc -l $sql/$organis_name.Genic-primers.txt >$intermediate_File_step_1/$organis_name.Extract-Genic-out.fasta.stat
              sed -i 's/\s/\t/g' $intermediate_File_step_1/$organis_name.Extract-Genic-out.fasta.stat
              awk -F "\t" -v txt="No. of desinged SSR primers" -v org=$organis_name '{print "\t"'org'"\t"'txt'"\t"$1}' $intermediate_File_step_1/$organis_name.Extract-Genic-out.fasta.stat >$sql/$organis_name.genic.primers.stat.txt

              now5="$(date)"
              printf "\n\n\t$now5 \tDesign genic-SSR primers done%s\n\n"
              

              python3 $Script/designprimer3_threads.py $designprimer $designprimerresults $threads $Script/extractseq-id-start-end-intergenic.pl $outdir/modified_p3_in.pl $organis_name $Script/modified_p3_out-intergenic.pl $Script/print-primers-line-nongenicCCC.pl $intermediate_File_step_1
              
              awk '!seen[$9]++' $intermediate_File_step_1/$organis_name.interGenic-primers3.txt > $intermediate_File_step_1/$organis_name.interGenic-primers3_2.txt
              awk '!seen[$13]++' $intermediate_File_step_1/$organis_name.interGenic-primers3_2.txt > $sql/$organis_name.interGenic-primers.txt
              wc -l $sql/$organis_name.interGenic-primers.txt >$intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat
              sed -i 's/\s/\t/g' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat
              awk -F "\t" -v txt="No. of desinged SSR primers" -v org=$organis_name '{print "\t"'org'"\t"'txt'"\t"$1}' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat >$sql/$organis_name.intergenic.primers.stat.txt

              now6="$(date)"
              printf "\n\n\t$now6 \tDesign intergenic-SSR primers done%s\n\n"

              #########################browse##########################

              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\n/' $sql/$organis_name.genomic.fa.misa.txt
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\n/' $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i '1s/^/\tProcess Id\tRepeat Type\tTotal No. of present\n/' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tRepeat Type\tRepeat Length\tGene\tGene Start\tGene End\tSequence Strand (Gene)\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\tAnnotation\n/' $sql/$organis_name.Genic-primers.txt
              sed -i '1s/^/\tProcess Id\tSequence ID\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tGene\tGene Start\tGene End\t\tSequence Strand (Gene)\t\tAnnotation\n/' $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\n/' $sql/$organis_name.interGenic-primers.txt
              sed -i '1s/^/\tProcess Id\tRepeat Sequence\tNO. of the present (Genic)\tNO. of the present (Non-genic)\n/' $sql/$organis_name.overlab-all-with-Num.txt
              sed -i '1s/^/\tProcess Id\tNO. of the present (Genic)\tRepeat Sequence\n/' $sql/$organis_name.uniq-genic-with-Num.txt
              sed -i '1s/^/\tProcess Id\tNO. of the present (Non-Genic)\tRepeat Sequence\n/' $sql/$organis_name.uniq-intergenic-with-Num.txt

              ############################plots##########################
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*Distribution_to_different_repeat_type_classes.stat.txt > $plotread/Distribution_to_different_repeat_type_classes.stat.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*overlab-all-with-Num.txt > $plotread/overlab-all-with-Num.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*uniq-genic-with-Num.txt > $plotread/uniq-genic-with-Num.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*uniq-intergenic-with-Num.txt > $plotread/uniq-intergenic-with-Num.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs_with_complementary.txt $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs.txt $plotread/Frequency_of_identified_SSR_motifs.txt
              python3 -W ignore $Script/Distribution_to_different_repeat_type_classes.stat.py $plotread/Distribution_to_different_repeat_type_classes.stat.txt $plots/"Distribution of the different SSR classes".png 
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs_with_complementary.py $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt $plots/"SSR distribution considering sequence complementarity".png
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs.py $plotread/Frequency_of_identified_SSR_motifs.txt $plots/"Frequency of the identified SSR motifs".png
              python3 -W ignore $Script/overlab-all-with-Num.py $plotread/overlab-all-with-Num.txt $plots/"Common repeats between genic and non-genic regions".png
              python3 -W ignore $Script/uniq-genic-with-Num.py $plotread/uniq-genic-with-Num.txt $plots/"Unique repeats in the genic region".png
              python3 -W ignore $Script/uniq-intergenic-with-Num.py $plotread/uniq-intergenic-with-Num.txt $plots/"Unique repeats of the non-genic region".png

              python3 $Script/van_diagram.py $plotread/overlab-all-with-Num.txt  $plotread/uniq-genic-with-Num.txt $plotread/uniq-intergenic-with-Num.txt $sql/"Venn diagram of genic and non-genic SSR".png

              cp  $plots/*.png  $outdir/"$organis_name"-MegaSSR_Results      
              now9="$(date)"
              printf "\n\n\t$now9 \tDrawing plots Done %s\n\n"         
              ########################################################

              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Accept_Intergenic_SSR.txt  $outdir/"$organis_name"-MegaSSR_Results/"non-genic SSR repeats with annotations".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"The distribution of the different SSR classes".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Frequency_of_identified_SSR_motifs.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of the identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Frequency_of_identified_SSR_motifs_with_complementary.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of identified SSR motifs considering complementarity".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Genic SSR primer statistics".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Genic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged genic SSR primer".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Genic_SSR_with_feature.txt  $outdir/"$organis_name"-MegaSSR_Results/"Genic SSR repeats with annotations".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genomic.fa.misa.txt  $outdir/"$organis_name"-MegaSSR_Results/"Identified SSR motifs table".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.intergenic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Statistics of non-genic SSR primers".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.interGenic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged non-genic SSR primers".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.overlab-all-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Motif sequences shared between genic and non-genic regions".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Summary of identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.uniq-genic-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Repeate sequences Unique to genic regions".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.uniq-intergenic-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Repeate sequences Unique to non-genic regions".csv
             
              awk -F "\t" '{print $2"_"$4"\t"$10"\t"$14}' $sql/"Desinged non-genic SSR primers".csv >$intermediate_File_step_1/$organis_name.nongenic.txtsearch
              sed -i '1d' $intermediate_File_step_1/$organis_name.nongenic.txtsearch
              awk -F "\t" '{print $2"_"$4"\t"$16"\t"$20}' $sql/"Desinged genic SSR primer".csv >$intermediate_File_step_1/$organis_name.genic.txtsearch
              sed -i '1d' $intermediate_File_step_1/$organis_name.genic.txtsearch
              cat $intermediate_File_step_1/$organis_name.nongenic.txtsearch $intermediate_File_step_1/$organis_name.genic.txtsearch >$intermediate_File_step_1/$organis_name.primers.forprimersearch
              ####################e#######################
              rm $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt2
              rm $outdir/"$organis_name"-MegaSSR_Results/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt
              rm $outdir/$sequence_acc.gff

                     now13="$(date)"
                     
                     printf "\t $now13 \tMegaSSR Done, The results saved in $outdir %s\n"
              fi

fi

       fi

              ########################################################
       if ([ $Analysistype -eq 1 ] || [ $Analysistype -eq 2 ] && [ $alleles = yes ] ) ### In-silico validation of MegaSSR results #########
              then
              now11="$(date)"
              printf "\t$now11 \tCounting SSR alleles started. Note: This step takes a long time. %s\n"

             cd $primersearch
	       sed -i '1d' $intermediate_File_step_1/$organis_name.primers.forprimersearch
	       split -n l/50 $intermediate_File_step_1/$organis_name.primers.forprimersearch
              for i in $FASTA/*.fa
              do
                     name=$(basename $i ".fa")
                     echo "$name"
                     python3 $Script/primersearch_threads.py $i  $primersearch $primersearchresults $threads
              done
              cp $primersearchresults/results.primersearch $intermediate_File_step_1/primersearch.results
              perl $Script/primersearch.pl $intermediate_File_step_1/primersearch.results $max_allele_length $intermediate_File_step_1
              awk  '$2!=""' $intermediate_File_step_1/primersearch.results.txt >$intermediate_File_step_1/primersearch.results.txt2  #Delete lines containing empty fields
              awk  '$3!=""' $intermediate_File_step_1/gel.txt >$intermediate_File_step_1/gel.txt2  #Filter primers for drawing have only more than one band
              
              now12="$(date)"
              printf "\t$now12 \t Drawing SSR alleles started %s\n"
              python3 $Script/plot_gel.py $intermediate_File_step_1/gel.txt2 "             In-silico validation of MegaSSR results"  $max_allele_length $primer_image $sql/insilco_gel.jpg $intermediate_File_step_1/alleles.txt #2>/dev/null #update it
              perl $Script/For_allele.pl  $intermediate_File_step_1/primersearch.results.txt2 $intermediate_File_step_1/$organis_name.primers.forprimersearch >$sql/"SSR primer with alleles.csv"
              now13="$(date)"
              printf "\t$now13 \tMegaSSR Done, The results saved in $outdir %s\n"
       
       fi

              mv $sql/* $outdir   
              rm -rf $USERCH           
              rm -rf $designprimerresults
              rm -rf $designprimer
              rm -rf $gdesignprimerresults
              rm -rf $gdesignprimer
              rm -rf $FASTA
              rm -rf $primersearch
              rm -rf $primersearchresults
              rm -rf $intermediate_File_step_1
              rm -rf $plots
              rm -rf $plotread
              rm $outdir/"$organis_name"_genomic.fa.fai
              rm $outdir/"$sequence_acc"_genomic.fa
              rm -rf $sql
              rm $outdir/misa.ini
              rm $outdir/modified_p3_in.pl
              rm -rf $outdir/$organis_name