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

    my @p = @_;

    die 'No arguments for update_nodes_dns()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_nodes_dns()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_nodes_dns()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, $a, 'dns', \%args )

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

    my @p = @_;

    die 'No arguments for update_nodes_status()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_nodes_status()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_nodes_status()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->post( $base, $a, 'status', \%args )


}

=head2 get_nodes_subscription

Read nodes subscription info

  $ok = $obj->get_nodes_subscription('node')

node is a string in pve-node format

Note: Root only.

=cut

sub get_nodes_subscription {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_subscription()';
    die 'node must be a scalar for get_nodes_subscription()' if ref $a;

    return $self->get( $base, $a, 'subscription' )

}

=head2 create_nodes_subscription

Create/update nodes subscription info

  $ok = $obj->create_nodes_subscription('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item force

Boolean. Always connect to the server, even if we have up to date info inside local cache. Optional.

=back

Note: Root only.

=cut

sub create_nodes_subcription {

    my $self = shift or return;

    my $a = shift or die 'No node for create_nodes_subcription()';
    die 'node must be a scalar for create_nodes_subcription()' if ref $a;

    my @p = @_;

    die 'No arguments for create_nodes_subcription()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for create_nodes_subcription()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for create_nodes_subcription()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->post( $base, $a, 'subscription', \%args )

}

=head2 update_nodes_subscription_key

Updates/sets subscription key

  $ok = $obj->update_nodes_subscription_key('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item key

Boolean. Proxmox VE subscription key. Required.

=back

Note: Root only.

=cut

sub update_nodes_subscription_key {

    my $self = shift or return;

    my $a = shift or die 'No node for update_nodes_subscription_key()';
    die 'node must be a scalar for update_nodes_subscription_key()' if ref $a;

    my @p = @_;

    die 'No arguments for update_nodes_subscription_key()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_nodes_subscription_key()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_nodes_subscription_key()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, $a, 'subscription', \%args )

}

=head2 get_nodes_syslog

Reads system log

  $ok = $obj->get_nodes_syslog('node', \%args)

node is a string in pve-node format

Note: required permissions are ["perm","/nodes/{node}",["Sys.Syslog"]]

=cut

sub get_nodes_syslog {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_syslog()';
    die 'node must be a scalar for get_nodes_syslog()' if ref $a;

    my @p = @_;

    die 'No arguments for get_nodes_syslog()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for get_nodes_syslog()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for get_nodes_syslog()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, $a, 'syslog', \%args )

}

=head2 get_nodes_time

Read server time and time zone settings

  $ok = $obj->get_nodes_time('node')

node is a string in pve-node format

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_time {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_time()';
    die 'node must be a scalar for get_nodes_time()' if ref $a;

    return $self->get( $base, $a, 'time' )

}

=head2 update_nodes_time

Updates time zone

  $ok = $obj->update_nodes_time('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item timezone

String. Time zone to be used, see '/usr/share/zoneinfo/zone.tab'. Required.

=back

Note: required permissions are ["perm","/nodes/{node}",["Sys.Modify"]]

=cut

sub update_nodes_time {

    my $self = shift or return;

    my $a = shift or die 'No node for update_nodes_time()';
    die 'node must be a scalar for update_nodes_time()' if ref $a;

    my @p = @_;

    die 'No arguments for update_nodes_time()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_nodes_time()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_nodes_time()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, $a, 'time', \%args )

}

=head2 get_nodes_ubcfailcnt

Get user_beancounters failcnt for all active containers.

  $ok = $obj->get_nodes_ubcfailcnt('node')

node is a string in pve-node format

Note: required permissions are ["perm","/nodes/{node}",["Sys.Audit"]]

=cut

sub get_nodes_ubcfailcnt {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_ubcfailcnt()';
    die 'node must be a scalar for get_nodes_ubcfailcnt()' if ref $a;

    return $self->get( $base, $a, 'ubcfailcnt' )

}

=head2 get_nodes_version

Get user_beancounters failcnt for all active containers.

  $ok = $obj->get_nodes_version('node')

node is a string in pve-node format

Note: Accessible by all authententicated users.

=cut

sub get_nodes_version {

    my $self = shift or return;

    my $a = shift or die 'No node for get_nodes_version()';
    die 'node must be a scalar for get_nodes_version()' if ref $a;

    return $self->get( $base, $a, 'version' )

}

=head2 create_nodes_vncshell

Creates a VNC Shell proxy.

  $ok = $obj->create_nodes_vncshell('node')

node is a string in pve-node format

Note: Restricted to users on realm 'pam'. Required permissions are  ["perm","/nodes/{node}",["Sys.Console"]]

=cut

sub create_nodes_vncshell {

    my $self = shift or return;

    my $a = shift or die 'No node for create_nodes_vncshell()';
    die 'node must be a scalar for create_nodes_vncshell()' if ref $a;

    return $self->post( $base, $a, 'vncshell' )

}

=head2 create_nodes_vzdump

Create backup.

  $ok = $obj->create_nodes_vzdump('node', \%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item all

Boolean. Backup all known VMs on this host. Optional.

=item bwlimit

Integer. Limit I/O bandwidth (KBytes per second). Optional.

=item compress

Enum. Either 0, 1, gzip or lzo. Comress dump file. Optional

=item dumpdir

String. Store resulting files to specified directory. Optional.

=item exclude

String. Exclude specified VMs (assumes --all) in pve-vmid-list. Optional.

=item exclude-path

String. Exclude certain files/directories (regex) in string-alist. Optional.

=item ionice

Integer. Set CFQ ionice priority. Optional.

=item lockwait

Integer. Maximal time to wait for the global lock (minutes). Optional.

=item mailto

String. List of email addresses in string-list format. Optional.

=item maxfiles

Integer. Maximal number of backup files per vm. Optional.

=item mode

Enum. A value from snapshot, suspend or stop. Backup mode. Optional.

=item quiet

Boolean. Be quiet. Optional.

=item remove

Boolean. Remove old backup files if there are more than 'maxfiles' backup files. Optional.

=item script

String. Use specified hook script. Optional.

=item size

Integer. LVM snapshot size in MB. Optional.

=item stdexcludes

Boolean. Exclude temporary files and logs. Optional.

=item stdout

Boolean. Write tar to stdout rather than to a file. Optional.

=item stopwait

Integer. Maximal time to wait until a VM is stopped (minutes). Optional.

=item storage

String. Store resulting file to this storage, in pve-storage-id format. Optional.

=item tmpdir

String. Store temporary files to specified directory. Optional.

=item vmid

String. The ID of the VM you want to backup in pve-vm-list format. Optional.

=back

Note: The user needs 'VM.Backup' permissions on any VM, and 'Datastore.AllocateSpace' on the backup storage.

=cut

sub create_nodes_vzdump {

    my $self = shift or return;

    my $a = shift or die 'No node for create_nodes_vzdump()';
    die 'node must be a scalar for create_nodes_vzdump()' if ref $a;

    my @p = @_;

    die 'No arguments for create_nodes_vzdump()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for create_nodes_vzdump()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for create_nodes_vzdump()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->post( $base, $a, 'dns', \%args )

}




1;
