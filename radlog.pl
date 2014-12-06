#!/usr/bin/perl

use strict;
my @search_patterns;
my @once_search_pattern;

my $search = $ARGV[0] or die 'Usage: radlog <search ip> < log.txt';
push @search_patterns, $search;

my $color_patterns = {
			'User-Name = .*' 			=> "\e[31m", 		# red
			'Framed-IP-Address = .*' 	=> "\e[32m\e[45m",		# green-bold
			'Accounting Request' 		=> "\e[33m", 		# yellow
			'Access Request' 		 	=> "\e[34m",		# blue
			'id \d+'					=> "\e[35m",		# magenta
			'Acct-Status-Type = .*'     => "\e[36m",		# cyan
			'lol'						=> "\e[37m\e[45m"		# white-bold
		     }; 
my $default_color_code = "\e[39m\e[49m";



my $default_file = 'sample_log'; #'/usr/local/billing/bm-7/var/log/log.txt';
my $fd;
if (-t STDIN)
{
	open $fd, '<', $default_file or die 'Cant open default file '.$! ;
}
else
{
	$fd = *STDIN;
}
my ($flag, $str);
while (<$fd>)
{
	if (m/^  /)  # str is ^____
	{
			#print '^  flag='.$flag."\n";
		$str .= $_;
			#print $str;
		$flag = 1;
	}
	else
	{
		if ($flag) # previous str was ^___, handle the str
		{ 
			do_str($str);
				#print "strstr $str strstr\n";
			$str = '';
		}
		$flag = 0;
		$str = '';
		do_str($_);
	}
}

sub do_str
{
	my $str = shift;
	foreach (@once_search_pattern) # look for our id Answer
	{
		if ( $str =~ m/$_/gm ) # ID string found, color and print
		{
			print color_str($str);
			
		}
		
	}
	foreach (@search_patterns)
	{
		if ( $str =~ m/$_/gm ) # this string is good, lets color and print
		{
			if ($str =~ m/id=(\d+)/) { push @once_search_patterns, "id $1" } # look for Answer to this request
			print color_str($str);
		}

	}
}

sub color_str
{
	my $str = shift;
	foreach (keys %$color_patterns)
	{
		if ( $str =~ m/$_/ )
		{
			my $color_code = $color_patterns->{$_};
			$str =~ s/($_)/$color_code$1$default_color_code/g;
		}
	}
	print $str;
}

