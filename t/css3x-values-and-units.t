#!/usr/bin/env perl6

use Test;
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
                            "expr" => ["length" => {"calc" => ["product" => ["unit" => {"percentage" => 100},
                                                                             "op" => "/", "integer" => 3],
                                                               "op" => "-",
                                                               "product" => ["unit" => {"integer" => 2},
                                                                             "op" => "*",
                                                                             "unit" => {"dimension" => 1}],
                                                               "op" => "-",
                                                               "product" => ["unit" => {"integer" => 2},
                                                                             "op" => "*",
                                                                             "unit" => {"dimension" => 1}]]}
                                ]
                    },
    },
    declaration => {input => 'azimuth: calc(100%/3 - 2*1em - 2*1px)',
                    ast => Any,
                    warnings => rx{expected \s an \s expresssion \s of \s type \s angle\, \s got\: \s length}
    },
    # toggles
    declaration => {input => 'background-attachment: toggle(scroll, fixed)',
                    ast => {"property" => "background-attachment",
                            "expr" => ["toggle" => [{"keyw" => "scroll"},
                                                    {"keyw" => "fixed"}]]},
    },
    declaration => {input => 'font-style: toggle(italic, inherit, normal)',
                    ast => {"property" => "font-style",
                            "expr" => ["toggle" => [{"keyw" => "italic"},
                                                    {"inherit" => True},
                                                    {"keyw" => "normal"}]]
                    },
    },
    declaration => {input => 'list-style-type: toggle(disc, circle, square)',
                    ast => {"property" => "list-style-type",
                            "expr" => ["toggle" => [{"keyw" => "disc"},
                                                    {"keyw" => "circle"},
                                                    {"keyw" => "square"}]]
                    },
    },
    declaration => {input => 'elevation: toggle(initial, below, above)',
                    ast => {"property" => "elevation",
                            "expr" => ["toggle" => [{"initial" => True},
                                                    {"direction" => "below", "_implied" => "angle" => -90},
                                                    {"direction" => "above", "_implied" => "angle" => 90}]]
                    },
    },
     declaration => {input => 'elevation: attr(auto deg, below)',
                    ast => {"property" => "elevation",
                            "expr" => ["attr" => {"attr-name" => {"element-name" => "auto"}, "unit-name" => "deg",
                                                  "fallback" => ["ref" => {"direction" => "below", "_implied" => "angle" => -90}]}]
                    },
    },
   declaration => {input => 'width: attr(size px, auto)',
                    ast => {"property" => "width",
                            "expr" => ["attr" => {"attr-name" => {"element-name" => "size"},
                                                  "unit-name" => "px",
                                                  "fallback" => ["keyw" => "auto"]}]},
    },
    declaration => {input => 'elevation: calc(.5turn - 30deg)',
                    ast => {"property" => "elevation", "expr" => ["angle" => {"calc" => ["product" => ["unit" => {"dimension" => 0.5}], "op" => "-", "product" => ["unit" => {"dimension" => 30}]]}],
                    },
    },
    declaration => {input => 'pause: calc(2s/3.1 - 100ms)',
                    ast => {"property" => "pause", "expr" => ["pause-before" => ["time" => {"calc" => ["product" => ["unit" => {"dimension" => 2}, "op" => "/", "number" => 3.1], "op" => "-", "product" => ["unit" => {"dimension" => 100}]]}]]},
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = t::Grammar.parse( $input, :rule($rule), :actions($css_actions));

    CSS::Grammar::Test::parse_tests($input, $p3, :rule($rule), :suite('css3-units'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
