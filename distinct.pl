#! /usr/bin/perl

use strict;
use warnings;

use File::Find;
use File::Temp qw/ tempdir /;
use File::Path qw/ make_path /;
use MIME::Base64 qw/ encode_base64url decode_base64url /;

my $tmpdir = tempdir( CLEANUP => 1 );
chdir($tmpdir);

my $hashlen = 5;

while (<>) {
	# using base64 from RFC 4648 §5, as it was done specifically for URLs
	my $encoded = encode_base64url($_);

	# Split the string to 5-chars ones
	my @a = unpack("(a$hashlen)*", $encoded);

	# Make it a path
	my $path = join("/", @a);
	make_path($path);
}

# Did read everything, collect
sub process {
	my $filename = $File::Find::name;
	$filename =~ s,^\./,,;

	# reassemble the base64
	$filename =~ s,^\./,,;

	my $decoded = decode_base64url($filename);

	print $decoded;
}

find({ wanted => \&process, follow => 1 }, '.');
