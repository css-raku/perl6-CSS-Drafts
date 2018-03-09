#!/usr/bin/env perl6

use Test;
use JSON::Fast;
use CSS::Grammar::Test;
use CSS::Drafts::CSS3;
use CSS::Writer;

my $actions = CSS::Drafts::CSS3::Actions.new;
my $writer = CSS::Writer.new;

for 't/css3x-values-and-units.json'.IO.lines {

    next
        if .substr(0,2) eq '//';

    my ($rule, $expected) = @( from-json($_) );
    my $input = $expected<input>;

    &CSS::Grammar::Test::parse-tests(
        CSS::Drafts::CSS3, $input, :$rule, :$actions,
        :suite<css3x-units>,
        :$writer,
        :$expected );
}

done-testing;
