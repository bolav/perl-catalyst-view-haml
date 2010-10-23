use inc::Module::Install;

perl_version '5.008001';

name 'Catalyst-View-Haml';
all_from 'lib/Catalyst/View/Haml.pm';

requires 'Catalyst'        => '5.7';
requires 'Text::Haml'      => 0;

test_requires 'Test::More';

auto_install;
resources repository => 'http://github.com/bolav/catalyst-view-haml';

WriteAll;
