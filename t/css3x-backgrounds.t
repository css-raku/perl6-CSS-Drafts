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
                                       url(c.png) #fff',
                 ast => {"property" => "background",
                         "expr" => ["bg-image" => {"image" => "a.png"}, "repeat-style" => "no-repeat",
                                    "bg-image" => {"image" => "b.png"}, "bg-size" => ["percentage" => 100e0, "percentage" => 100e0], "repeat-style" => "no-repeat",
                                    "bg-layer" => {"bg-image" => {"image" => "c.png"}}, "color" => {"r" => 255, "g" => 255, "b" => 255}]},
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = CSS::Language::CSS3::Backgrounds.parse( $input, :rule($rule), :actions($css_actions));
    say $p3;
    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-fonts'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
