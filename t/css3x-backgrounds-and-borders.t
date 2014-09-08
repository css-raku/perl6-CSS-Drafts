#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use CSS::Grammar::Test;
use CSS::Drafts::CSS3;

my $css3x-actions = CSS::Drafts::CSS3::Actions.new;
my $css21-actions = CSS::Module::CSS21::Actions.new;

my $fh = open 't/css3x-backgrounds-and-borders.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, $_test) = @( from-json($_) );
    my %test = %$_test;
    my $input = %test<input>;

    CSS::Grammar::Test::parse-tests(
	CSS::Drafts::CSS3, $input,
	:rule($rule),
	:actions($css3x-actions),
	:suite<css3x-backgrounds>,
	:expected(%test) );

    my $css21 = %test<css21> // {};
    my %css21_expected = (%test, %$css21);

    CSS::Grammar::Test::parse-tests(
	CSS::Module::CSS21, $input, 
	:rule($rule),
	:actions($css21-actions),
	:suite<css21-imported>,
	:expected(%css21_expected) );
}

done;
