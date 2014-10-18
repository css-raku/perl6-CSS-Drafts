#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use CSS::Grammar::Test;
use CSS::Drafts::CSS3;
use CSS::Module::CSS21;

my $css3x-actions = CSS::Drafts::CSS3::Actions.new;
my $css21-actions = CSS::Module::CSS21::Actions.new;

my $fh = open 't/css3x-backgrounds-and-borders.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, $_expected) = @( from-json($_) );
    my %expected = %$_expected;
    my $input = %expected<input>;

    my $css3 = %expected<css3> // {};
    my %css3_expected = (%expected, %$css3);

    CSS::Grammar::Test::parse-tests(
	CSS::Drafts::CSS3, $input, :$rule,
	:actions($css3x-actions),
	:suite<css3x-backgrounds>,
	:expected(%css3_expected) );

    my $css21 = %expected<css21> // {};
    my %css21_expected = (%expected, %$css21);

    CSS::Grammar::Test::parse-tests(
	CSS::Module::CSS21, $input, :$rule,
	:actions($css21-actions),
	:suite<css21>,
	:expected(%css21_expected) );
}

done;
