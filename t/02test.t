#!/usr/bin/env perl
use strict;
use warnings;

use Data::Dumper;
use File::Temp qw/tempfile/;
use Cwd;

use Test::More tests => 7;

my $cwd = getcwd;
my @cwd = split '\/', $cwd;
$cwd[$#cwd] = 'tmp';
$cwd = join '/', @cwd;
$cwd =~ s/\/$//;


# 1: use System::InitD
use_ok 'System::InitD' or BAIL_OUT "Can't use System::InitD";

# 2: use System::InitD::Debian
use_ok 'System::InitD::Debian' or BAIL_OUT "Can't use System::InitD::Debian";

my $PROCESS_NAME   =  'SYSTEM_INITD_TEST_PROCESS';
my $TEMP_DIR       =  $cwd;

my $DAEMON_FILE    =  $cwd . '/daemon';
my $INIT_SCRIPT    =  $cwd . '/init_script';
my $PID_FILE       =  $cwd . '/test.pid';
my $RUNNING        =  'Daemon already running'; 
my $NOT_RUNNING    =  'Daemon is not running';


# exit 1;
my $script = sprintf join ('', <DATA>), $PROCESS_NAME, $PID_FILE;
open DAEMON, '>', $DAEMON_FILE;
print DAEMON $script;
close DAEMON;


my $options = {
    os              =>  'debian',
    target          =>  $INIT_SCRIPT,
    pid_file        =>  $PID_FILE,
    start_cmd       =>  $DAEMON_FILE . ' &',
    process_name    =>  $PROCESS_NAME,
};

require System::InitD::Debian;
import System::InitD::Debian;
System::InitD::Debian::generate($options);

# 3:
ok -e $DAEMON_FILE && -s $DAEMON_FILE, 'Daemon file exists and not empty';

# 4:
ok -e $PID_FILE && -s $PID_FILE, 'PID file exists and not empty';

# 5:
ok -e $INIT_SCRIPT && -s $INIT_SCRIPT, 'Init script exists and not empty';

# 6:
is `$INIT_SCRIPT status`, $NOT_RUNNING, 'Not running';

system $INIT_SCRIPT, 'start';
sleep 2;

# 7:
is `$INIT_SCRIPT status`, $RUNNING, 'Running';

system "$INIT_SCRIPT", 'stop';

__DATA__
#!/usr/bin/env perl
use strict;
use warnings;
$0 = '%s';
open PID, '>', '%s';
print PID $$;
close PID;

eval {
    local $SIG{ALRM} = sub {
        die "ALARM!";
    };
    alarm 10;
    while (1) {
        sleep 1;
    }

} or do {
    die "Done";
};

1;