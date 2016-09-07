#!/usr/bin/perl


use strict;


my %interact=();
my %phospho=();

my $int=shift;
my $phos=shift;


open (I,$int);
while (<I>){
  if (/(\S+)\s+interacts\s+(\S+)/){
    my $p1=$1;
    my $p2=$2;
    next if ($p1 eq $p2);
    $p1=~tr/a-z/A-Z/;
    $p2=~tr/a-z/A-Z/;
    $interact{$p1}{$p2}=1;
    $interact{$p2}{$p1}=1;

  }
}
close I;


open (P,$phos);
while(<P>){
  next if (/Prot/);
  if (/(\S+)\s+(\S+)/){
    my $p=$1;
    my $val=$2;
    $p=~tr/a-z/A-Z/;
    $phospho{$p}=$val;
  }
}
close P;

print "Prot\tlocalEnvPertub\n";
foreach my $p1 (keys %interact){
  my $newval=abs($phospho{$p1});
  print STDERR "$p1=$newval  ";

  foreach my $p2 (keys %{$interact{$p1}}){
    $newval=$newval+abs($phospho{$p2});
    print STDERR "$p2=$phospho{$p2} ->$newval  ";
  }
      print STDERR "FINAL $p1=$newval\t\t\ $p1\t$newval\n";

}
