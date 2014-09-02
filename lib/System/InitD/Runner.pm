package System::InitD::Runner;

=head NAME

System::InitD::Runner

=head1 DESCRIPTION

Simple module to process common init.d tasks.
init.d bash scripts replacement

=head1 AUTHOR

Dmitriy @justnoxx Shamatrin

=head1 USAGE

=cut

use strict;
use warnings;
no warnings qw/once/;

use Carp;
use System::Process;
use POSIX;
use Time::HiRes;

use System::InitD::Const;
use System::InitD::Base;
use System::InitD::Const;

=over

=item B<new>

new(%)

Constructor, params:

B<start>

A start command

B<usage>

Usage line, called by script usage

B<daemon_name>

Now unused, reserved for output format

B<restart_timeout>

Timeout between stop and start in restart

B<pid_file>

Path to pid file, which used for monitoring

B<process_name>

B<EXACT> daemon process name. Need for preventing wrong kill.

B<kill_signal>

Signal, which used for daemon killing.

=back

=cut


sub new {
    my ($class, %params) = @_;
    my $self = {};

    if (!$params{start}) {
        croak "Start param is required";
    }

    if (!$params{usage}) {
        croak 'Usage must be specified';
    }

    if ($params{daemon_name}) {
        $self->{daemon_name} = $params{daemon_name};
    }

    else {
        $self->{_text}->{usage} = $params{usage};
    }

    # Command is array from now, for system
    @{$self->{_commands}->{start}} = split /\s+/, $params{start};

    if ($params{restart_timeout}) {
        $self->{_args}->{restart_timeout} = $params{restart_timeout};
    }

    if ($params{pid_file}) {
        $self->{pid} = System::Process::pidinfo(
            file    =>  $params{pid_file}
        );
    }

    if ($params{kill_signal}) {
        $self->{_args}->{kill_signal} = $params{kill_signal};
    }

    if ($params{process_name}) {
        $self->{_args}->{process_name} = $params{process_name};
    }

    # user and group params, added for right validation
    if ($params{user}) {
        $self->{_args}->{user} = $params{user};
    }
    if ($params{group}) {
        $self->{_args}->{group} = $params{group};
    }

    bless $self, $class;
    return $self;
}


=over

=item B<run>

Runner itself, service sub

=back

=cut

sub run {
    my $self = shift;
    unless ($ARGV[0]) {
        $self->usage();
        return 1;
    }

    if ($self->can($ARGV[0])) {
        my $sub = $ARGV[0];
        $self->$sub();
    }
    else {
        $self->usage();
    }
    return 1;
}


sub start {
    my $self = shift;

    $self->before_start();
    # TODO: Add command check
    my @command = @{$self->{_commands}->{start}};
    if ($self->is_alive()) {
        print DAEMON_ALREADY_RUNNING;
        return;
    }
    system(@command);
    $self->after_start();
    return 1;
}


sub stop {
    my $self = shift;

    $self->confirm_permissions() or croak "Incorrect permissions. Can't kill";

    $self->before_stop();
    if ($self->{pid}) {
        my $signal = $self->{kill_signal} // POSIX::SIGTERM;
        $self->{pid}->kill($signal);
    }

    $self->after_stop();
    return 1;
}


sub restart {
    my $self = shift;

    $self->stop();

    while ($self->is_alive()) {
        Time::HiRes::usleep(1000);
    }

    $self->start();
    return 1;
}


sub status {
    my $self = shift;

    unless ($self->{pid}) {
        print DAEMON_IS_NOT_RUNNING;
        exit 0;
    }

    if ($self->is_alive()) {
        print DAEMON_ALREADY_RUNNING;
    }

    exit 0;
}


sub usage {
    my $self = shift;

    print $self->{_text}->{usage}, "\n";
    return 1;
}


sub is_alive {
    my $self = shift;
    return 0 unless $self->{pid};

    return 1 if $self->{_args}->{process_name} eq $self->{pid}->command() && $self->{pid}->cankill();

    return 0;
}


=over

=item B<load>

load($,\&)

Loads additional actions to init script, for example, add `script hello` possible via:

$runner->load('hello', sub {print 'Hello world'})

=back

=cut

sub load {
    my ($self, $subname, $subref) = @_;

    if (!$subname || !$subref) {
        croak 'Missing params';
    }

    croak 'Subref must be a CODE ref' if (ref $subref ne 'CODE');

    no strict 'refs';
    *{__PACKAGE__ . "\::$subname"} = $subref;
    use strict 'refs';

    return 1;
}


sub confirm_permissions {
    my ($self) = @_;

    if (!exists $self->{pid}) {
        carp 'Usage of System::InitD without pidfile is deprecated ' .
            'and will be forbidden in the future releases';
        return 1;
    }

    unless ($self->{_args}->{user}) {
        carp 'Usage of System::InitD without specified user is extremely insecure ' .
            'and will be forbidden in the future releases';
        return 1;
    }

    if ($self->{_args}->{user} ne $self->{pid}->user()) {
        carp "Expected: $self->{_args}->{user}, but got: " . $self->{pid}->user()
            . " looks like very strange. Execution was aborted.";
        return 0;
    }

    return 1;
}

sub before_start {1;}
sub after_start {1;}

sub before_stop {1;}
sub after_stop {1;}


1;

__END__
