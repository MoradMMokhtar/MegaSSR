#!/usr/bin/perl 
use strict;
my $searchfile = $ARGV[0];
my $searchfor  = $ARGV[1];
my @parray;
open (PFILE,"<$searchfile");
while (<PFILE>) {
    chomp();
    if (/(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)/) {
        my $id   = $1;
        my $rnu   = $2;
        my $rtyp   = $3;
        my $rseq = $4;
         my $rsiz   = $5;
        my $rstart   = $6;
         my $rend   = $7;
         my $rend2   = $8;
        push( @parray, [ $id, $rnu, $rtyp, $rseq, $rsiz, $rstart, $rend, $rend2] );
    }
}
close PFILE;
open (GFILE,"<$searchfor");

while (<GFILE>) {
    chomp();
    if (/(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t([\S|\s]+)/) {
        my $contig  = $1;
        my $gstart  = $2;
        my $gend    = $3;
        my $product = $4;
        my $product2 = $5;
        my $product3 = $6;
        for my $i ( 0 .. $#parray ) {
      if($contig eq $parray[$i][1])
         {          
       if($product<=$parray[$i][6]&&$product2>=$parray[$i][7])    
{   

         print "$parray[$i][0]\t$parray[$i][1]\t$parray[$i][2]\t$parray[$i][3]\t$parray[$i][4]\t$parray[$i][5]\t$parray[$i][6]\t$parray[$i][7]\t$gend\t$product\t$product2\t$product3\n";
       }
         } 
        }

    }
}
close GFILE;
