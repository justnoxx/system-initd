package System::InitD;

=head1 NAME

System::InitD

=head1 DESCRIPTION

Набор решений для работы и построения init.d скриптов под разные ОС.
Подробное описание в процессе
Changelog внизу

=head1 CHANGES

<B>1.0

Параметр start теперь больше не hashref, теперь это строка. Где команда, а где
аргументы System::InitD разберется сам.

<B>0.9

Интегрирован System::Process

=cut

use strict;
use warnings;

use System::InitD::Runner;

our $VERSION = 1.01;

1;

__END__

