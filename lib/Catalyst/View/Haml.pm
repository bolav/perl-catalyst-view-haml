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
    my $config = {
        TEMPLATE_EXTENSION => '',
        %{ $class->config },
        %{$arguments},
    };

    if ( ! (ref $config->{include_path} eq 'ARRAY') ) {
        my $delim = $config->{DELIMITER};
        my @include_path
            = _coerce_paths( $config->{include_path}, $delim );
        if ( !@include_path ) {
            my $root = $c->config->{root};
            my $base = Path::Class::dir( $root, 'base' );
            @include_path = ( "$root", "$base" );
        }
        $config->{include_path} = \@include_path;
    }

    my $self = $class->next::method(
        $c, { %$config },
    );
    $self->config($config);
    
    $self->{haml} = Text::Haml->new;

    return $self;
}

sub _coerce_paths {
    my ( $paths, $dlim ) = shift;
    return () if ( !$paths );
    return @{$paths} if ( ref $paths eq 'ARRAY' );

    # tweak delim to ignore C:/
    unless ( defined $dlim ) {
        $dlim = ( $^O eq 'MSWin32' ) ? ':(?!\\/)' : ':';
    }
    return split( /$dlim/, $paths );
}

sub process {
    my ( $self, $c ) = @_;

    my $haml = $c->stash->{haml}
      ||  $c->action . '.haml';

    unless (defined $haml) {
        $c->log->debug('No template specified for rendering') if $c->debug;
        return 0;
    }
    
    my $output = $self->render($c, $haml);
    
    $c->response->body($output);

    return 1;            
}

sub render {
    my ( $self, $c, $haml, $args ) = @_;
    
    my $vars = {
        (ref $args eq 'HASH' ? %$args : %{ $c->stash() }),
        $self->template_vars($c)
    };

    if (ref $haml eq 'SCALAR') {
        my $output = $self->{haml}->render($$haml, %{ $vars });
        return $output;
    }

    foreach my $dir (@{$self->config->{include_path}}) {
        my $file = File::Spec->catfile($dir, $haml);
        if (-e $file ) {
            
            my $output = $self->{haml}->render_file($file, %{ $vars });
            return $output;
        }
    }
    $c->error("file error - ". $haml .": not found");
    die "file error - ". $haml .": not found";
    return "file error - ". $haml .": not found";
}

sub template_vars {
    my ( $self, $c ) = @_;

    return  () unless $c;
    my $cvar = $self->config->{CATALYST_VAR};

    my %vars = defined $cvar
      ? ( $cvar => $c )
      : (
        c    => $c,
        base => $c->req->base,
        name => $c->config->{name}
      );
      return %vars;
}


1;

__END__

=head2 METHODS

=head2 new

The constructor for the Haml view. 

=head2 process($c)

Renders the Haml file.

=head1 AUTHORS

Bjorn-Olav Strand, C<bolav@cpan.org>

=head1 COPYRIGHT

This program is free software. You can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
