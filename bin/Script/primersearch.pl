#!/usr/bin/perl 
use strict;
my $outfile = $ARGV[0];
my $length = $ARGV[1];
my $outdir = $ARGV[2];
open RFILE,"<$outfile";
open CSVFILE,">$outdir/primersearch.results.txt";
open CSVFILEA,">$outdir/gel.txt";
my @lines= (<RFILE>);
my $alllines = "@lines";
$alllines =~s/\n/ /g;
my @prims = split(/Primer\sname/,$alllines);
foreach(@prims)
{
	if(/^\s(\S+)\s/)
	{
		my $primname  =  $1;
		my $ampsr=$_;
		my $str='';
		my  $countfilter=0;
		my @amps=split(/Amplimer\s+\d+/,$ampsr);
				print CSVFILEA "$primname\t";

		foreach(@amps)
		{
			if(/Sequence\:\s(\S+)\s+([ACTG]+)\shits\sforward\sstrand\sat\s(\d+)\swith\s(\d+)\smismatches\s+([ACTG]+)\shits\sreverse\sstrand\sat\s\[*(\d+)\]*\swith\s(\d+)\smismatches\s+Amplimer\slength\:\s(\d+)\sbp/g)
			{
				my $id = $1;
				my $fseq=$2;
				my $fhitpos=$3;
				my $fhitmis=$4;
				my $rseq=$5;
				my $rhitpos=$6;
				my $rhitmis=$7;
				my $amplength=$8;
				my $fhitpos2=$fhitpos-1;
				my $rhitpos2=($fhitpos-1)+$amplength;
				if ($amplength<=$length)
				{       my $i=$countfilter++;
				        $i+=1;
						print CSVFILEA "$amplength\t";	
						 $str.="$primname\t$primname.allele.$i\t$id\t$fhitpos2\t$rhitpos2\t$fhitmis\t$rhitmis\t$amplength\t";				
				}
			}
			
		}
		print CSVFILEA "\n";
		print CSVFILE "$countfilter\t$str\n";
		$str='';		
	}
}
close RFILE;
close CSVFILE;
# print "Printing Results In Form Done";
