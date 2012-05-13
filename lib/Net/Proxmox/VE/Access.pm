#!/bin/false

package Net::Proxmox::VE::Access;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = 0.1;
our @EXPORT = qw( access access_domains );

my $base = '/access';

sub access {

    my $self = shift or return;
    my @a = @_ and die 'access accepts no arguments';

    my $access = $self->get($base);
    return wantarray ? @$access : $access;

}

sub access_domains {

    my $self = shift or return;
    my @a = @_;

    # if no arguments, return a list
    unless (@a) {

        my $domains = $self->get($base,'domains');
        return wantarray ? @$domains : $domains;

    # if there is a single argument, return a single realm instance as an object
    } elsif (@a == 1) {

        my $domains = $self->get($base,'domains',$a[0]);
        return $domains;

    # if there are multiple, then create new realm
    } else {

    }

    return 1

}

sub new {

}

1;
