package Catalyst::View::Haml;

use strict;
use warnings;

use base qw/Catalyst::View/;
use Data::Dump 'dump';
use Text::Haml;
use Scalar::Util qw/blessed weaken/;

our $VERSION = '0.001';
$VERSION = eval $VERSION;

__PACKAGE__->mk_accessors('haml');

=head1 NAME

Catalyst::View::Haml - Haml View Class

=head1 SYNOPSIS

# use the helper to create your View

    myapp_create.pl view Web Haml

# add custom configration in View/Web.pm

    __PACKAGE__->config(
    );

# render view from lib/MyApp.pm or lib/MyApp::Controller::SomeController.pm

    sub message : Global {
        my ( $self, $c ) = @_;
        $c->forward( $c->view('Web') );
    }

=cut

sub new {
    my ( $class, $c, $arguments ) = @_;

    $self->{haml} = Text::Haml->new;

    return $self;
}

sub process {
    my ( $self, $c ) = @_;

    my $haml = $c->stash->{haml}
      ||  $c->action . '.haml';

    unless (defined $haml) {
        $c->log->debug('No template specified for rendering') if $c->debug;
        return 0;
    }

    my $output = $self->{haml}->render_file($haml, %{ $c->stash() });
    $c->response->body($output);

    return 1;
}


1;

__END__


=head1 AUTHORS

Bjorn-Olav Strand, C<bolav@cpan.org>

=head1 COPYRIGHT

This program is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
