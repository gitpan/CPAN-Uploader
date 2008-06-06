use strict;
use warnings;
package CPAN::Uploader;
our $VERSION = '0.001';

# ABSTRACT: upload things to the CPAN


use File::Basename ();
use HTTP::Request::Common qw(POST);
use HTTP::Status;
use LWP::UserAgent;


sub log   { shift; print "$_\n" for @_ }
sub debug { return unless $ENV{CPAN_UPLOAD_DEBUG}; shift->log(@_) }

my $PAUSE_ADD_URI = 'http://pause.perl.org/pause/authenquery';


sub upload_file {
  my ($self, $file, $arg) = @_;

  $self->log("registering upload with PAUSE web server");

  # Create the agent we'll use to make the web requests
  $self->debug("creating instance of LWP::UserAgent");

  my $agent = LWP::UserAgent->new() || die "Failed to create UserAgent: $!";
  $agent->agent($self . q{/} . $self->VERSION);

  $agent->proxy(['http'], $arg->{http_proxy}) if $arg->{http_proxy};

  # Post an upload message to the PAUSE web site for each file
  my $basename = File::Basename::basename($file);

  open(my $fh, $file) or die "Failed to open $file: $!";
  my $contents = do { local $/; <$fh> };
  close($fh);

  # Create the request to add the file
  my $form = {
    HIDDENNAME                        => $arg->{user},
    CAN_MULTIPART                     => 1,
    pause99_add_uri_upload            => $basename,
    SUBMIT_pause99_add_uri_httpupload => " Upload this file from my disk ",
    pause99_add_uri_uri               => "",
    pause99_add_uri_httpupload        => [$file],
  };

  if ($arg->{directory}) {
    $form->{pause99_add_uri_subdirtext} = $arg->{directory};
  }

  my $request = POST(
    $PAUSE_ADD_URI,
    Content_Type => 'form-data',
    Content      => $form,
  );

  $request->authorization_basic($arg->{user}, $arg->{password});

  $self->debug(
    "----- REQUEST BEGIN -----" .
    $request->as_string .
    "----- REQUEST END -------"
  );

  # Make the request to the PAUSE web server
  $self->log("POSTing upload for $file");
  my $response = $agent->request($request);

  # So, how'd we do?
  if (not defined $response) {
    die "Request completely failed - we got undef back: $!";
  }

  if ($response->is_error) {
    if ($response->code == RC_NOT_FOUND) {
      die "PAUSE's CGI for handling messages seems to have moved!\n",
        "(HTTP response code of 404 from the PAUSE web server)\n",
        "It used to be: ", $PAUSE_ADD_URI, "\n",
        "Please inform the maintainer of $self.\n";
    } else {
      die "request failed\n  Error code: ", $response->code,
        "\n  Message: ", $response->message, "\n";
    }
  } else {
    $self->debug(
      "Looks OK!",
      "----- RESPONSE BEGIN -----",
      $response->as_string,
      "----- RESPONSE END -------"
    );
    $self->log("PAUSE add message sent ok [", $response->code, "]");
  }
}

1;

__END__

=pod

=head1 NAME

CPAN::Uploader - upload things to the CPAN

=head1 VERSION

version 0.001

=head1 WARNING

    This is really, really not well tested or used yet.  Give it a few weeks, at
    least.  -- rjbs, 2008-06-06

=head1 ORIGIN

This code is mostly derived from C<cpan-upload-http> by Brad Fitzpatrick, which
in turn was based on C<cpan-upload> by Neil Bowers.  I (I<rjbs>) didn't want to
have to use a C<system> call to run either of those, so I refactored the code
into this module.

=cut 

=cut 

=cut 

=head1 METHODS

=head2 log

    $uploader->log($message);

=head2 debug

    $uploader->debug($message);

=head2 upload_file

    $uploader->upload_file($file, \%arg);

=head1 AUTHOR

  Ricardo SIGNES <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2008 by Ricardo SIGNES.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.



