#!/bin/false

package Net::Proxmox::VE::Nodes;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = 0.1;
our @EXPORT  = qw( nodes );

my $base = '/nodes';

=head2 nodes

Returns the 'Cluster node index'

Note: Accessible by all authententicated users.

=cut

sub nodes {

    my $self = shift or return;

    return $self->get($base);

}

=head2 get_nodes

Gets a single nodes details

  $ok = $obj->get_nodes('node')

node is a string in pve-node format

Note: Accessible by all authententicated users.

=cut

sub get_nodes {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes()';
    die 'node must be a scalar for get_nodes()' if ref $a;

    return $self->get( $base, $a )

}

=head2 get_nodes_aplinfo


Gets a single nodes list of appliances

  $ok = $obj->get_nodes_aplinfo('node')

node is a string in pve-node format

Note: Accessible by all authententicated users.

=cut

sub get_nodes_aplinfo {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_aplinfo()';
    die 'node must be a scalar for get_nodes_aplinfo()' if ref $a;

    return $self->get( $base, $a, 'aplinfo' )

}

=head2 create_nodes_aplinfo

Create (upload) appliance templates.

  $ok = $obj->download_nodes_aplinfo('node',\%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item storage

String. The storage to be used in pve-storage-id format. Required.

=item template

Data. The actual template. Required.

=back

Note: required permissions are ["perm","/storage/{storage}",["Datastore.AllocateTemplate"]]

=cut

sub create_nodes_aplinfo {

    my $self = shift or return;

    my $a = shift or die 'No node for create_nodes_aplinfo()';
    die 'node must be a scalar for create_nodes_aplinfo()' if ref $a;

    return $self->post( $base, $a, 'aplinfo' )

}

=head2 get_nodes_dns

Get DNS settings.

  $ok = $obj->get_nodes_dns('node')

node is a string in pve-node format

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_dns {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_dns()';
    die 'node must be a scalar for get_nodes_dns()' if ref $a;

    return $self->get( $base, $a, 'dns' )

}

=head2 update_nodes_dns

Updates (writes) DNS settings.

  $ok = $obj->update_nodes_dns('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item search

String. Search domain for host-name lookup. Required.


=back

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub update_nodes_dns {

    my $self = shift or return;

    my $a = shift or die 'No node for update_nodes_dns()';
    die 'node must be a scalar for update_nodes_dns()' if ref $a;

    return $self->put( $base, $a, 'dns' )

}

=head2 get_nodes_rrd

Get nodes RRD statistics (returns PNG).

  $ok = $obj->get_nodes_rrd('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item ds

String. The list of datasources you wish to see, in pve-configid-list format. Required.

=item timeframe

Enum. Is either hour, day, week, month or year. Required.

=item cf

Enum. Is either AVERAGE or MAX. Controls the RRD consolidation function. Optional.

=back

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_rrd {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_rrd()';
    die 'node must be a scalar for get_nodes_rrd()' if ref $a;

    return $self->get( $base, $a, 'rrd' )

}

=head2 get_nodes_rrddata

Get nodes RRD statistics.

  $ok = $obj->get_nodes_rrddata('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item timeframe

Enum. Is either hour, day, week, month or year. Required.

=item cf

Enum. Is either AVERAGE or MAX. Controls the RRD consolidation function. Optional.

=back

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_rrddata {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_rrddata()';
    die 'node must be a scalar for get_nodes_rrddata()' if ref $a;

    return $self->get( $base, $a, 'rrddata' )

}

=head2 get_nodes_status

Gets node status

  $ok = $obj->get_nodes_status('node')

node is a string in pve-node format

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_status {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_status()';
    die 'node must be a scalar for get_nodes_status()' if ref $a;

    return $self->get( $base, $a, 'status' )

}


=head2 updates_nodes_status

Reboot or shutdown a node

  $ok = $obj->updates_nodes_status('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item command

Enum. Either reboot or shutdown. Specifies the command. Required.

=back

Note: required permissions are ["perm","/nodes/{node}",["Sys.PowerMgmt"]]

=cut

sub update_nodes_status {

    my $self = shift or return;

    my $a = shift or die 'No node for update_nodes_status()';
    die 'node must be a scalar for update_nodes_status()' if ref $a;

    return $self->post( $base, $a, 'status' )

}



1;
