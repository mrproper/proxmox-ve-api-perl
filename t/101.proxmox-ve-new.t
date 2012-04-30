use strict;
use warnings;

use Test::More; my $tests = 4; # used later
use Test::Trap;

if ( not $ENV{PROXMOX_TEST_URI} ) {
    my $msg = 'This test sucks.  Set $ENV{PROXMOX_TEST_URI} to a real running proxmox to run.';
    plan( skip_all => $msg );
} else {
    plan tests => $tests
}

require_ok('Net::Proxmox::VE')
	or die "# Net::Proxmox::VE not available\n";

my $obj;

=head2 new() dies with bad values

Test that new() dies when bad values are provided

=cut

trap { $obj = Net::Proxmox::VE->new() };
ok($trap->die, 'no arguments dies');

=head2 new() works with good values

This relies on a $ENV{PROXMOX_TEST_URI}.

Try something like...

   PROXMOX_TEST_URI="user:password@192.0.2.28:8006/pam" prove ...

=cut

{

   my ($user, $pass, $host, $port, $realm) =
       $ENV{PROXMOX_TEST_URI} =~ m{^(\w+):(\w+)\@([\w\.]+):(\d+)/(\w+)$}
       or die q|PROXMOX_TEST_URI didnt match form 'user:pass@hostname:port/realm'|."\n";

   trap { 
      $obj = Net::Proxmox::VE->new( host => $host, password => $pass, user => $user, port => $port, realm => $realm )
   };
   ok (! $trap->die, 'doesnt die with good arguments');

}

=head2 login() connects to the server

After the object is created, we should be able to log in ok

=cut

ok($obj->login(), 'logged in to ' . $ENV{PROXMOX_TEST_URI});


__END__
           %args = (
               host     => 'proxmox.local.domain',
               password => 'barpassword',
               user     => 'root', # optional
               port     => 8006,   # optional
               realm    => 'pam',  # optional
           );

