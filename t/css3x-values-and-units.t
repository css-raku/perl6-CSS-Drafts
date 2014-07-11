#!/usr/bin/env perl6

use Test;
use JSON::Tiny;
use CSS::Grammar::Test;

use CSS::Module::CSS3::Values_and_Units;
use CSS::Module::CSS3::CSS21_Imported;

# define our own custom test classes. value extensions + css21 properties

grammar t::Grammar
    is CSS::Module::CSS3::Values_and_Units
    is CSS::Module::CSS3::CSS21_Imported {};

class t::Actions
    is CSS::Module::CSS3::Values_and_Units::Actions
    is CSS::Module::CSS3::CSS21_Imported::Actions
 {};

my $actions = t::Actions.new;

my $fh = open 't/css3x-values-and-units.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, %test) = @( from-json($_) );
    my $input = %test<input>;

    CSS::Grammar::Test::parse-tests(t::Grammar, $input, :rule($rule),
				    :suite<css3-units>,
				    :actions($actions),
				    :expected(%test) );
}

done;
