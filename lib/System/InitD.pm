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

B<1.07>

 - Пофикшен System::InitD::Runner, теперь не требует старых зависимостей.

B<1.06>

 - Существенно ускорен restart, за счет Time::HiRes::usleep.

B<1.05>

 - Namespace для OS-компонентов генератора изменен на System::InitD::GenInit::$OSname
 - Добавлен модуль для генерации CentOS (System::InitD::GenInit::Centos)скриптов, использовать
 с флагом --os centos при генерации.
 - Внесены исправления в шаблон debian.tt.
 - Добавлен новый шаблон - centos.tt, см. выше.

B<1.04>

 - Исправлен баг с кавычками в start команде, ОБЯЗАТЕЛЬНО обновить до этой версии, если 1.03.

B<1.03>

 - Переделан механизм System::InitD, теперь он подгружает в процессе генерации инит скрипта соответствующий
 модуль на лету.
 - Для расширения функционала достаточно добавить новый модуль. Старый код править теперь необходимости нет.

B<1.02>

 - Правки шаблона debian.tt

B<1.01>

 - Шаблон приведен в более удобочитаемый вид

B<1.0>

 - Параметр start теперь больше не hashref, теперь это строка. Где команда, а где
 аргументы System::InitD разберется сам.

B<0.9>

 - Интегрирован System::Process

=cut

use strict;
use warnings;

use System::InitD::Runner;

our $VERSION = 1.07;

1;

__END__

