
use strict;
use warnings;



use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'CPAN-Uploader',
  NAME      => 'CPAN::Uploader',
  AUTHOR    => "Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>",
  ABSTRACT  => "upload\ things\ to\ the\ CPAN",
  VERSION   => '0.093390',
  EXE_FILES => [ qw(bin/cpan-upload) ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "URI" => '0',
    "Data::Dumper" => '0',
    "HTTP::Status" => '0',
    "HTTP::Request::Common" => '0',
    "LWP::UserAgent" => '0',
    "File::Basename" => '0',
    "Getopt::Long::Descriptive" => '0',
    "Term::ReadKey" => '0',
  },
  test => {TESTS => 't/*.t'}
);

