#!/usr/bin/perl

use strict;
my $default_file = 'sample_log'; #'/usr/local/billing/bm-7/var/log/log.txt';
my $file;

eval {
    local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
    alarm 1;
    my $nread = <>;
    alarm 0;
    };

if ($@) 
{         # timed out
    die 'some other error: '.$@ unless $@ eq "alarm\n"; # propagate unexpected errors
    $file = <>;    
}
else 
{         # not timeout, stdin presented
    open $file, '<', $default_file or die 'Cant open default file'; 
}

while (<$file>)
{
    print;

}

