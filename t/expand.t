#! /usr/bin/env perl

# Copyright (C) 2016-2018 Guido Flohr <guido.flohr@cantanea.com>,
# all rights reserved.

# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU Library General Public License as published
# by the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.

# You should have received a copy of the GNU Library General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.

use strict;

use Test::More tests => 2;
my $builder = Test::More->builder;
binmode $builder->output, ':utf8';
binmode $builder->failure_output, ':utf8';
binmode $builder->todo_output, ':utf8';

use Template;

my $tt = Template->new or die Template->error;

my ($template, $output);

$template = <<'EOF';
[%- USE Gettext -%]
[%- 'Hello, {who}!' | xgettext(who => 'world') -%]
EOF
$tt->process(\$template, {}, \$output) or die $tt->error;
is $output, 'Hello, world!';


subtest utf8_flag => sub {
    use utf8;
    my $tt2 = Template->new(ENCODING => 'utf8') or die Template->error;

    my $template = <<'EOF';
[%- USE Gettext -%]
[%- 'こんにちは、{who}!' | xgettext(who => name) -%]
EOF

    my $output;
    $tt2->process(\$template, { name => '世界' }, \$output)
        or die $tt->error;

    is $output, 'こんにちは、世界';
};
