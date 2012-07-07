#!/bin/false

package Net::Proxmox::VE::Access;

use strict;
use warnings;
use base 'Exporter';

use LWP::UserAgent;

our $VERSION = 0.1;
our @EXPORT = qw( access access_domains );

=encoding utf8

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

=cut

my $base = '/access';

sub access {

    my $self = shift or return;

    return $self->get($base);

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


=head2 check_login_ticket

Verifies if the objects login ticket is valid and not expired

Returns true if valid
Returns false and clears the the login ticket details inside the object if invalid

=cut

sub check_login_ticket {

    my $self = shift or return;

    if (   $self->{ticket}
        && ref $self->{ticket} eq 'HASH'
        && $self->{ticket}
        && $self->{ticket}->{ticket}
        && $self->{ticket}->{CSRFPreventionToken}
        && $self->{ticket}->{username} eq $self->{params}->{username} . '@'
        . $self->{params}->{realm}
        && $self->{ticket_timestamp}
        && $self->{ticket_timestamp} < ( time() + $self->{ticket_life} ) )
    {
        return 1
    }
    else {
        $self->clear_login_ticket;
    }

    return

}

=head2 clear_login_ticket

Clears the login ticket inside the object

=cut

sub clear_login_ticket {

    my $self = shift or return;

    if ( $self->{ticket} or $self->{timestamp} ) {
        $self->{ticket}           = undef;
        $self->{ticket_timestamp} = undef;
        return 1
    }

    return

}

=head2 get_acl

The returned list is restricted to objects where you have rights to modify permissions

  $pool = $obj->get_acl();

=cut

sub get_acl {

    my $self = shift or return;

    return $self->get( $base, 'acl' );

}

=head2 login

Initiates the log in to the PVE Server using JSON API, and potentially obtains an Access Ticket.

Returns true if success

=cut

sub login {
    my $self = shift or return;

    # Prepare login request
    my $url = $self->url_prefix . '/api2/json/access/ticket';

    my $ua = LWP::UserAgent->new( ssl_opts => { verify_hostname => undef } );
    $self->{ua} = $ua;

    # Perform login request
    my $request_time = time();
    my $response     = $ua->post(
        $url,
        {
            'username' => $self->{params}->{username} . '@'
              . $self->{params}->{realm},
            'password' => $self->{params}->{password},
        },
    );

    if ( $response->is_success ) {
        my $content           = $response->decoded_content;
        my $login_ticket_data = decode_json( $response->decoded_content );
        $self->{ticket} = $login_ticket_data->{data};

        # We use request time as the time to get the json ticket is undetermined,
        # id rather have a ticket a few seconds shorter than have a ticket that incorrectly
        # says its valid for a couple more
        $self->{ticket_timestamp} = $request_time;
        print "DEBUG: login successful\n"
          if $self->{params}->{debug};
        return 1;
    }
    else {

        print "DEBUG: login not successful\n"
          if $self->{params}->{debug};

    }

    return;
}

=head2 update_acl

Updates (sets) an acl's data

  $ok = $obj->update_acl( %args );
  $ok = $obj->update_acl( \%args );

I<%args> may items contain from the following list

=over 4

=item path

String. Access control path. Required.

=item roles

String. List of roles. Required.

=item delete

Boolean. Removes the access rather than adding it. Optional.

=item groups

String. List of groups. Optional.

=item propagate

Boolean. Allow to propagate (inherit) permissions. Optional.

=item users

String. List of users. Optional.

=back

=cut

sub update_acl {

    my $self   = shift or return;
    my @p = @_;

    die 'No arguments for update_acl()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_acl()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_acl()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, 'acl', \%args );

}


=head2 update_password

Updates a users password

  $ok = $obj->update_password( %args );
  $ok = $obj->update_password( \%args );

Each user is allowed to change his own password. See proxmox api document for which permissions are needed to change the passwords of other people.

I<%args> may items contain from the following list

=over 4

=item password

String. The new password. Required.

=item userid

String. User ID. Required.

=back

=cut

sub update_password {

    my $self   = shift or return;
    my @p = @_;

    die 'No arguments for update_password()' unless @p;
    my %args;

    if ( @p == 1 ) {
        die 'Single argument not a hash for update_password()'
          unless ref $a eq 'HASH';
        %args = %{ $p[0] };
    }
    else {
        die 'Odd number of arguments for update_password()'
          if ( scalar @p % 2 != 0 );
        %args = @p;
    }

    return $self->put( $base, 'password', \%args );

}



=head1 SEE ALSO

  L<Net::Proxmox::VE>

=head1 VERSION

  VERSION 0.1

=head1 AUTHORS

  Brendan Beveridge L<<brendan@nodeintegration.com.au>>
  Dean Hamstead L<<dean@fragfest.com.au>>

=cut

1
