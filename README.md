# check-s3-file-age

nagios check for age of a specific file in AWS S3

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
