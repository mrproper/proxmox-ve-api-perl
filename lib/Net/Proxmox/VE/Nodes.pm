#!/bin/false

package Net::Proxmox::VE::Nodes;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = 0.1;
our @EXPORT  = qw( nodes reload_nodes );

my $base = '/nodes';

=head2 nodes

Returns the clusters node list from the object,

=cut

sub nodes {

    my $self = shift or return;

    return $self->get($base);

}

1;
