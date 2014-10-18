#!/usr/bin/env perl6

use Test;
use JSON::Tiny;
use CSS::Grammar::Test;
use CSS::Drafts::CSS3;

my $actions = CSS::Drafts::CSS3::Actions.new;

my $fh = open 't/css3x-values-and-units.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, $_expected) = @( from-json($_) );
    my %expected = %$_expected;
    my $input = %expected<input>;

    CSS::Grammar::Test::parse-tests(
        CSS::Drafts::CSS3, $input, :$rule, :$actions,
        :suite<css3x-units>,
        :expected(%expected) );
}

done;
