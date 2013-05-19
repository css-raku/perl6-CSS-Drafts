#!/usr/bin/env perl6

use Test;

use CSS::Language::CSS3::Values_and_Units;
use CSS::Language::CSS3::CSS21_Imported;

# define our own custom test classes. value extensions + css21 properties

grammar t::Grammar
    is CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::CSS21_Imported::Grammar {};

class t::Actions
    is CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::CSS21_Imported::Actions
 {};

use lib '.';
use t::AST;

my $css_actions = t::Actions.new;

for (
    declaration => {input => 'font-size: 8vw', ast => {"property" => "font-size",
                                                       "expr" => ["length" => 8]},
    },
    declaration => {input => 'margin-left: 1.2rem', ast => {"property" => "margin-left",
                                                            "expr" => ["length" => 1.2]},
    },
    declaration => {input => 'azimuth: .5turn', ast => {"property" => "azimuth",
                                                        "expr" => ["angle" => .5],
                                                        "_result" => ["angle" => .5],
                                                        
                    },
    },
    resolution      => {input => '5dppx',
                        ast => 5, token => {type => 'resolution', units => 'dppx'}},
    # math calculations
    declaration => {input => 'width: calc(100%/3 - 2*1em - 2*1px)',
                    ast => Mu,
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = t::Grammar.parse( $input, :rule($rule), :actions($css_actions));
    note $p3;
    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-units'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
