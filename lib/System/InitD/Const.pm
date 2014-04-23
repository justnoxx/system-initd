package System::InitD::Const;

=head1 NAME

System::InitD::Const

=head1 DESCRIPTION

Constants bundle for System::InitD package

=head1 CONSTANTS

=cut

use strict;
use warnings;

use Exporter;

our @EXPORT_OK = qw/
    DAEMON_ALREADY_RUNNING
    DAEMON_NOT_RUNNING
/;

use constant DAEMON_ALREADY_RUNNING => "Daemon already running";
use constant DAEMON_IS_NOT_RUNNING  => "Daemon is not running";

1;

__END__

