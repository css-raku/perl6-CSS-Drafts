#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use CSS::Module::CSS3::Backgrounds_and_Borders;
use CSS::Module::CSS3::CSS21_Imported;
use CSS::Grammar::Test;

my $css3x-actions = CSS::Module::CSS3::Backgrounds_and_Borders::Actions.new;
my $css21-actions = CSS::Module::CSS3::CSS21_Imported::Actions.new;

my $fh = open 't/css3x-backgrounds-and-borders.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, %test) = @( from-json($_) );
    my $input = %test<input>;

    CSS::Grammar::Test::parse-tests(
	CSS::Module::CSS3::Backgrounds_and_Borders, $input,
	:rule($rule),
	:actions($css3x-actions),
	:suite<css3-backgrounds>,
	:expected(%test) );

    my $css21 = %test<css21> // {};
    my %css21_expected = (%test, %$css21);

    CSS::Grammar::Test::parse-tests(
	CSS::Module::CSS3::CSS21_Imported, $input, 
	:rule($rule),
	:actions($css21-actions),
	:suite<css21-imported>,
	:expected(%css21_expected) );
}

done;
