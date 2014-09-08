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
    my ($rule, $_test) = @( from-json($_) );
    my %test = %$_test;
    my $input = %test<input>;

    CSS::Grammar::Test::parse-tests(
        CSS::Drafts::CSS3, $input, :rule($rule),
        :actions($actions),
        :suite<css3x-units>,
        :expected(%test) );
}

done;
