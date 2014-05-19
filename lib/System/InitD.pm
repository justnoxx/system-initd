package System::InitD;

=head1 NAME

System::InitD

=head1 DESCRIPTION

Набор решений для работы и построения init.d скриптов под разные ОС.

Для более подробного описания geninit:

	perldoc geninit

Для подробного описания System::InitD::Runner и как его использовать:

	perldoc System::InitD::Runner

=head1 CHANGES

B<TODO>

В следующей версии измени Namespace с System::InitD::Debian на System::InitD::GenInit::Debian

B<1.04>

Исправлен баг с кавычками в start команде, ОБЯЗАТЕЛЬНО обновить до этой версии, если 1.03

B<1.03>

Переделан механизм System::InitD, теперь он подгружает в процессе генерации инит скрипта соответствующий
модуль на лету.
Для расширения функционала достаточно добавить новый модуль. Старый код править теперь необходимости нет.

B<1.02>

Правки шаблона

B<1.01>

Шаблон приведен в более удобочитаемый вид

B<1.0>

Параметр start теперь больше не hashref, теперь это строка. Где команда, а где
аргументы System::InitD разберется сам.

B<0.9>

Интегрирован System::Process

=cut

use strict;
use warnings;

use System::InitD::Runner;

our $VERSION = 1.03;

1;

__END__

