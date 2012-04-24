package Net::Proxmox::VE;
use Carp qw( croak );
use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Headers;
use JSON qw(decode_json);

sub new {
    my $class = shift;
    my %params = @_;

    unless (%params) {
        croak "new requires a hash for params";
    }
    croak "host param is required"     unless $params{'host'};
    croak "password param is required" unless $params{'password'};

    $params{port}     ||= 8006;
    $params{username} ||= 'root';
    $params{realm}    ||= 'pam';
    $params{debug}    ||= 0; # XXX do something with this

    my $self->{params}          = \%params;
    $self->{'ticket'}           = undef;
    $self->{'ticket_timestamp'} = undef;
    $self->{'ticket_life'}      = 7200; # 2 Hours

    bless $self, $class;
    return $self;
}
sub url_prefix {
    my $self = shift || return;

    # Prepare login request
    my $url_prefix = 'https://'
        . $self->{params}->{host}
        . ':'
        . $self->{params}->{port};

    return $url_prefix;
}

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
        [
            'username' => $self->{params}->{username} . '@' . $self->{params}->{realm},
            'password' => $self->{params}->{password},
        ],
    );

    if ($response->is_success) {
        my $content = $response->decoded_content;
            my $login_ticket_data = decode_json $response->decoded_content;
            $self->{ticket} = $login_ticket_data->{'data'};
            # We use request time as the time to get the json ticket is undetermined,
            # id rather have a ticket a few seconds shorter than have a ticket that incorrectly
            # says its valid for a couple more
            $self->{ticket_timestamp} = $request_time;
            return 1;
    }
    else {
        return 0;
    }
    
}

sub check_login_ticket {
    my $self = shift || return;

    if (
        $self->{ticket}
        && ref $self->{ticket} eq ref {}
        && $self->{ticket}
        && $self->{ticket}->{'ticket'}
        && $self->{ticket}->{'CSRFPreventionToken'}
        && $self->{ticket}->{'username'} eq $self->{params}->{username} . '@' . $self->{params}->{realm}
        && $self->{ticket_timestamp}
        && $self->{ticket_timestamp} < (time() + $self->{ticket_life})
    ) {
        return 1;
    }
    else {
        $self->{ticket} = undef;
        $self->{ticket_timestamp} = undef;
    }
}


sub action {
    my $self = shift || return;
    my %params = @_;

    unless (%params) {
        croak "new requires a hash for params";
    }
    croak "path param is required"     unless $params{'path'};
    
    $params{method} ||= 'GET';
    $params{post_params} ||= {};


    # Check its a valid method
    unless (
        $params{method} eq 'GET'
        || $params{method} eq 'PUT'
        || $params{method} eq 'POST'
        || $params{method} eq 'DELETE'
    ){
        croak "invalid http method specified: $params{method}";
    }

    # Strip prefixed / to path if present
    $params{path} =~ s/^\///;
        
    unless ($self->check_login_ticket) {
        print "DEBUG: here1\n";
        return 0 unless $self->login();
    }

    print "DEBUG: here2\n";
    my $url = $self->url_prefix . '/api2/json/' . $params{path};

    my $response;
    my $header_obj = HTTP::Headers->new();
    $header_obj->header('Cookie' => 'PVEAuthCookie=' . $self->{ticket}->{ticket});
    my $ua = LWP::UserAgent->new();
    $ua->ssl_opts(verify_hostname => undef); # Add only if test environment here
    $ua->default_headers($header_obj);

    if ($params{method} eq 'PUT') {
        # XXX add post data
        $header_obj->header('CSRFPreventionToken' => $self->{ticket}->{CSRFPreventionToken});
        $response = $ua->post(
            $url,
            
        );
    }
    elsif ($params{method} eq 'POST') {
        # XXX add post data
        $header_obj->header('CSRFPreventionToken' => $self->{ticket}->{CSRFPreventionToken});
        $response = $ua->post($url);
    }
    elsif ($params{method} eq 'DELETE') {
        # XXX add post data
        $header_obj->header('CSRFPreventionToken' => $self->{ticket}->{CSRFPreventionToken});
        $response = $ua->delete($url);
    }
    elsif ($params{method} eq 'GET') {
        $response = $ua->get($url);
    }

    if ($response->is_success) {
        my $content = $response->decoded_content;
            my $data = decode_json $response->decoded_content;
            use Data::Dumper;
            print Dumper $data;
            return 1;
    }
    else {
        print $response->status_line;
        print $response->request->as_string;
        print "DEBUG: bad\n";
        return 0;
    }
}

sub reload_node_list {
    #XXX todo
}

sub get_node_list {
    #XXX todo
}

sub get {
    #XXX todo
}

sub put {
    #XXX todo
}

sub post {
    #XXX todo
}

sub delete {
    #XXX todo
}

1;
