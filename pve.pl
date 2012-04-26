#!eusr/bin/perl

use strict;
use warnings;

use lib './lib';
use Net::Proxmox::VE;
use Data::Dumper;
use Getopt::Long;

my $host     = 'host';
my $username = 'root';
my $password = 'password';
my $debug    = undef;

GetOptions (
    'host=s'     => \$host,
    'username=s' => \$username,
    'password=s' => \$password,
    'debug'      => \$debug,
);

my $pve = Net::Proxmox::VE->new(
    host     => $host,
    username => $username,
    password => $password,
    debug    => $debug,
);

die "login failed\n"         unless $pve->login;
die "invalid login ticket\n" unless $pve->check_login_ticket;


# list nodes in cluster
print Dumper $pve->action(path => '/nodes',        method => 'GET');

# list nodes in cluster
print Dumper $pve->action(path => '/access/users', method => 'GET');

# Create a test user
print Dumper $pve->action(
    path      => '/access/users',
    method    => 'POST',
    post_data => {'userid' => 'testuser@foobar'}
);
print Dumper $pve->action(path => '/access/users/testuser@foobar', method => 'DELETE');
