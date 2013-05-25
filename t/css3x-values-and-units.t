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
                    },
    },
    resolution      => {input => '5dppx',
                        ast => 5, token => {type => 'resolution', units => 'dppx'}},
    # math calculations
    declaration => {input => 'width: calc(100%/3 - 2*1em - 2*1px)',
                    ast => {"property" => "width",
                            "expr" => ["length" => {"calc" => ["product" => ["unit" => {"percentage" => 100e0},
                                                                             "op" => "/", "integer" => 3],
                                                               "op" => "-",
                                                               "product" => ["unit" => {"integer" => 2},
                                                                             "op" => "*",
                                                                             "unit" => {"dimension" => 1e0}],
                                                               "op" => "-",
                                                               "product" => ["unit" => {"integer" => 2},
                                                                             "op" => "*",
                                                                             "unit" => {"dimension" => 1e0}]]}
                                ]
                    },
    },
    declaration => {input => 'azimuth: calc(100%/3 - 2*1em - 2*1px)',
                    ast => Any,
                    warnings => 'expected an expresssion of type angle, got: length'
    },
    declaration => {input => 'background-attachment: toggle(scroll, fixed)',
                    ast => Mu,
    },
    declaration => {input => 'elevation: calc(.5turn - 30deg)',
                    ast => {"property" => "elevation", "expr" => ["angle" => {"calc" => ["product" => ["unit" => {"dimension" => 0.5e0}], "op" => "-", "product" => ["unit" => {"dimension" => 30e0}]]}],
                    },
    },
    declaration => {input => 'pause: calc(2s/3.1 - 100ms)',
                    ast => {"property" => "pause", "expr" => ["pause-before" => ["time" => {"calc" => ["product" => ["unit" => {"dimension" => 2e0}, "op" => "/", "number" => 3.1e0], "op" => "-", "product" => ["unit" => {"dimension" => 100e0}]]}]]},
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
