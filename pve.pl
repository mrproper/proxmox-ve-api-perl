#!eusr/bin/perl

use strict;
use warnings;

use lib './lib';
use Net::Proxmox::VE;


my $pve = Net::Proxmox::VE->new(
    username => 'root',
    password => 'password',
    host     => 'hostname',
);

print "login_ok\n"  if $pve->login;
print "ticket_ok\n" if $pve->check_login_ticket;


$pve->action(path => '/nodes', method => 'GET');
