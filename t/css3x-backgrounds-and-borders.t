#!/usr/bin/env perl6

use Test;

use CSS::Language::CSS3::Backgrounds_and_Borders;

use lib '.';
use t::AST;

my $css_actions = CSS::Language::CSS3::Backgrounds_and_Borders::Actions.new;

for (
    decl     => {input => 'background: url(a.png) top left no-repeat,
                                       url(b.png) center / 100% 100% no-repeat,
                                       url(c.png) white',
                 ast => {"property" => "background",
                         "expr" => ["bg-image" => {"image" => "a.png"}, "repeat-style" => "no-repeat",
                                    "bg-image" => {"image" => "b.png"}, "bg-size" => ["percentage" => 100e0, "percentage" => 100e0], "repeat-style" => "no-repeat",
                                    "bg-layer" => {"bg-image" => {"image" => "c.png"}}, "color" => {"r" => 255, "g" => 255, "b" => 255}]},
    },
    declaration-list => {
        input => 'background-image: url(flower.png), url(ball.png), url(grass.png);
                  background-position: center center, 20% 80%, top left, bottom right;
                  background-origin: border-box, content-box;
                  background-repeat: no-repeat;',
# 11-05-2013: test failing; waiting on RT#117955
        ast => {"background-image"   => {"expr" => ["bg-image" => {"image" => "flower.png"},
                                                    "bg-image" => {"image" => "ball.png"},
                                                    "bg-image" => {"image" => "grass.png"}]},
                "background-position" => {"expr" => ["position" => ["keyw" => "center", "keyw" => "center"],
                                                     "position" => ["percentage" => 20, "percentage" => 80],
                                                     "position" => ["keyw" => "top", "keyw" => "left"],
                                                     "position" => ["keyw" => "botton", "keyw" => "right"]]},
                "background-origin"   => {"expr" => ["box" => "border-box", "box" => "content-box"]},
                "background-repeat"   => {"expr" => ["repeat-style" => "no-repeat"]}}
    },
    decl => { input => 'background-image: none', ast => {property => 'background-image', expr => [keyw => 'none']},
    },
    decl => { input => 'background-repeat: repeat-y', ast => {property => 'background-repeat', expr => [keyw => 'repeat-y']},
    },
    decl => { input => 'background-attachment: scroll', ast => {property => 'background-attachment', expr => [keyw => 'scroll']},
    },
    decl => { input => 'background-position: left 10px top 15px',
              ast => {"property" => "background-position", "expr" => ["length" => 10e0, "keyw" => "top", "length" => 15]},
    },
    decl => { input => 'background-clip: border-box, content-box', ast => {property => 'background-clip', expr => [box => 'border-box', box => 'content-box']},
    },
    decl => { input => 'background-origin:PADDING-Box', ast => {property => 'background-origin', expr => [box => 'padding-box']},
    },
    decl => { input => 'background-size: 50% auto', ast => {property => 'background-size', expr => [percentage => 50, keyw => 'auto']},
    },
    declaration-list => {
        input => 'border-color: #abc green blue',
        ast => {"border-color-top" => {"expr" => ["color" => {"r" => 170, "g" => 187, "b" => 204}]},
                "border-color-right" => {"expr" => ["color" => {"r" => 0, "g" => 128, "b" => 0}]},
                "border-color-bottom" => {"expr" => ["color" => {"r" => 0, "g" => 0, "b" => 255}]},
                "border-color-left" => {"expr" => ["color" => {"r" => 0, "g" => 128, "b" => 0}]}},
    },
    declaration-list => {
        input => 'border-style: dotted dashed',
        ast => {"border-style-top" => {"expr" => ["keyw" => "dotted"]},
                "border-style-right" => {"expr" => ["keyw" => "dashed"]},
                "border-style-bottom" => {"expr" => ["keyw" => "dotted"]},
                "border-style-left" => {"expr" => ["keyw" => "dashed"]}
        },
    },
    declaration-list => {
        input => 'border-width: 2px thin',
        ast => {"border-width-top" => {"expr" => ["length" => 2e0]},
                "border-width-right" => {"expr" => ["keyw" => "thin"]},
                "border-width-bottom" => {"expr" => ["length" => 2e0]},
                "border-width-left" => {"expr" => ["keyw" => "thin"]}},
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = CSS::Language::CSS3::Backgrounds_and_Borders.parse( $input, :rule($rule), :actions($css_actions));

    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-backgrounds'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
