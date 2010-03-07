
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'CPAN::Uploader',
                       'DISTNAME' => 'CPAN-Uploader',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'Ricardo SIGNES <rjbs@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'upload things to the CPAN',
                       'EXE_FILES' => [
                                        'bin/cpan-upload'
                                      ],
                       'VERSION' => '0.100660',
                       'PREREQ_PM' => {
                                        'File::Spec' => '0',
                                        'Data::Dumper' => '0',
                                        'HTTP::Status' => '0',
                                        'Carp' => '0',
                                        'HTTP::Request::Common' => '0',
                                        'Test::More' => '0',
                                        'LWP::UserAgent' => '0',
                                        'Getopt::Long::Descriptive' => '0',
                                        'File::Basename' => '0',
                                        'Term::ReadKey' => '0'
                                      },
                       'LICENSE' => 'perl'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



