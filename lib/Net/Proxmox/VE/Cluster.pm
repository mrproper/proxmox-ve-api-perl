#!/bin/false

package Net::Proxmox::VE::Cluster;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = 0.1;
our @EXPORT  = qw( cluster );

=encoding utf8

=head1 NAME

Net::Proxmox::VE::Cluster - Functions for the 'cluster' portion of the API

=head1 SYNOPSIS

  # assuming $obj is a Net::Proxmox::VE object


=head1 METHODS

=head2 cluster

Returns the 'Cluster index':

  @list = $obj->cluster()

Note: Accessible by all authententicated users.

=cut

my $base = '/cluster';

sub cluster {

    my $self = shift or return;

    return $self->get($base)

}

=head2 cluster_backup

List vzdump backup schedule.

  @list = $obj->cluster_backup()

Note: Accessible by all authententicated users.

=cut

sub cluster_backup {

    my $self = shift or return;

    return $self->get($base, 'backup')

}

=head2 create_cluster_backup

Create new vzdump backup job.

  $ok = $obj->create_cluster_backup(\%args)

node is a string in pve-node format

I<%args> may items contain from the following list

=over 4

=item starttime

String. Job start time, format is HH::MM. Required.

=item all

Boolean. Backup all known VMs on this host. Required.

=item bwlimit

Integer. Limit I/O bandwidth (KBytes per second). Optional.

=item compress

Enum. Either 0, 1, gzip or lzo. Comress dump file. Optional

=item dow

String. Day of the week in pve-day-of-week-list format. Optional.

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

=item node

String. Only run if executed on this node in pve-node format. Optional.

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

=item stopwait

Integer. Maximal time to wait until a VM is stopped (minutes). Optional.

=item storage

String. Store resulting file to this storage, in pve-storage-id format. Optional.

=item tmpdir

String. Store temporary files to specified directory. Optional.

=item vmid

String. The ID of the VM you want to backup in pve-vm-list format. Optional.

=back

Note: required permissions are ["perm","/",["Sys.Modify"]]

=cut

sub create_cluster_backup {

    my $self = shift or return;

    my $a = shift or die 'No node for create_cluster_backup()';
    die 'node must be a scalar for create_cluster_backup()' if ref $a;

    my @p = @_;

    die 'No arguments for create_cluster_backup()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for create_cluster_backup()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for create_cluster_backup()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->post( $base, 'backup', \%args )

}

=head2 get_cluster_backup

Read vzdump backup job definition.

  $job = $obj->get_cluster_backup('id')

id is the job ID

Note: required permissions are ["perm","/",["Sys.Audit"]]

=cut

sub get_cluster_backup {

    my $self = shift or return;

    my $a = shift or die 'No id for get_cluster_backup()';
    die 'id must be a scalar for get_cluster_backup()' if ref $a;

    return $self->get( $base, $a )

}

=head2 update_cluster_backup

Update vzdump backup job definition.

  $ok = $obj->update_cluster_backup(\%args)

id is the job ID

I<%args> may items contain from the following list

=over 4

=item starttime

String. Job start time, format is HH::MM. Required.

=item all

Boolean. Backup all known VMs on this host. Required.

=item bwlimit

Integer. Limit I/O bandwidth (KBytes per second). Optional.

=item compress

Enum. Either 0, 1, gzip or lzo. Comress dump file. Optional

=item dow

String. Day of the week in pve-day-of-week-list format. Optional.

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

=item node

String. Only run if executed on this node in pve-node format. Optional.

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

=item stopwait

Integer. Maximal time to wait until a VM is stopped (minutes). Optional.

=item storage

String. Store resulting file to this storage, in pve-storage-id format. Optional.

=item tmpdir

String. Store temporary files to specified directory. Optional.

=item vmid

String. The ID of the VM you want to backup in pve-vm-list format. Optional.

=back

Note: required permissions are ["perm","/",["Sys.Modify"]]

=cut

sub update_cluster_backup {

    my $self = shift or return;

    my $a = shift or die 'No id for update_cluster_backup()';
    die 'id must be a scalar for update_cluster_backup()' if ref $a;

    my @p = @_;

    die 'No arguments for update_cluster_backup()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_cluster_backup()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_cluster_backup()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, 'backup', $a, \%args )

}

=head2 delete_cluster_backup

Delete vzdump backup job definition.

  $job = $obj->delete_cluster_backup('id')

id is the job ID

Note: required permissions are ["perm","/",["Sys.Modify"]]

=cut

sub delete_cluster_backup {

    my $self = shift or return;

    my $a = shift or die 'No id for delete_cluster_backup()';
    die 'id must be a scalar for delete_cluster_backup()' if ref $a;

    return $self->delete( $base, $a )

}


1;
