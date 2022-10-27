#!/usr/bin/perl 
use strict;
my $searchfile = $ARGV[0];
my $searchfor  = $ARGV[1];
my @parray;
open (PFILE,"<$searchfile");
while (<PFILE>) {
    chomp();
    if (/(\S+)\t(\S+)\t([\S|\s]+)/) {
        my $id   = $1;
        my $rnu   = $2;
        my $rtyp   = $3;
        push( @parray, [ $id, $rnu, $rtyp] );
    }
}
close PFILE;
open (GFILE,"<$searchfor");
print "Primer Id\tForward Primer\tReverse Primer\tNumber of alleles\tAllele Id\tHit Sequence Id\tPrimer Start within Sequence\tPrimer end\tForward Primer Mismatch\tReverse Primer Mismatch\tAllele Length\n";
while (<GFILE>) {
    chomp();
    if (/(\S+)\t([\S|\s]+)/) {
        my $contig  = $1;
        my $gstart  = $2;
        # my $newid= $contig."_".$gend;

# print "$newid\t$contig\t$gstart\t$gend\t$product\n";
        for my $i ( 0 .. $#parray ) {

      if($contig eq $parray[$i][1])
         {          

         print "$contig\t$gstart\t$parray[$i][0]\t$parray[$i][2]\n";
       }
        }

    }
}
close GFILE;
