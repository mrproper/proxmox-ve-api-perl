#!/usr/bin/perl

use warnings;
use strict;
use Module::Build;
my $build = Module::Build->new(
    dist_name => q|Net::Proxmox|,
    dist_author => q|Brendan Beveridge <brendan@nodeintegration.com.au>, Dean Hamstead <dean@fragfest.com.au>|,
    license => q|perl|,
    module_name => q|Net::Proxmox|,
    requires    => {
        Carp       => 0,
        JSON       => 0,
        'LWP::UserAgent' => 0,
        'HTTP::Headers' => 0,
    },
    build_requires => {
    #    'Test::Trap' => 0,
    },
);
$build->create_build_script();
