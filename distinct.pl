#! /usr/bin/perl

use strict;
use warnings;

use File::Find;
use File::Temp qw/ tempdir /;
use File::Path qw/ make_path /;

my $tmpdir = tempdir( CLEANUP => 1 );
chdir($tmpdir);

while (<>) {
	chop;
	# Replace _ by __
	# replace / by _! so it is reversible
	# replace . by _. so it is reversible
	s/_/__/g;
	s,/,_!,g;
	s,\.,_.,g;
	make_path($_);
}

# Did read everything, collect
sub process {
	my $filename = $File::Find::name;
	$filename =~ s,^\./,,;
	$filename =~ s,_\.,.,g;
	$filename =~ s,_!,/,g;
	$filename =~ s,__,_,g;
	print "$filename";
	print "\n";
}

find({ wanted => \&process, follow => 1 }, '.');
