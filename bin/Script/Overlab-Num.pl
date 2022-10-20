#!/usr/bin/perl 
use strict;
my $searchfile = $ARGV[0];
my $searchfor  = $ARGV[1];
my @parray;
open( PFILE, "<$searchfile" );
while (<PFILE>) {
    chomp();
    if (/(\S+)\s+(\S+)/) {
        my $id   = $1;
        my $rnu   = $2;
        push( @parray, [ $id, $rnu] );
    }
}
close PFILE;
open( GFILE, "<$searchfor" );
while (<GFILE>) {
    chomp();
    if (/(\S+)\s+(\S+)/) {
        my $contig  = $1;
        my $gstart  = $2;
        for my $i ( 0 .. $#parray ) 
         {          
       if($gstart eq $parray[$i][1])    
                {   
         print "$parray[$i][1]\t$parray[$i][0]\t$contig\n";
       }
         } 
        }
    }
close GFILE;
