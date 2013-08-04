#!/usr/bin/env perl6

use Test;
use JSON::Tiny;
use CSS::Grammar::Test;

use CSS::Language::CSS3::Values_and_Units;
use CSS::Language::CSS3::CSS21_Imported;

# define our own custom test classes. value extensions + css21 properties

grammar t::Grammar
    is CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::CSS21_Imported {};

class t::Actions
    is CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::CSS21_Imported::Actions
 {};

my $css_actions = t::Actions.new;

my $fh = open 't/css3x-values-and-units.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, %test) = @( from-json($_) );
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = t::Grammar.parse( $input, :rule($rule), :actions($css_actions));

    CSS::Grammar::Test::parse_tests($input, $p3, :rule($rule), :suite('css3-units'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
