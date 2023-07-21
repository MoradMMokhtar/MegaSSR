#!/usr/bin/perl -w
# Author: Thomas Thiel
# Program name: prim_output.pl
# Description: converts the Primer3 output into an table
use warnings;
no warnings 'uninitialized';

open (SRC,"<$ARGV[0]") || die ("\nError: Couldn't open Primer3 results file (*.p3out) !\n\n");
my $filename = $ARGV[0];
$filename =~ s/\.p3out//;
open (OUT,">$filename.results") || die ("nError: Couldn't create file !\n\n");
open (STAT,">$filename.stat") || die ("nError: Couldn't create file !\n\n");

undef $/;

$/ = "=\n";

while (<SRC>)
  {
  my ($id) = (/PRIMER_SEQUENCE_ID=(\S+)/);

  my $misa = $1;

  /PRIMER_LEFT_0_SEQUENCE=(.*)/  || do {$count_failed++;print OUT "\t$misa\n"; next};
  my $info = "$1\t";
  /PRIMER_LEFT_0_TM=(.*)/; $info .= "$1\t";
  /PRIMER_LEFT_0=\d+,(\d+)/; $info .= "$1\t";
  /PRIMER_LEFT_0_GC_PERCENT=(.*)/; $info .= "$1\t";
  /PRIMER_RIGHT_0_SEQUENCE=(.*)/;  $info .= "$1\t";
  /PRIMER_RIGHT_0_TM=(.*)/; $info .= "$1\t";
/PRIMER_RIGHT_0=\d+,(\d+)/; $info .= "$1\t";
  /PRIMER_RIGHT_0_GC_PERCENT=(.*)/; $info .= "$1\t";

/PRIMER_LEFT_0=(\d+),(\d+)/; $info .= "$1\t";
/PRIMER_RIGHT_0=(\d+),(\d+)/; $info .= "$1\t";
  /PRIMER_PAIR_0_PRODUCT_SIZE=(.*)/; $info .= "$1\t";


  $count++;
  print OUT "\t$misa\t$info\n"
  };

print STAT "No. of desinged SSR primers\t $count\n";
print STAT "No. of failed designed SSR primers \t$count_failed";
