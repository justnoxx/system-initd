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
    
    if (lc $self->{options}->{os} eq 'debian') {
        require System::InitD::Debian;
        System::InitD::Debian::generate($self->{options});
    }
    else {
        croak 'Unknown OS';
    }

    1;
};


sub parse_args {
    my $self = shift;

    my $opts = $self->{options} = {
        author  =>  getlogin,
        os      =>  'debian',
    };

    GetOptions(
        'os=s'            =>  \$opts->{os},
        'target=s'        =>  \$opts->{target},
        "author=s"        =>  \$opts->{author},
        'pid-file=s'      =>  \$opts->{pid_file},
        'pid_file=s'      =>  \$opts->{pid_file},
        'process_name=s'  =>  \$opts->{process_name},
        'start_cmd=s'     =>  \$opts->{start_cmd},
        'start-cmd=s'     =>  \$opts->{start_cmd},
    );

    if (scalar @ARGV == 1 && !$self->{options}->{target}) {
        $self->{options}->{target} = $ARGV[0];
    }

    return 1;
}


1;

__END__

