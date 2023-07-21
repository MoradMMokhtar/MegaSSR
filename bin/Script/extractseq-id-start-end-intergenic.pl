#!/usr/bin/perl 
use strict;
use Bio::SeqIO;
my %ids;
my $idssandefile = $ARGV[1];
my $result = $ARGV[2];
open(IDS,"<$idssandefile");
while(<IDS>)
{
#primername Id start end
if(/\t(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
{
   push(@{$ids{$2}},[$7,$8,$1,$3,$4,$5,$6]);
}
}
close IDS;

foreach my $k(keys(%ids))
{
 foreach my $s(@{$ids{$k}})
 {
 #print $s->[1];
 }
}
#getseqbystartend($in_file,$1,$2,$3);
getseqbystartend();

sub getseqbystartend
{
 
my $seqfile = Bio::SeqIO->new( -file => $ARGV[0], -format => "fasta" );
while ( my $seqobj = $seqfile->next_seq )
{

 if ($ids{$seqobj->display_id()})
   {
my @array=@{$ids{$seqobj->display_id()}};
foreach my $se(@array)
{
  my @searray=@{$se};
  my $st = $searray[0]-200;
my $et = $searray[1]+200;
my $pm = $searray[2];  
my $sm = $searray[3];
my $sm1 = $searray[4];
my $sm2 = $searray[5];
my $sm3 = $searray[6];

my $rstat = $st+200;
my $rend = $et-200;

 my $seqout=substr ($seqobj->seq(),$st,($et-$st));
 my $seqoutseq = Bio::Seq->new(-seq=>$seqout, -format => 'fasta');
  $seqoutseq->display_id(  $seqobj->display_id() ."==$pm==$sm==$sm1==$sm2==$sm3==$rstat==$rend==$st==$et" );
my $writefile = Bio::SeqIO->new(-id=>"$result",-file => ">>$result", -format => "fasta");
$writefile->write_seq($seqoutseq);
}

}
}
}

