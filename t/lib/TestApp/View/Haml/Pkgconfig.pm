package TestApp::View::Haml::Pkgconfig;

use strict;
use base 'Catalyst::View::Haml';

__PACKAGE__->config(
    PRE_CHOMP          => 1,
    POST_CHOMP         => 1,
    TEMPLATE_EXTENSION => '.tt',
);

1;
