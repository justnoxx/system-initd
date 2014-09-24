package System::InitD::Const;

=head1 NAME

System::InitD::Const

=head1 DESCRIPTION

Constants bundle for System::InitD package

=head1 CONSTANTS

=cut

use strict;
use warnings;

use base qw/Exporter/;

our @EXPORT = qw/
    DAEMON_ALREADY_RUNNING
    DAEMON_IS_NOT_RUNNING
    STARTING
    STARTED
    NOT_STARTED
    STOPPING
    STOPPED
    NOT_STOPPED
/;

use constant DAEMON_ALREADY_RUNNING => "Daemon already running\n";
use constant DAEMON_IS_NOT_RUNNING  => "Daemon is not running\n";
use constant STARTING       =>  "Starting...\n";
use constant STARTED        =>  "Started.\n";
use constant NOT_STARTED    =>  "Not started: %s\n";

use constant STOPPING       =>  "Stopping...\n";
use constant STOPPED        =>  "Stopped.\n";
use constant NOT_STOPPED    =>  "Not stopped\n";
1;

__END__

