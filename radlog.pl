#!/usr/bin/perl

my @grep_patterns = qw/radrecv radsend /;

my $color_patterns = {
			'User-Name = .*' 		=> 'red',
			'Framed-IP-Address = .*' 	=> 'blue',
			'Accounting Request' 		=> 'green',
			'Access Request' 		=> 'green',
			'id \d+'			=> 'yellow',
			'Acct-Status-Type = .*'         => 'cyan'
		     }; 

use strict;
my $default_file = 'sample_log'; #'/usr/local/billing/bm-7/var/log/log.txt';

push @ARGV, $default_file if !@ARGV and -t STDIN;

while (<>)
{
    print;
}



