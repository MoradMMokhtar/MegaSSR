#!/bin/bash
if [ $# -eq 0 ]
   then
      echo "Parameters -A and -F is required, use [bash MegaSSR.sh -help] for more detalis"
      exit
fi

userpath=$(pwd)
Script=$userpath/bin/Script
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
       range=100-500
##}
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "MegaSSR is a pipeline designed for high-throughput Simple Sequence Repeat (SSR) identification, classification, gene-based annotation, motif comparison, and SSR marker design for any target genome (including Plantae, Protozoa, Animalia, Chromista, Fungi, Archaea, and Bacteria)."
   echo
   echo "     MegaSSR v1.2.0"
   echo
   echo "     Options:"
   echo "     -h     Print this Help."
   echo "     -A     The analysis type [1 or 2] 1 (for Simple Sequence Repeat identification, classification, and SSR marker design 'This analysis needs FASTA file only') 2 (for Simple Sequence Repeat identification, classification, gene-based annotation, motif comparison, and SSR marker design 'This analysis needs FASTA and GFF files') , default is 2"
   echo "     -F     Your path to Fasta file."
   echo "     -G     Your path to GFF file."
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
   echo
   echo "Default parameters:bash MegaSSR.sh -A $Analysistype -F Your_path_to_FASTA_file -G Your_path_to_GFF_file -P $organis_name -1 $mono -2 $di -3 $tri -4 $tetra -5 $penta -6 $hexa -C $compound -s $Min -O $opt -S $max -R $range"
   exit
}
version()
{
   echo "MegaSSR v1.2.0"
   echo
   exit
}
       ############################################################
       # Process the input options.                               #
       ############################################################
       check=0
       while getopts h:A:F:G:P:1:2:3:4:5:6:C:s:S:O:R:v: options
       do
              case $options in
              h) Help;;
              v) version;;
              A) Analysistype=$OPTARG;((check=check+1));;
              F) Fasta=$OPTARG;((check=check+1));;
              G) Gff=$OPTARG;;
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
              *) echo "Error: Invalid option" ;;
              esac
       done

       ###############################################################
       #### MegaSSR process the start.                               #
       ###############################################################
       sequence_acc=$organis_name
       outdir= mkdir -p $userpath/Results/$organis_name
       outdir=$userpath/Results/$organis_name

       now="$(date)" 
       echo
       printf "\t#############################################\n\t##############  MegaSSR v1.2.0  ##############\n\t#############################################\n\n\tContributors: Morad M Mokhtar, Rachid El Fermi, Alsamman M. Alsamman, Achraf El Allali\n\n"
       printf "\t$now \t Start time %s\n"  ### print current date
       echo
       printf "\tParameters: -A $Analysistype -F $Fasta -G $Gff -P $organis_name -1 $mono -2 $di -3 $tri -4 $tetra -5 $penta -6 $hexa -C $compound -s $Min -O $opt -S $max -R $range\n\n"

       if [ $check -ne 2 ]
              then
              printf "\tParameters -A and -F is required, use [bash MegaSSR.sh -help] for more detalis\n"
              exit
       fi
       #conda activate uncompres

       if [[ $Fasta =~ \.gz$ ]]; then
              cd $outdir
              echo
              printf "\tCheck the FASTA File format.\n"
              gunzip -c "$Fasta" >$outdir/"$sequence_acc"_genomic.fa
              conda activate MegaSSR
              perl $Script/checkfasta.pl $outdir/"$sequence_acc"_genomic.fa ### Check the FASTA File format
              elif [[ $Fasta =~ \.zip$ ]]; then
              echo
              printf "\tCheck the FASTA File format.\n"
              gunzip -c "$Fasta" >$outdir/"$sequence_acc"_genomic.fa
              conda activate MegaSSR
              perl $Script/checkfasta.pl $outdir/"$sequence_acc"_genomic.fa ### Check the FASTA File format
              elif ([ $(stat -c%s "$Fasta") -gt 500 ]); then
              printf "\tCheck the FASTA File format.\n"
              conda activate MegaSSR
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
       conda activate MegaSSR

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
       python3 $Script/changeini_.py $mono  $di $tri $tetra $penta $hexa $compound $outdir
       python3 $Script/changeperl_.py $range $Min  $opt  $max $outdir

       if [ $Analysistype -eq 1 ] # #####  General-SSR #########
              then
              ##{ Identifying SSR MISA
              sed -i 's/ .*//' $outdir/"$sequence_acc"_genomic.fa
              now2="$(date)"
              printf "\n\n\t$now2 \tSimple Sequence Repeat identification started %s\n\n"
              perl  $Script/misa.pl $outdir/"$sequence_acc"_genomic.fa $outdir # SSR mining by use MISA (genome fasta)              
              mv $outdir/"$sequence_acc"_genomic.fa.misa $intermediate_File_step_1 # move MISA file result to intermediate_File
              mv $outdir/"$sequence_acc"_genomic.fa.statistics $intermediate_File_step_1
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
              grep -f $Script/patterns $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt > $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt
              grep -Pzo "(?s)((?<=Unit size\tNumber of SSRs\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics  >$sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1
              sed '$d'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1 >$sql/$organis_name.Distribution_to_different_repeat_type_classes.txt
              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1
              awk 'NF > 0' $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt > $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2 > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t1\t/\tMono\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t2\t/\tDi\t/g'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t3\t/\tTri\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t4\t/\tTetra\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t5\t/\tPenta\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t6\t/\tHexa\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt
              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2
              grep -Pzo "(?s)((?<=Frequency of identified SSR motifs\n)(.*?)(?=(\nFrequency of classified repeat types \(considering sequence complementary\)|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep
              awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt
              tail -n +3 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt> $sql/"$organis_name"_Frequency_of_identified_SSR_motifs.txt
              sed -i '$d'  $sql/"$organis_name"_Frequency_of_identified_SSR_motifs.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table3""\t"'org'"\t"$1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt2
              tail -n +4 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt2 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3
              sed -i '$d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3
              awk '{print $0"\t"length($3)}' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4
              grep -Pzo "(?s)((?<=Frequency of classified repeat types \(considering sequence complementary\)\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep
              awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt
              tail -n +3 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt> $sql/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
              sed -i '$d'  $sql/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt2
              tail -n +4 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt2 > $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
              sed -i '$d'  $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
              awk '{print $0"\t"length($3)}' $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs_with_complementary.txt4
       
              now6="$(date)"
              printf "\n\n\t$now6 \tDesign SSR primers started%s\n\n"
              perl $Script/extractseq-id-start-end-intergenic.pl $outdir/"$sequence_acc"_genomic.fa $sql/$organis_name.Accept_Intergenic_SSR.txt $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta
              perl $outdir/modified_p3_in.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta
              ############################primer-design##############################

              conda activate primer3_core
              primer3_core < $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3in >$intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3out
              perl $Script/modified_p3_out-intergenic.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3out
              sed -i 's/=/\t/g' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.results
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat > $sql/$organis_name.intergenic.primers.stat.txt

              perl $Script/print-primers-line-nongenicCCC.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.results >$sql/$organis_name.interGenic-primers.txt
              now7="$(date)"
              printf "\n\n\t$now7 \tDesign SSR primers Done%s\n\n"
              
              #########################################################
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\Repeat Start\tRepeat End\n/' $sql/$organis_name.genomic.fa.misa.txt
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\Repeat Start\tRepeat End\n/' $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i '1s/^/\tProcess Id\tRepeat Type\tTotal No. of present\n/' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\t\n/' $sql/$organis_name.interGenic-primers.txt
              ###########################plots###############################
                                   
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*Distribution_to_different_repeat_type_classes.stat.txt > $plotread/Distribution_to_different_repeat_type_classes.stat.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs_with_complementary.txt $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs.txt $plotread/Frequency_of_identified_SSR_motifs.txt
              conda activate plots
              python3 -W ignore $Script/Distribution_to_different_repeat_type_classes.stat.py $plotread/Distribution_to_different_repeat_type_classes.stat.txt $plots/"Distribution of the different SSR classes".png 
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs_with_complementary.py $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt $plots/"SSR distribution considering sequence complementarity".png
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs.py $plotread/Frequency_of_identified_SSR_motifs.txt $plots/"Frequency of the identified SSR motifs".png
              cp  $plots/*.png  $outdir/"$organis_name"-MegaSSR_Results    
              now8="$(date)"
              printf "\n\n\t$now8 \tDrawing plots Done %s\n\n"
              
              ########################################################

              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"The distribution of the different SSR classes".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/"$organis_name"_Frequency_of_identified_SSR_motifs.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of the identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of identified SSR motifs considering complementarity".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genomic.fa.misa.txt  $outdir/"$organis_name"-MegaSSR_Results/"Identified SSR motifs table".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.intergenic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"SSR primer statistics".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.interGenic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged SSR primer".csv
              rm -r $plots
              rm -r $plotread
              rm -r $intermediate_File_step_1
              rm $sql/$organis_name.Accept_Intergenic_SSR.txt
              rm $outdir/"$sequence_acc"_genomic.fa
              mv $sql/* $outdir
              rm -r $sql
              rm $outdir/misa.ini
              rm $outdir/modified_p3_in.pl

              now9="$(date)"
              printf "\t$now9 \tMegaSSR Done, The results saved in ($outdir) %s\n"
              ########################################################
       fi

       if [ $Analysistype -eq 2 ] # #####  genic-SSR #########
              then
              awk -F'\t' '$3~/gene/' $outdir/$sequence_acc.gff > $intermediate_File_step_1/$organis_name.fet2
              awk -F'\t' -v org=$organis_name '{ print 'org'"\t"$1"\t"$3"\t"$4"\t"$5"\t"$7"\t"$9 }'  $intermediate_File_step_1/$organis_name.fet2 > $intermediate_File_step_1/$organis_name.fet2_2
              sed  's/;/\t/g' $intermediate_File_step_1/$organis_name.fet2 > $intermediate_File_step_1/$organis_name.fet1
              sed -i 's/ .*//' $outdir/"$sequence_acc"_genomic.fa
              # SSR mining by use MISA (genome fasta)
              now2="$(date)"
              printf "\n\n\t$now2 \tSimple Sequence Repeat identification started %s\n\n"
              perl  $Script/misa.pl $outdir/"$sequence_acc"_genomic.fa $outdir # SSR mining by use MISA (genome fasta)              
 
              # move MISA file result to intermediate_File
              mv $outdir/"$sequence_acc"_genomic.fa.misa $intermediate_File_step_1
              mv $outdir/"$sequence_acc"_genomic.fa.statistics $intermediate_File_step_1
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

                                #*****************************
                         # Genic_SSR_with_feature

              perl $Script/get-genic-SSR.pl $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt $intermediate_File_step_1/$organis_name.fet1 > $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature.txt

              perl $Script/get-genic-SSR2.pl $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt $intermediate_File_step_1/$organis_name.fet1 > $sql/$organis_name.Genic_SSR_with_feature.txt

              perl $Script/get-genic-SSR3.pl $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt $intermediate_File_step_1/$organis_name.fet2_2 > $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature2.txt

              sed -i 's/=/morad/g'  $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature2.txt
              sed  's/morad/=/g'  $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature2.txt  >$intermediate_File_step_1/$organis_name.Genic_SSR_with_feature2.txt2


              sed -i 's/\tp1\t/\tMono\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $sql/$organis_name.Genic_SSR_with_feature.txt
              awk -F'\t'  '{ print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8 }'  $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature.txt > $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt
                                          #*****************************

                     # Determine_Intergenic SSR (print found in file 2 [.misa] an not found in file 1 [feature])
              grep -F -x -v -f $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt $intermediate_File_step_1/"$sequence_acc"_genomic.fa.misa.txt >$intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt
              awk -F'\t'  '{ print "\t"$1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8 }'  $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt > $sql/$organis_name.Accept_Intergenic_SSR.txt

              sed -i 's/\tp1\t/\tMono\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $sql/$organis_name.Accept_Intergenic_SSR.txt

                                                        #***** Step_2*******
                     #delete all after ")"
              sed 's/).*//' $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_1.txt
                     #delete all before ")"
              sed 's/.*(//' $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_1.txt > $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_2.txt 

                     # count duplicate line
              cat $intermediate_File_step_1/"$sequence_acc"_Accept_Intergenic_SSR_2.txt | awk ' { tot[$1]++ } END { for (i in tot) print tot[i],i } ' | sort | tr ' ' \\t > $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt

                     #delete all after ")"
              sed 's/).*//' $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature.txt > $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_1.txt
                     #delete all before ")"
              sed 's/.*(//' $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_1.txt > $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_2.txt
                     # Count_duplicate_line
              cat $intermediate_File_step_1/$organis_name.Genic_SSR_none_feature_2.txt  | awk ' { tot[$1]++ } END { for (i in tot) print tot[i],i } ' | sort | tr ' ' \\t > $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt

                     #Print_Specific_column in file
              awk '{ print $2 }' $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt

                     #Print_Specific_column in file
              awk '{print $2}' $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt

                     # found in file 2 and not in file one (uniq in intergenic region)
              grep -F -x -v -f $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt > $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic.txt

                     # found in file 2 and not in file one (uniq in genic region)
              grep -F -x -v -f  $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt> $intermediate_File_step_1/"$sequence_acc"_uniq-genic.txt

                     # get over-lab between two files (the over-lab between genic and intergenic)
              awk 'NR==FNR{a[$1]++;next} a[$1] ' $intermediate_File_step_1/"$sequence_acc"_modified_Stat_interGenic_SSR_1.txt $intermediate_File_step_1/"$sequence_acc"_modified_Stat_Genic_SSR_1.txt> $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt

                     #search the file for a specific column and output a repeat with the number of entries found (uniq-genic.txt)
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_uniq-genic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt > $sql/$organis_name.uniq-genic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table6""\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-genic-with-Num.txt > $intermediate_File_step_1/table6.uniq-genic.txt
              
                     #search the file for a specific column and print the repeat with the number of found (uniq-intergenic.txt)
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt > $sql/$organis_name.uniq-intergenic-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table7""\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/"$sequence_acc"_uniq-intergenic-with-Num.txt > $intermediate_File_step_1/table7.uniq-intergenic.txt

                     #search the file for a specific column and output a repeat with the number of entries found (uniq-genic.txt)
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_interGenic_SSR.txt >$intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_1.txt
              awk 'NR==FNR{a[$1]++;next}{if($2 in a){print}}' $intermediate_File_step_1/"$sequence_acc"_overlab-between-genic-intergenic.txt  $intermediate_File_step_1/"$sequence_acc"_Stat_Genic_SSR.txt > $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_2.txt

                     # collect the Overlab Seq and Total Num in Genic then Total Num in Intergenic
              perl $Script/Overlab-Num.pl $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_2.txt $intermediate_File_step_1/"$sequence_acc"_overlabintergenic-with-Num_1.txt > $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2"\t"$3 }'  $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt > $sql/$organis_name.overlab-all-with-Num.txt
              awk -F'\t' -v org=$organis_name '{ print "\t""table8""\t"'org'"\t"$1"\t"$2"\t"$3 }'  $intermediate_File_step_1/"$sequence_acc"_overlab-all-with-Num.txt > $intermediate_File_step_1/table8.overlab.txt

              ######################## statistics ############################          
              now4="$(date)"
              printf "\n\n\t$now4 \tPreparing statistics files %s\n\n"
              grep -f $Script/patterns $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt > $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt

              rm $sql/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.txt

              grep -Pzo "(?s)((?<=Unit size\tNumber of SSRs\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics  >$sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1

              sed '$d'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1 >$sql/$organis_name.Distribution_to_different_repeat_type_classes.txt
              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt1

              awk 'NF > 0' $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt > $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2

              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2 > $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt

              sed -i 's/\t1\t/\tMono\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t2\t/\tDi\t/g'  $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t3\t/\tTri\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t4\t/\tTetra\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t5\t/\tPenta\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i 's/\t6\t/\tHexa\t/g' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt

              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt
              rm $sql/$organis_name.Distribution_to_different_repeat_type_classes.txt2
              grep -Pzo "(?s)((?<=Frequency of identified SSR motifs\n)(.*?)(?=(\nFrequency of classified repeat types \(considering sequence complementary\)|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep
              awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt
              tail -n +3 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt> $sql/"$organis_name"_Frequency_of_identified_SSR_motifs.txt
              sed -i '$d'  $sql/"$organis_name"_Frequency_of_identified_SSR_motifs.txt

              awk -F'\t' -v org=$organis_name '{ print "\t""table3""\t"'org'"\t"$1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt2
              tail -n +4 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt2 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3
              sed -i '$d' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3
              awk '{print $0"\t"length($3)}' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt3 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs.txt4

              grep -Pzo "(?s)((?<=Frequency of classified repeat types \(considering sequence complementary\)\n)(.*?)(?=(\nFrequency of identified SSR motifs|\Z)))" $intermediate_File_step_1/"$sequence_acc"_genomic.fa.statistics >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep
              awk -F'\t' -v org=$organis_name '{ print $1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt
              tail -n +3 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt> $sql/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt
              sed -i '$d'  $sql/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt

              awk -F'\t' -v org=$organis_name '{ print "\t""table4""\t"'org'"\t"$1"\t"$NF }' $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.grep >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt2
              tail -n +4 $intermediate_File_step_1/"$sequence_acc"_Frequency_of_classified_repeat_with_complementary.txt2 > $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
              sed -i '$d'  $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3
              awk '{print $0"\t"length($3)}' $intermediate_File_step_1/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt3 >$intermediate_File_step_1/"$sequence_acc"_Frequency_of_identified_SSR_motifs_with_complementary.txt4

              now4="$(date)"
              printf "\n\n\t$now4 \tClassification, gene-based annotation and motif comparisons done%s\n\n"


               ############################Genic SSR Primers##############################
                                                           
              perl $Script/extractseq-id-start-end-genic.pl $outdir/"$sequence_acc"_genomic.fa $intermediate_File_step_1/$organis_name.Genic_SSR_with_feature2.txt $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta
              perl $Script/extractseq-id-start-end-intergenic.pl $outdir/"$sequence_acc"_genomic.fa $sql/$organis_name.Accept_Intergenic_SSR.txt $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta

               ############################primer-design##############################

              conda activate primer3_core

              perl $outdir/modified_p3_in.pl $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta
                                                                      #primer-design
              primer3_core < $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.p3in > $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.p3out
              perl $Script/modified_p3_out-genic.pl $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.p3out
              sed -i 's/=/\t/g' $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.stat > $sql/$organis_name.genic.primers.stat.txt

              #######prepear genic primers table with repeat and gene info (only desinged primers)#########                           
              perl $Script/print-primers-line-genicCCC.pl $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results >$intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp1\t/\tMono\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp2\t/\tDi\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp3\t/\tTri\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp4\t/\tTetra\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp5\t/\tPenta\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tp6\t/\tHexa\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tc\t/\tCompound\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/\tc\*\t/\tCompound\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              sed -i 's/morad/=/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt
              cp $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt  $sql/$organis_name.Genic-primers.txt
              ####sed  's/;/\t/g'  $intermediate_File_step_1/$organis_name.Extract-Genic-seq-out.fasta.results.txt > $sql/$organis_name.Genic-primers.txt

              now5="$(date)"
              printf "\n\n\t$now5 \tDesign genic-SSR primers done%s\n\n"

                                                                             # intergenic
              perl $outdir/modified_p3_in.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta
                                                                             #primer-design
              primer3_core < $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3in >$intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3out
              perl $Script/modified_p3_out-intergenic.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.p3out
              sed -i 's/=/\t/g' $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.results
              awk -F'\t' -v org=$organis_name '{ print "\t"'org'"\t"$1"\t"$2 }'  $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.stat > $sql/$organis_name.intergenic.primers.stat.txt

              perl $Script/print-primers-line-nongenicCCC.pl $intermediate_File_step_1/$organis_name.Extract-intergenic-out.fasta.results >$sql/$organis_name.interGenic-primers.txt

              now6="$(date)"
              printf "\n\n\t$now6 \tDesign intergenic-SSR primers done%s\n\n"

              #########################################################
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\Repeat Start\tRepeat End\n/' $sql/$organis_name.genomic.fa.misa.txt
              sed -i '1s/^/\tProcess Id\tSequence Id\tRepeat number\tRepeat Type\tRepeat Sequence\tRepeat Length\Repeat Start\tRepeat End\n/' $sql/$organis_name.Accept_Intergenic_SSR.txt
              sed -i '1s/^/\tProcess Id\tRepeat Type\tTotal No. of present\n/' $sql/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tRepeat Type\tRepeat Length\tGene\tGene Start\tGene End\tSequence Strand (Gene)\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\tAnnotation\n/' $sql/$organis_name.Genic-primers.txt
              sed -i '1s/^/\tProcess Id\tSequence ID\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tGene\tGene Start\tGene End\t\tSequence Strand (Gene)\t\tAnnotation\n/' $sql/$organis_name.Genic_SSR_with_feature.txt
              sed -i '1s/^/\tSequence ID\tProcess Id\tRepeat number\Repeat Type\tRepeat Sequence\tRepeat Length\tRepeat Start\tRepeat End\tPrimer Start\tPrimer End\tForward Primer\tForward Tm\tForward Size (bp)\tForward GC\tReverse Primer\tReverse Tm\tReverse Size (bp)\tReverse GC\tProduct Size (bp)\n/' $sql/$organis_name.interGenic-primers.txt
              sed -i '1s/^/\tProcess Id\tRepeat Sequence\tNO. of the present (Genic)\tNO. of the present (Non-genic)\n/' $sql/$organis_name.overlab-all-with-Num.txt
              sed -i '1s/^/\tProcess Id\tNO. of the present (Genic)\tRepeat Sequence\n/' $sql/$organis_name.uniq-genic-with-Num.txt
              sed -i '1s/^/\tProcess Id\tNO. of the present (Non-Genic)\tRepeat Sequence\n/' $sql/$organis_name.uniq-intergenic-with-Num.txt

              ############################plots##############################
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*Distribution_to_different_repeat_type_classes.stat.txt > $plotread/Distribution_to_different_repeat_type_classes.stat.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*overlab-all-with-Num.txt > $plotread/overlab-all-with-Num.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*uniq-genic-with-Num.txt > $plotread/uniq-genic-with-Num.txt
              cut -f2- $outdir/"$organis_name"-MegaSSR_Results/*uniq-intergenic-with-Num.txt > $plotread/uniq-intergenic-with-Num.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs_with_complementary.txt $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt
              cp $outdir/"$organis_name"-MegaSSR_Results/*Frequency_of_identified_SSR_motifs.txt $plotread/Frequency_of_identified_SSR_motifs.txt
              conda activate plots
              python3 -W ignore $Script/Distribution_to_different_repeat_type_classes.stat.py $plotread/Distribution_to_different_repeat_type_classes.stat.txt $plots/"Distribution of the different SSR classes".png 
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs_with_complementary.py $plotread/Frequency_of_identified_SSR_motifs_with_complementary.txt $plots/"SSR distribution considering sequence complementarity".png
              python3 -W ignore $Script/Frequency_of_identified_SSR_motifs.py $plotread/Frequency_of_identified_SSR_motifs.txt $plots/"Frequency of the identified SSR motifs".png
              python3 -W ignore $Script/overlab-all-with-Num.py $plotread/overlab-all-with-Num.txt $plots/"Common reprate between genic and non-genic regions".png
              python3 -W ignore $Script/uniq-genic-with-Num.py $plotread/uniq-genic-with-Num.txt $plots/"Unique repeats in the genic region".png
              python3 -W ignore $Script/uniq-intergenic-with-Num.py $plotread/uniq-intergenic-with-Num.txt $plots/"Unique repeats of the non-genic region".png
              cp  $plots/*.png  $outdir/"$organis_name"-MegaSSR_Results      
              now9="$(date)"
              printf "\n\n\t$now9 \tDrawing plots Done %s\n\n"         
              ########################################################

              #rename 's/\.txt/\.csv/' $outdir/"$organis_name"-MegaSSR_Results/*.txt
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Accept_Intergenic_SSR.txt  $outdir/"$organis_name"-MegaSSR_Results/"non-genic SSR repeats with annotations".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Distribution_to_different_repeat_type_classes.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"The distribution of the different SSR classes".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/"$organis_name"_Frequency_of_identified_SSR_motifs.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of the identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/"$organis_name"_Frequency_of_identified_SSR_motifs_with_complementary.txt  $outdir/"$organis_name"-MegaSSR_Results/"Frequency of identified SSR motifs considering complementarity".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Genic SSR primer statistics".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Genic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged genic SSR primer".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.Genic_SSR_with_feature.txt  $outdir/"$organis_name"-MegaSSR_Results/"Genic SSR repeats with annotations".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.genomic.fa.misa.txt  $outdir/"$organis_name"-MegaSSR_Results/"Identified SSR motifs table".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.intergenic.primers.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Statistics of non-genic SSR primers".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.interGenic-primers.txt  $outdir/"$organis_name"-MegaSSR_Results/"Desinged non-genic SSR primers".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.overlab-all-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Motif sequences shared between genic and non-genic regions".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.RESULTS_OF_MICROSATELLITE_SEARCH.stat.txt  $outdir/"$organis_name"-MegaSSR_Results/"Summary of identified SSR motifs".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.uniq-genic-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Reprate sequences Unique to genic regions".csv
              mv $outdir/"$organis_name"-MegaSSR_Results/$organis_name.uniq-intergenic-with-Num.txt  $outdir/"$organis_name"-MegaSSR_Results/"Reprate sequences Unique to non-genic regions".csv
            
              ########################################################
              rm -r $plots
              rm -r $plotread
              rm -r $intermediate_File_step_1
              rm $outdir/"$sequence_acc"_genomic.fa
              rm $outdir/$sequence_acc.gff
              mv $sql/* $outdir
              rm -r $sql
              rm $outdir/misa.ini
              rm $outdir/modified_p3_in.pl

              now10="$(date)"
              printf "\t$now10 \tMegaSSR Done, The results saved in ($outdir) %s\n"
       fi
