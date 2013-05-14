#!/usr/bin/env perl6

use Test;

use CSS::Language::CSS3::Units;
use CSS::Language::CSS3::CSS21_Imported;

# define our own custom test classes. value extensions + css21 properties

grammar t::Grammar
    is CSS::Language::CSS3::Units
    is CSS::Language::CSS3::CSS21_Imported::Grammar {};

class t::Actions
    is CSS::Language::CSS3::Units::Actions
    is CSS::Language::CSS3::CSS21_Imported::Actions
 {};

use lib '.';
use t::AST;

my $css_actions = t::Actions.new;

for (
    declaration => {input => 'font-size: 8vw',
             ast => {"property" => "font-size",
                     "expr" => ["length" => 8]},
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = t::Grammar.parse( $input, :rule($rule), :actions($css_actions));

    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-units'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
