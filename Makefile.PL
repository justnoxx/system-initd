use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share dist => 'share';

WriteMakefile(
    NAME             => 'System::InitD',
    AUTHOR           => 'Shamatrin D.',
    VERSION_FROM     => 'lib/System/InitD.pm',
    # ABSTRACT_FROM    => 'lib/System/InitD.pm',
    LICENSE          => 'perl',
    PL_FILES         => {},
    EXE_FILES        => ['script/geninitd'],
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker'       =>  0,
        'File::ShareDir'            =>  0,
        'File::ShareDir::Install'   =>  0,
        'System::Process'           =>  0.15,
        'POSIX'                     =>  0,
        'Time::HiRes'               =>  0,
    },  
    BUILD_REQUIRES => {
        'Test::More'                =>  0,
        'ExtUtils::MakeMaker'       =>  0,
        'File::ShareDir'            =>  0,
        'File::ShareDir::Install'   =>  0,
        'System::Process'           =>  0.15,
        'POSIX'                     =>  0,
        'Time::HiRes'               =>  0,
    },  
    PREREQ_PM => {
        'ExtUtils::MakeMaker'       =>  0,
        'File::ShareDir'            =>  0,
        'File::ShareDir::Install'   =>  0,
        'System::Process'           =>  0.15,
        'POSIX'                     =>  0,
        'Time::HiRes'               =>  0,
    },
    TEST_REQUIRES   => {
        'ExtUtils::MakeMaker'       =>  0,
        'File::ShareDir'            =>  0,
        'File::ShareDir::Install'   =>  0,
        'System::Process'           =>  0.15,
        'POSIX'                     =>  0,
        'Time::HiRes'               =>  0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Data-Dir-*' },
    "test" => {
        "TESTS" => "t/*.t"
    }
);

package MY;
use File::ShareDir::Install 'postamble';
