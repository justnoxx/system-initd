package System::InitD::Debian;

use strict;
use warnings;

use Template;
use File::ShareDir;

use constant TEMPLATE => 'debian.tt';

sub generate {
	my $data_location = dist_file('System-InitD', TEMPLATE);
	print "Location: $data_location\n";
};

1;

__END__