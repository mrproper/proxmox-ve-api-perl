#!/bin/false

package Net::Proxmox::VE;

use Carp qw( croak );
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Headers;
use HTTP::Request::Common qw(GET POST DELETE);
use JSON qw(decode_json);
#use namespace::sweep; # like autoclean, but with no Mooses

=head1 VERSION

VERSION 1.0

=cut

our $VERSION = 1.0;

=head1 NAME

Net::Proxmox::VE - Pure perl API for Proxmox virtualisation

=head1 SYNOPSIS

    use Net::Proxmox::VE;

    %args = (
        host     => 'proxmox.local.domain',
        password => 'barpassword',
        user     => 'root', # optional
        port     => 8006,   # optional
        realm    => 'pam',  # optional


    );

    $host = Net::Proxmox::VE->new(%args);

    $host->login() or die ('Couldnt log in to proxmox host');



=head1 DESCRIPTION

This Class provides the framework for talking to Proxmox VE 2.0 API instances.
This just provides a get/delete/put/post abstraction layer as methods on Proxmox VE REST API
This also handles the ticket headers required for authentication

More details on the API can be found here:
http://pve.proxmox.com/wiki/Proxmox_VE_API
http://pve.proxmox.com/pve2-api-doc/

This class provides the building blocks for someone wanting to use PHP to talk to Proxmox 2.0. Relatively simple piece of code, just provides a get/put/post/delete abstraction layer as methods on top of Proxmox's REST API, while also handling the Login Ticket headers required for authentication.

=head1 METHODS

=cut

sub action {
    my $self = shift || return;
    my %params = @_;

    unless (%params) {
        croak 'new requires a hash for params';
    }
    croak 'path param is required' unless $params{path};

    $params{method}    ||= 'GET';
    $params{post_data} ||= {};

    # Check its a valid method
    unless (
        $params{method}    eq 'GET'
        || $params{method} eq 'PUT'
        || $params{method} eq 'POST'
        || $params{method} eq 'DELETE'
    ){
        croak "invalid http method specified: $params{method}";
    }

    # Strip prefixed / to path if present
    $params{path} =~ s/^\///;

    unless ($self->check_login_ticket) {
        print "DEBUG: invalid login ticket\n"
            if $self->{params}->{debug};
        return unless $self->login();
    }

    my $url = $self->url_prefix . '/api2/json/' . $params{path};

    # Setup the useragent
    my $ua = LWP::UserAgent->new();
    $ua->ssl_opts(verify_hostname => undef); # Add only if test environment here

    # Setup the request object
    my $request = HTTP::Request->new();
    $request->uri($url);
    $request->header('Cookie' => 'PVEAuthCookie=' . $self->{ticket}->{ticket});

    my $response;

    # all methods other than get require the prevention token
    # (ie anything that makes modification)
    unless ($params{method} eq 'GET') {
        $request->header('CSRFPreventionToken' => $self->{ticket}->{CSRFPreventionToken});
    }

    # Not sure why but the php api for proxmox ve uses PUT instead of post for
    # most things, the api doc only lists GET|POST|DELETE and the api returns 'PUT' as
    # an unrecognised method
    # so we'll just force POST from PUT
    if (
        $params{method}    eq 'PUT'
        || $params{method} eq 'POST'
    ) {
        $request->method('POST');
        my $content = join '&', map { $_ . '=' . $params{post_data}->{$_} } sort keys %{$params{post_data}};
        $request->content($content);
        $response = $ua->request($request);
    }
    elsif (
        $params{method}    eq 'GET'
        || $params{method} eq 'DELETE'
    ) {
        $request->method($params{method});
        $response = $ua->request($request);
    }

    if ($response->is_success) {
        print "DEBUG: successful request: " . $request->as_string . "\n"
            if $self->{params}->{debug};

        my $content = $response->decoded_content;
        my $data = decode_json $response->decoded_content;
        # DELETE operations return no data
        # otherwise if we have a data key but its empty, treat it as a failure
        if ($params{method} eq 'DELETE') {
            return 1;
        }
        elsif (
                ref($data) eq 'HASH'
                && exists $data->{data}
        ){
            return $data->{data} || 1;
        }
        else {
            return
        }
    }
    else {
        print "WARNING: request failed: " . $request->as_string . "\n";
        print "WARNING: response status: " . $response->status_line . "\n";
        return
    }
}

=head2 api_version_check

Checks that the api we are talking to is at least version 2.0

Returns true if the api version is at least 2.0 (perl style true or false)

=cut


sub api_version_check {
    my $self = shift || return;

    my $data = $self->action(path => '/version', method => 'GET');

    if (ref $data eq 'HASH'
        && $data{version}
        && $data{version} >= 2.0
    ) {
        return 1;
    }

    return
}

=head2 check_login_ticket

Verifies if the objects login ticket is valid and not expired

Returns true if valid 
Returns false and undefines the login ticket if invalid

=cut

sub check_login_ticket {
    my $self = shift || return;

    if (
        $self->{ticket}
        && ref $self->{ticket} eq 'HASH'
        && $self->{ticket}
        && $self->{ticket}->{ticket}
        && $self->{ticket}->{CSRFPreventionToken}
        && $self->{ticket}->{username} eq $self->{params}->{username} . '@' . $self->{params}->{realm}
        && $self->{ticket_timestamp}
        && $self->{ticket_timestamp} < (time() + $self->{ticket_life})
    ) {
        return 1
    }
    else {
        $self->{ticket} = undef;
        $self->{ticket_timestamp} = undef;
    }

    return
}

=head2 debug

Has a single optional argument of 1 or 0 representing enable or disable debugging.

Undef (ie no argument) leaves the debug status untouched, making this method call simply a query.

Returns the resultant debug status (perl style true or false)

=cut

sub debug {
    my $self = shift || return;
    my $d = shift;

    if ($d) {
        $self->{debug} = 1;
    } elsif ($d ne undef) {
        $self->{debug} = 0;
    }

    return 1 if $self->{debug};
    return

}

=head2 delete

An action helper method that just takes a path as an argument and returns the
value of action with the DELETE method

=cut

sub delete {
    my $self = shift || return;
    my $path = shift || return;

    if ($self->get_node_list) {
        return $self->action(path => $path, method => 'DELETE');
    }
    return
}

=head2 get

An action helper method that just takes a path as an argument and returns the
value of action with the GET method

=cut

sub get {
    my $self = shift || return;
    my $path = shift || return;

    if ($self->get_node_list) {
        return $self->action(path => $path, method => 'GET');
    }
    return
}

=head2 get_node_list

Returns the clusters node list from the object,
if thats not defined it calls reload_node_list and returns the node_list

=cut
sub get_node_list {
    my $self = shift || return;

    if ($self->{node_list}) {
        return $self->{node_list};
    }
    elsif ($self->reload_node_list) {
        return $self->{node_list};
    }

    return
}

=head2 login

Initiates the log in to the PVE Server using JSON API, and potentially obtains an Access Ticket.

Returns true if success

=cut

sub login {
    my $self = shift || return;

    # Prepare login request
    my $url = $self->url_prefix . '/api2/json/access/ticket';

    my $ua = LWP::UserAgent->new();
    $ua->ssl_opts(verify_hostname => undef); # Add only if test environment here

    # Perform login request
    my $request_time = time();
    my $response = $ua->post(
        $url,
        {
            'username' => $self->{params}->{username} . '@' . $self->{params}->{realm},
            'password' => $self->{params}->{password},
        },
    );

    if ($response->is_success) {
        my $content = $response->decoded_content;
            my $login_ticket_data = decode_json $response->decoded_content;
            $self->{ticket} = $login_ticket_data->{data};
            # We use request time as the time to get the json ticket is undetermined,
            # id rather have a ticket a few seconds shorter than have a ticket that incorrectly
            # says its valid for a couple more
            $self->{ticket_timestamp} = $request_time;
            print "DEBUG: login successful\n"
                if $self->{params}->{debug};
            return 1;
    }

    print "DEBUG: login not successful\n"
        if $self->{params}->{debug};

    return

}

=head2 new

Creates the Net::Proxmox::VE object and returns it.

Examples...

  my $obj = Net::Proxmox::VE->new(%args);
  my $obj = Net::Proxmox::VE->new(\%args);

Valid arguments are...

=over 4

=item I<host>

Proxmox host instance to interact with. Required so no default.

=item I<username>

User name used for authentication. Defaults to 'root', optional.

=item I<password>

Pass word user for authentication. Required so no default.

=item I<port>

TCP port number used to by the Proxmox host instance. Defaults to 8006, optional.

=item I<realm>

Authentication realm to request against. Defaults to 'pam' (local auth), optional.

=item I<debug>

Enabling debugging of this API (not related to proxmox debugging in any way). Defaults to false, optional.

=back

=cut

sub new {

    my $c = shift;
    my @p = @_;
    my $class = ref($c) || $c;

    my %params;

    if (scalar @p == 1) {

        croak 'new() requires a hash for params'
            unless ref $p[0] eq 'HASH';

        %params = %{$p[0]};

    } elsif (scalar @p % 2 != 0) { # 'unless' is better than != but anyway
        croak 'new() called with an odd number of parameters'

    } else {
        %params = @p
            or croak 'new() requires a hash for params';
    }

    croak 'host param is required'     unless $params{'host'};
    croak 'password param is required' unless $params{'password'};

    $params{port}     ||= 8006;
    $params{username} ||= 'root';
    $params{realm}    ||= 'pam';
    $params{debug}    ||= undef;

    my $self->{params}          = \%params;
    $self->{'ticket'}           = undef;
    $self->{'ticket_timestamp'} = undef;
    $self->{'ticket_life'}      = 7200; # 2 Hours

    bless $self, $class;
    return $self

}

=head2 post

An action helper method that takes two parameters:
path
hash ref to post data
your returned what action with the POST method returns

=cut
sub post {
    my $self      = shift || return;
    my $path      = shift || return;
    my $post_data = shift || return;

    if ($self->get_node_list) {
        return $self->action(path => $path, method => 'POST', post_data => $post_data);
    }
    return;
}

=head2 put

An action helper method that takes two parameters:
path
hash ref to post data
your returned what post returns 

=cut
sub put {
    my $self = shift;
    return $self->post(@_);
}

=head2 reload_node_list

gets and sets the list of nodes in the cluster into $self->{node_list}
returns false if there is no nodes listed or an arrayref is not returns from action

=cut
sub reload_node_list {
    my $self = shift || return;

    my $node_list = $self->action(path => '/nodes', method => 'GET');
    if (
        ref $node_list eq 'ARRAY'
        && @{$node_list} > 0
    ){
        $self->{node_list} = $node_list;
        return 1;
    }

    print "ERROR: empty list of nodes in this cluster.\n";

    return
}

=head2 url_prefix

returns the url prefix used in the rest api calls

=cut
sub url_prefix {
    my $self = shift || return;

    # Prepare login request
    my $url_prefix = 'https://'
        . $self->{params}->{host}
        . ':'
        . $self->{params}->{port};

    return $url_prefix
}
=head1 SEE ALSO

=head1 SUPPORT

=head1 AUTHORS

Brendan Beveridge <brendan@nodeintegration.com.au>,
Dean Hamstead <dean@fragfest.com.au>

=cut

1
