#!/usr/bin/env perl

# author: Serguei Okladnikov

use strict;
use warnings;

use Test::More tests => 5;

use File::Temp qw/ tempfile /;
use AnyEvent;
use AnyEvent::Socket;

use constant RUNNING => 'Daemon already running';
use constant STOPPED => 'Daemon is not running';


my $uniq = 'uid_test_str';
my $pid = $$;
my $res;

BEGIN { use_ok( "System::InitD" ) }

diag( "System Process $System::InitD::VERSION" );

my $data;

{
    local $/ = undef;
    $data = <DATA>;
}

my ( undef, $init ) = tempfile( 'tmp_init_XXXXXX', TMPDIR => 1, OPEN => 0 );
my ( undef, $exec ) = tempfile( 'tmp_exec_XXXXXX', TMPDIR => 1, OPEN => 0 );
my ( undef, $sock ) = tempfile( 'tmp_sock_XXXXXX', TMPDIR => 1, OPEN => 0 );
my ( undef, $fpid ) = tempfile( 'tmp_fpid_XXXXXX', TMPDIR => 1, OPEN => 0 );
    
$data =~ s|HOST|unix/|m;
$data =~ s|PORT|$sock|m;
$data =~ s|FPID|$fpid|m;
$data =~ s|UNIQ|$uniq|m;

open FH, ">$exec";
print FH $data;
close FH;

chmod 0755, $exec;


my $options = {
    os           => 'debian',
    target       => $init,
    process_name => $uniq,
    start_cmd    => "$exec 2>&1 &",
    pid_file     => $fpid,
};

require System::InitD::GenInit::Debian;
System::InitD::GenInit::Debian->generate($options);

#
# check whether daemon currently is not running
#
$res = `$init status`; chomp $res;
is $res, STOPPED, 'must be not running';

system "$init start"; sleep 2;

#
# check daemon must be running
#
$res = `$init status`; chomp $res;
is $res, RUNNING, 'must be running';

#
# check whether daemon really worked
#
my $cv = AE::cv;
tcp_connect "unix/", $sock, sub {
    my ($fh) = @_;
    ok $fh, "server is really worked";
    $cv->send;
};
$cv->recv;

system "$init stop"; sleep 2;

#
# check that daemon must be shutdown
#
$res = `$init status`; chomp $res;
is $res, STOPPED, 'must be not running';

unlink $init;
unlink $exec;
unlink $sock;
unlink $fpid;


done_testing();


__DATA__
#!/usr/bin/env perl

use AnyEvent;
use AnyEvent::Socket;

fork && exit;
$0 = 'UNIQ';

my $cv = AE::cv;

my $strm = AE::signal TERM => sub{ $cv->send; };
my $sint = AE::signal INT  => sub{ $cv->send; };
my $shup = AE::signal HUP  => sub{};

my $fpid = 'FPID';
open FH, ">$fpid";
print FH $$;
close FH;

tcp_server 'HOST', 'PORT', sub {
    my ($fh, $host, $port) = @_;
    syswrite $fh, "The internet is full. Go away!\015\012";
};

$cv->recv;
