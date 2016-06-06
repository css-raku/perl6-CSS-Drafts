#!/usr/bin/env perl6

use Test;
use JSON::Fast;

use CSS::Grammar::Test;
use CSS::Drafts::CSS3;
use CSS::Module::CSS21;
use CSS::Writer;

my $css3x-actions = CSS::Drafts::CSS3::Actions.new;
my $css21-actions = CSS::Module::CSS21::Actions.new;
my $writer = CSS::Writer.new;

for 't/css3x-backgrounds-and-borders.json'.IO.lines {

    next
        if .substr(0,2) eq '//';

    my ($rule, $expected) = @( from-json($_) );
    my $input = $expected<input>;

    my $css3 = $expected<css3> // {};
    my %css3_expected = (%$expected, %$css3);

    CSS::Grammar::Test::parse-tests(
	CSS::Drafts::CSS3, $input, :$rule,
	:actions($css3x-actions),
	:suite<css3x>,
        :$writer,
	:expected(%css3_expected) );

    my $css21 = $expected<css21> // {};
    my %css21_expected = (%$expected, %$css21);

    CSS::Grammar::Test::parse-tests(
	CSS::Module::CSS21, $input, :$rule,
	:actions($css21-actions),
	:suite<css21>,
        :$writer,
	:expected(%css21_expected) );
}

done;
