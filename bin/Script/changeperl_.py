import sys
import os
range=sys.argv[1]
min=sys.argv[2]
opt =sys.argv[3]
max= sys.argv[4]
path = sys.argv[5]
data = """ #!/usr/bin/perl -w
# Author: Thomas Thiel
# Program name: primer3_in.pl
# Description: creates a PRIMER3 input file based on SSR search results
my $filename = $ARGV[0];
if (-s $filename) {
open (SRC,"<$filename");
open (OUT,">$filename.p3in");

undef $/;
$/= ">";

my $count;
while (<SRC>)
  {
  next unless (my ($id,$seq) = /(.*?)\\n(.*)/s);
  $seq =~ s/[\d\s>]//g;#remove digits, spaces, line breaks,...
    my @split_id = split(/==/, $id);
    print OUT "PRIMER_NUM_RETURN=1\\nPRIMER_SEQUENCE_ID=$id\\nSEQUENCE_TEMPLATE=$seq\\n";
    print OUT "PRIMER_PRODUCT_SIZE_RANGE="""+range+"""\\n";
    print OUT "SEQUENCE_TARGET=199,$split_id[5]\\n";
    print OUT "PRIMER_OPT_SIZE="""+opt+"""\\nPRIMER_MIN_SIZE="""+min+"""\\nPRIMER_MAX_SIZE="""+max+"""\\n=\\n";
  };
};"""
with open(f'{path}/modified_p3_in.pl','w') as file: 
	file.write(data)
