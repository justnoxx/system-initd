package System::InitD::Base;

use strict;
use warnings;

use Template;

use Carp;
use Data::Dumper;

sub new {
    my ($class, $options) = @_;

    my $self = {
        _options     =>  $options,
        _rp          =>  {},
    };
    return bless $self, $class;
}


sub set_render_params {
    my ($self, $params) = @_;

    croak "Missing params" unless $params;

    $self->{_rp} = $params;
}


sub _rp {
    my $self = shift;

    return $self->{_rp};
}


sub forward_render_params {
    my ($self, $params, @allowed) = @_;
    
    return 0 if (!$params || ! scalar @allowed);
    # allowed paarams
    my $ap;
    %$ap = map{($_, 1)}@allowed;
    
    for my $k (keys %$params) {
        if (defined $ap->{$k} && $ap->{$k}) {
            $self->{_rp}->{$k} = $params->{$k};
        }
    }

    return 1;
}


sub write_script {
    my ($self, $template) = @_;

    my $tt = Template->new({ABSOLUTE=>1}) || croak "$Template::ERROR\n";
    my $script;
    $tt->process($template, $self->_rp(), \$script) || croak $tt->error();

    my $target = $self->{_options}->{target};
    croak "Missing target" unless $target;

    open TARGET, '>', $target or croak "Can't write target";
    print TARGET $script;
    close TARGET;

    chmod 0755, $target;
    return 1;
}


1;

__END__
