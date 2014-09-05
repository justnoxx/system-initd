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
/;

use constant DAEMON_ALREADY_RUNNING => "Daemon already running\n";
use constant DAEMON_IS_NOT_RUNNING  => "Daemon is not running\n";

1;

__END__

