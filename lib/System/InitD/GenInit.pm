package System::InitD::GenInit;

use strict;
use warnings;
use Getopt::Long;
use Carp;


sub new {
    my $class = shift;

    return bless {}, $class;
}


sub run {
    my $self = shift;

    $self->parse_args();
    
    eval {
        my $os = ucfirst lc $self->{options}->{os};

        my $module = 'System::InitD::GenInit' . '::' . $os;

        (my $file = $module) =~ s|::|/|g;
        require $file . '.pm';
        $module->import();
        $module->generate($self->{options});
        1;
    } or do {
        croak "Unknown OS: $@";
    };

    1;
};


sub parse_args {
    my $self = shift;

    my $opts = $self->{options} = {
        author          =>  getlogin,
        os              =>  'debian',
        process_name    =>  '',
        start_cmd       =>  '',
        pid_file        =>  '',
        target          =>  '',
        provides        =>  '',
        service         =>  'system_initd_script',
        description     =>  '',
    };

    GetOptions(
        'os=s'              =>    \$opts->{os},
        'target=s'          =>    \$opts->{target},
        "author=s"          =>    \$opts->{author},
        'pid-file=s'        =>    \$opts->{pid_file},
        'pid_file=s'        =>    \$opts->{pid_file},
        'process_name=s'    =>    \$opts->{process_name},
        'process-name=s'    =>    \$opts->{process_name},
        'start_cmd=s'       =>    \$opts->{start_cmd},
        'start-cmd=s'       =>    \$opts->{start_cmd},
        'provides=s'        =>    \$opts->{provides},
        'service=s'         =>    \$opts->{service},
        'description=s'     =>    \$opts->{description},
    );

    if (scalar @ARGV == 1 && !$self->{options}->{target}) {
        $self->{options}->{target} = $ARGV[0];
    }

    return 1;
}


1;

__END__

