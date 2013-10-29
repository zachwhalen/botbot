#!/usr/bin/local/perl

####################
#
#  This is a very simple script for making a random-word bot for Twitter.
#  It's based on Darius Kazemi's GenGen
#
#  This is written in Perl (obviously) and designed to be executed by a cron job.
#  For setup and other things, consult the README in the Git repository:
#  
#  Or this step-by-step blog entry:
# 
#  This code is free to use, copy, modify, critique, or make fun of.
#  It is not guaranteed to work. Neither is it guaranteed to keep you out of trouble.
#  


# Basic package setup

use Net::Twitter::Lite::WithAPIv1_1;


# ADD YOUR TWITTER APPLICATION DETAILS HERE:

$consumer_key = '';
$consumer_secret = '';
$access_token = '';
$access_token_secret = '';

# CREATE YOUR CUSTOM WORD LISTS HERE
#
# Punctuation is important! Your lists are "arrays". They should look like this:
# @A = (
#    'It',
#    'They',
#    'We',
#    'Santa Claus',
#    'John Milton'
#    );
# 
# Use as many of these blocks as you need. Delete (in entirety) any that you don't.

@first = (
    'a word one',
    'word two',
    'change these', 
    'another'
    );

@second = (
    'b word one',
    'word two',
    'change these'
    );

@third = (
    'c word one',
    'word two',
    'change these'
    );

@fourth = (
    'd word one',
    'word two',
    'change these'
    );

@fifth = (
    'e word one',
    'word two',
    'change these'
    );

@sixth = (
    'f word one',
    'word two',
    'change these'
    );

@seventh = (
    'g word one',
    'word two',
    'change these'
    );

@eigth = (
    'h word one',
    'word two',
    'change these'
    );

# GENERATE A TWEET

$tweet = &generate();

&doTweet($tweet);
exit;


sub generate {
    my $msg = '';

    my @lists = (\@first, \@second, \@third, \@fourth, \@fifth, \@sixth, \@seventh, \@eigth);

    
    foreach (@lists){
	my $i;
	for ($i = 0; $_->[$i]; $i++){ } # this is an awkward way to count, but it works. I don't know why.
	$msg .= $_->[int(rand($i))] . " ";
    }
    
    # clean up extra spaces
    $msg =~ s/  / /g;

    # chop it down to 140, if necessary
    $msg = substr $msg, 0, 140;

    return $msg;
}

sub doTweet {  

    my $tweet = @_[0];

    # Construct Twitter interface
    my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
	traits   => [qw/API::RESTv1_1/],
	consumer_key => $consumer_key,
	consumer_secret => $consumer_secret,
	access_token => $access_token,
	access_token_secret => $access_token_secret,
	);

    #print $tweet;
    # Send the tweet
    
    my $result = $nt->update($tweet);
    
    # Error messages if it didn't work           
    if ( my $err = $@ ) {
	die $@ unless blessed $err && $err->isa('Net::Twitter::Lite::WithAPIv1_1::Error');
	warn "HTTP Response Code: ", $err->code, "\n",
        "HTTP Message......: ", $err->message, "\n",
	"Twitter error.....: ", $err->error, "\n";
    }

}
