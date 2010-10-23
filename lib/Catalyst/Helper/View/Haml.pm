package Catalyst::Helper::View::Haml;

use strict;

=head1 NAME

Catalyst::Helper::View::Haml - Helper for Haml Views

=head1 SYNOPSIS

    script/create.pl view HTML Haml

=head1 DESCRIPTION

Helper for Haml Views.

=head2 METHODS

=head3 mk_compclass

=cut

sub mk_compclass {
    my ( $self, $helper ) = @_;
    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );
}

=head1 SEE ALSO

L<Catalyst::Manual>, L<Catalyst::Test>, L<Catalyst::Request>,
L<Catalyst::Response>, L<Catalyst::Helper>

=head1 AUTHOR

Bjorn-Olav Strand, C<bolav@cpan.org>

=head1 LICENSE

This library is free software . You can redistribute it and/or modify
it under the same terms as perl itself.

=cut

1;

__DATA__

__compclass__
package [% class %];

use strict;
use warnings;

use base 'Catalyst::View::Haml';

__PACKAGE__->config(
);

=head1 NAME

[% class %] - Haml View for [% app %]

=head1 DESCRIPTION

Haml View for [% app %].

=head1 SEE ALSO

L<[% app %]>

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
