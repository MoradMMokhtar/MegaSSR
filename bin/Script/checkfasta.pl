#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;
my $file = $ARGV[0];
my $seqio = Bio::SeqIO->new(-file => $file, -format => "fasta");
while(my $seq = $seqio->next_seq) {
  # do stuff with sequences...
}
