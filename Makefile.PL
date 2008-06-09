
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'CPAN-Uploader',
  NAME      => 'CPAN::Uploader',
  AUTHOR    => 'Ricardo\ SIGNES\ \<rjbs\@cpan\.org\>',
  ABSTRACT  => 'upload things to the CPAN',
  VERSION   => '0.003',
  EXE_FILES => [ qw(bin/cpan-upload) ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "LWP::UserAgent" => '0',
    "File::Basename" => '0',
    "HTTP::Status" => '0',
    "HTTP::Request::Common" => '0',
  },
);
