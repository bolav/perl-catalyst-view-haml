package TestApp::View::Haml::Providerconfig;

use strict;
use base 'Catalyst::View::Haml';

__PACKAGE__->config(
    PRE_CHOMP          => 1,
    POST_CHOMP         => 1,
    TEMPLATE_EXTENSION => '.tt',
    PROVIDERS           => [
        {
            name    => '+TestApp::FauxProvider',
            args    => {}
        },
        # {
        #     name    => '_file_',
        #     args    => {}
        # }
    ]
);

1;
