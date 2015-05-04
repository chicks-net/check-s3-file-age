# check-s3-file-age

nagios check for age of a specific file in AWS S3

## usage

	check_s3_file_age v0.5 (nagios-plugins 2.0.3)
	The nagios plugins come with ABSOLUTELY NO WARRANTY. You may redistribute
	copies of the plugins under the terms of the GNU General Public License.
	For more information about these matters, see the file named COPYING.
	Copyright (c) 2015 Christopher Hicks

	Usage:
	  check_s3_file_age [-w <secs>] [-c <secs>] [-W <size>] [-C <size>] [-i] [-k <access-key>] [-s <secret-key>] -n <bucket-name> -f <file>
	  check_s3_file_age [-h | --help]
	  check_s3_file_age [-V | --version]

	  -i | --ignore-missing :  return OK if the file does not exist
	  <secs>  File must be no more than this many seconds old (default: warn 240 secs, crit 600)
	  <size>  File must be at least this many bytes long (default: crit 0 bytes)
	  <access-key> is optional if you have the environment variables AWS_ACCESS_KEY defined
	  <secret-key> is optional if you have the nvironment variables AWS_SECRET_KEY defined

## examples

Look in `s3bucket` for a file named `foo`.  Warn if the files is smaller than 100000 bytes
and go critical if the file is less than 50.

	check_s3_file_age.pl -n s3bucket -f foo -W 100000 -C 50

Look in `s3bucket` for a file named `foo`.  
Go critical if the file is less than 50000000 bytes.
Also warn if the file is older than 6 days
and go critical if the file is older than 8 days.

	check_s3_file_age.pl -n s3bucket -f foo -C 50000000 -w 6d -c 8d

## requirementso

* Perl modules
    * [Net::Amazon::S3](https://metacpan.org/release/Net-Amazon-S3) (debian package`libnet-amazon-s3-perl`)

## acknoledgements

* [Matthew McMillan](http://matthewcmcmillan.blogspot.com/2013/05/monitor-s3-file-ages-with-nagios.html) wrote [check_s3_file_age.py](https://github.com/matt448/nagios-checks) but it does not check one specific file -- it looks at a directory of files.
* [Hari Sekhon's](http://exchange.nagios.org/directory/Plugins/Cloud/check_aws_s3_file-2Epl-%28Advanced-Nagios-Plugins-Collection%29/details) [check_aws_s3_file.pl](https://github.com/harisekhon/nagios-plugins/blob/master/check_aws_s3_file.pl) looks at one specific file, but it does not check file age.
* Opsview's [check_aws_s3](https://secure.opsview.com/svn/opsview/trunk/opsview-core/nagios-plugins/check_aws_s3) checks a bucket and not a file

## see also

* [check_read_only_fs](https://github.com/chicks-net/nagios-current/tree/master/plugins) - checks for readonly filesystems
* [nagios-current](https://github.com/chicks-net/nagios-current/) - automatically restart nagios when configs change
* [nagios-plugins](https://github.com/PerfectAudience/nagios-plugins) - our collection of Perl and x86_64 nagios plugins
