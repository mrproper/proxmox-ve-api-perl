#!/bin/false

package Net::Proxmox::VE::Pools;

use strict;
use warnings;
use base 'Exporter';

=head1 NAME

Net::Proxmox::VE::Pools

=head1 SYNOPSIS

  $obj->pools();

=head1 DESCRIPTION

This module implements the 'pools' section of the Proxmox API for L<Net::Proxmox::VE>,
you should use the API via that module. This documentation is for detailed reference.

=head1 METHODS


=cut

our $VERSION = 0.1;
our @EXPORT = qw( pools );

my $base = '/pools';

sub pools {

    my $self = shift or return;
    my @a = @_;

    # if no arguments, return a list
    unless (@a) {

        my $storage = $self->get($base);
        return $storage;

    # if there is a single argument, return a single storage instance as an object
    } elsif (@a == 1) {

        my $storage = $self->get($base,$a[0]);
        return $storage;

    # if there are multiple, then create new storage
    } else {

    }

    return 1

}

sub new {

}

=head1 VERSION

  VERSION 0.2

=head1 AUTHORS

 Dean Hamstead L<<dean@fragfest.com.au>>

=cut


1;
