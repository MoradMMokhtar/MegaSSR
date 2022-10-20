#!/usr/bin/perl 
use strict;
my $input = $ARGV[0];
my @parray;
open( PFILE, "<$input" );
while (<PFILE>) {
    chomp();
        if (/\t(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/) {
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
         my $rend23   = $23;
         my $rend24   = $24;
         my $rend25   = $25;
         my $rend26   = $26;
         my $rend27   = $27;
         my $rend29   = $rend+$rend25;
         my $rend30   = $rend29+$rend27;
         print "\t$id\t$rnu\t$rtyp\t$rseq\t$rsiz\t$rstart\t$rend29\t$rend30\t$rend9\t$rend10\t$rend12\t$rend13\t$rend14\t$rend15\t$rend17\t$rend18\t$rend19\t$rend20\t$rend21\t$rend22\t$rend23\t$rend24\t$rend27\t$rend16\n";

       }
         }

close GFILE;
