#!/usr/bin/perl 
use strict;
my $input = $ARGV[0];
my @parray;
open( PFILE, "<$input" );
while (<PFILE>) {
    chomp();
    if (/\t(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
        my $id   = $1;
        my $rnu   = $2;
        my $rtyp   = $3;
        my $rseq = $4;
         my $rsiz   = $5;
        my $rstart   = $6;
         my $rend   = $7;
         my $rend8   = $8;
         my $rend9   = $9;
         my $rend10   = $10;
         my $rend11   = $11;
         my $rend12   = $12;
         my $rend13   = $13;
         my $rend14   = $14;
         my $rend15   = $15;
         my $rend16   = $16;
         my $rend17   = $17;
         my $rend18   = $18;
         my $rend19   = $19;
         my $rend20   = $20;
         my $rend21   = $21;
         my $rend22   = $22;
 
         my $rend29   = $rend9+$rend19;
         my $rend30   = $rend29+$rend21;
         print "\t$id\t$rnu\t$rtyp\t$rseq\t$rsiz\t$rstart\t$rend\t$rend8\t$rend29\t$rend30\t$rend11\t$rend12\t$rend13\t$rend14\t$rend15\t$rend16\t$rend17\t$rend18\t$rend21\t$rend18\n";
       }
         } 
close GFILE;
