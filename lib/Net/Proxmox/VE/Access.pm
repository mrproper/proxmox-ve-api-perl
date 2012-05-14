#!/bin/false

package Net::Proxmox::VE::Access;

use strict;
use warnings;
use Carp qw(croak);
use base 'Exporter';

=head1 VERSION

VERSION 0.1

=cut

our $VERSION = 0.1;
our @EXPORT = qw( access access_domains );

=head1 NAME

Net::Proxmox::VE::Access - Functions for the 'access' portion of the API

=head1 SYNOPSIS

  # assuming $obj is a Net::Proxmox::VE object

  my @dir_index = $obj->access();

  my @domain_index = $obj->access_domains();
  my $domain = $obj->access_domains($realm);
  eval{ $obj->access_domains(\%args) };

=head1 METHODS

=head2 access

Without arguments, returns the 'Directory index':

(Corresponds to the following functions in the PMVE Api definitions)

  HTTP: GET /api2/json/access
  CLI:  pvesh get /access

With arguments: croaks as there is no applicable PUT behaviour

=cut

my $base = '/access';

sub access {

    my $self = shift or return;
    my @a = @_ and croak 'access accepts no arguments';

    my $access = $self->get($base);
    return wantarray ? @$access : $access;

}

=head2 access_domains

Without arguments, returns 'Authentication domain index':

(Corresponds to the following functions in the PMVW Api definitions)

  HTTP: GET /api2/json/access/domains
  CLI:  pvesh get /access/domains

With a single scalar argument, returns a single Domain object:

(Corresponds to the following functions in the PMVW Api definitions)

  HTTP: GET /api2/json/access/domains/{realm}
  CLI:  pvesh get /access/domains/{realm}

With multiple arguments, '[Adds] an authentication server':

(Corresponds to the following functions in the PMVW Api definitions)

  HTTP: POST /api2/json/access/domains
  CLI:  pvesh create /access/domains

=cut

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

=head1 SEE ALSO

=head1 SUPPORT

=head1 AUTHORS

Brendan Beveridge <brendan@nodeintegration.com.au>,
Dean Hamstead <dean@fragfest.com.au>

=cut

1
