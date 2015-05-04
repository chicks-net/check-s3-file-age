#!/usr/bin/perl

use warnings;
use strict;
use English;
use Getopt::Long;
use utils qw (%ERRORS &print_revision &support);
use lib "/usr/local/nagios/libexec" ;
use vars qw($PROGNAME);
use Net::Amazon::S3;
use Data::Dumper;
use Date::Parse;

sub print_help ();
sub print_usage ();

$PROGNAME="check_s3_file_age";
my (
	$opt_c, $opt_f, $opt_w, $opt_C, $opt_W, $opt_h, $opt_V, $opt_i,
	$opt_k, $opt_s, $opt_n
	
);
my $VERSION = '0.5';
my $PRENAG = "S3_FILE_AGE:";

# options processing
Getopt::Long::Configure('bundling');

GetOptions(
	"V"		=> \$opt_V, "version"		=> \$opt_V,
	"h"		=> \$opt_h, "help"		=> \$opt_h,
	"i"		=> \$opt_i, "ignore-missing"	=> \$opt_i,
	"accesskey|k=s"	=> \$opt_k, "AWS-access-key"	=> \$opt_k,
	"secretkey|s=s"	=> \$opt_s, "AWS-secret-key"	=> \$opt_s,
	"bucket|n=s"	=> \$opt_n, "S3-bucket-name"	=> \$opt_n,
	"f=s"		=> \$opt_f, "file"		=> \$opt_f,
	"w=f"		=> \$opt_w, "warning-age=f"	=> \$opt_w,
	"W=f"		=> \$opt_W, "warning-size=f"	=> \$opt_W,
	"c=f"		=> \$opt_c, "critical-age=f"	=> \$opt_c,
	"C=f"		=> \$opt_C, "critical-size=f"	=> \$opt_C
);

if ($opt_V) {
	print_revision($PROGNAME, $VERSION);
	exit $ERRORS{'OK'};
}

if ($opt_h) {
	print_help();
	exit $ERRORS{'OK'};
}

# validate AWS creds
my $aws_access_key = $opt_k || $ENV{"AWS_ACCESS_KEY"};
my $aws_secret_key = $opt_s || $ENV{"AWS_SECRET_KEY"};

unless (defined $aws_access_key and defined $aws_secret_key) {
	print_help();
	print "\nERROR: did not provide AWS access creds\n";
	exit $ERRORS{'OK'};
}

# validate bucket
my $bucket_name = $opt_n;
unless (defined $bucket_name) {
	print_help();
	print "\nERROR: did not provide required S3 bucket name\n";
	exit $ERRORS{'OK'};
}

# validate bucket
my $s3_file_name = $opt_f;
unless (defined $s3_file_name) {
	print_help();
	print "\nERROR: did not provide required S3 file name\n";
	exit $ERRORS{'OK'};
}

#
# actually check something
#
my $result = 'OK';

my $s3 = Net::Amazon::S3->new(
    {
	aws_access_key_id     => $aws_access_key,
	aws_secret_access_key => $aws_secret_key,
#	use_iam_role          => 1,
	retry                 => 1,
    }
);

# check bucket name
my $bucket = $s3->bucket($bucket_name);

unless (defined $bucket) {
	print "$PRENAG no bucket '$bucket_name' owned by this user.\n";
	$result = 'CRITICAL';
	exit $ERRORS{$result};
}

#print "DEBUG using " . $bucket->bucket . "\n";

# check file
my $file_response = $bucket->get_key($s3_file_name);
unless ($file_response) {
	my $message = "$PRENAG: no such file $bucket_name/$s3_file_name";
	print $message . "\n";
	$result = 'CRITICAL';
	exit $ERRORS{$result};
}

#print Dumper($file_response);
#print "KEYS:", join(', ', keys %$file_response), "\n";
#foreach my $fld (qw(date last-modified client-date content_length )) {
#	my $value = $file_response->{$fld} || 'undef';
#	print "$fld\t= $value\n";
#}

my $size = $file_response->{content_length};
#print "size=$size\ncrit=$opt_C\nwarn=$opt_W\n";

if ($opt_C and $size < $opt_C) {
#	warn "size crit";
	$result = 'CRITICAL';
} elsif ($opt_W and $size < $opt_W) {
#	warn "size warn";
	$result = 'WARNING';
}

my $age = $file_response->{'last-modified'};
print "age=$age\n";

print "exit with $result\n";

# last exit
exit $ERRORS{$result};

#
# subroutines
#

sub print_usage () {
	print "Usage:\n";
	print "  $PROGNAME [-w <secs>] [-c <secs>] [-W <size>] [-C <size>] [-i] [-k <access-key>] [-s <secret-key>] -n <bucket-name> -f <file>\n";
	print "  $PROGNAME [-h | --help]\n";
	print "  $PROGNAME [-V | --version]\n";
}

sub print_help () {
	print_revision($PROGNAME, $VERSION);
	print "Copyright (c) 2015 Christopher Hicks\n\n";
	print_usage();
	print "\n";
	print "  -i | --ignore-missing :  return OK if the file does not exist\n";
	print "  <secs>  File must be no more than this many seconds old (default: warn 240 secs, crit 600)\n";
	print "  <size>  File must be at least this many bytes long (default: crit 0 bytes)\n";
	print "  <access-key> is optional if you have the environment variables AWS_ACCESS_KEY defined\n";
	print "  <secret-key> is optional if you have the nvironment variables AWS_SECRET_KEY defined\n";
	print "\n";
	support();
}
