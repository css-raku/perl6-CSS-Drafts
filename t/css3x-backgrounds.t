#!/usr/bin/env perl6

use Test;

use CSS::Language::CSS3::Backgrounds;

# prepare our own composite class with font extensions

use lib '.';
use t::AST;

my $css_actions = CSS::Language::CSS3::Backgrounds::Actions.new;

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
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = CSS::Language::CSS3::Backgrounds.parse( $input, :rule($rule), :actions($css_actions));

    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-fonts'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
