#!/usr/bin/env perl6

use Test;

use CSS::Language::CSS3;

use lib '.';
use t::AST;

my $css_actions = CSS::Language::CSS3::Actions.new;

my $embedded_page = 'media print and (width: 21cm) and (height: 29.7cm) {
      @page { margin: 3cm; }
   }';

my $embedded_page_ast = {"media-list" => ["media-query" => ["media" => "print",
                                                            "media-expr" => {"media-feature" => "width", "expr" => ["term" => 21e0]},
                                                            "media-expr" => {"media-feature" => "height", "expr" => ["term" => 29.7e0]}]],
                         "media-rules" => ["at-rule" => {"declarations" => {"margin" => {"expr" => ["margin-top" => ["length" => 3e0],
                                                                                                    "margin-right" => ["length" => 3e0],
                                                                                                    "margin-bottom" => ["length" => 3e0],
                                                                                                    "margin-left" => ["length" => 3e0]]}}, "\@" => "page"}],
                         "\@" => "media"};

for (
    term      => {input => '300dpi', ast => 300, token => {type => 'resolution', units => 'dpi'}},
    at-rule   => {input => 'media all { body { background:lime } }',
                  ast => {"media-list" => ["media-query" => ["media" => "all"]],
                          "media-rules" => ["ruleset" => {"selectors" => ["selector" => ["simple-selector" => ["element-name" => "body"]]],
                                                          "declarations" => {"background" => {"expr" => ["background-color" => ["color" => {"r" => 0, "g" => 255, "b" => 0}]]}}}],
                          "\@" => "media"},
    },
    at-rule => {input => 'media all and (color) { }',
                ast => {"media-list" => ["media-query" => ["media" => "all", "media-expr" => {"media-feature" => "color"}]], "media-rules" => [], '@' => "media"},
    },
    at-rule => {input => 'media all and (min-color: 2) { }',
                ast => {"media-list" => ["media-query" => ["media" => "all", "media-expr" => {"media-feature" => "min-color", "expr" => ["term" => 2]}]], "media-rules" => [], '@' => "media"},
    },
    # try out dpi and dpcm term extensions
    at-rule => {input => 'media all AND (min-resolution: 300dpi) And (min-resolution: 118dpcm) {}',
                ast => {"media-list" => ["media-query" => ["media" => "all", "media-expr" => {"media-feature" => "min-resolution", "expr" => ["term" => 300]}, "media-expr" => {"media-feature" => "min-resolution", "expr" => ["term" => 118]}]], "media-rules" => [], '@' => "media"},
    },
    at-rule => {input => 'media noT print {body{margin : 1cm}}',
                ast => {"media-list" => ["media-query" => ["media-op" => "not", "media" => "print"]],
                        "media-rules" => ["ruleset" => {"selectors" => ["selector" => ["simple-selector" => ["element-name" => "body"]]],
                                                        "declarations" => {"margin" => {"expr" => ["margin-top" => ["length" => 1e0],
                                                                                                   "margin-right" => ["length" => 1e0],
                                                                                                   "margin-bottom" => ["length" => 1e0],
                                                                                                   "margin-left" => ["length" => 1e0]]}}}],
                        "\@" => "media"},
    },
    at-rule => {input => 'media ONLY all And (none) { }',
                ast => {"media-list" => ["media-query" => ["media-op" => "only", "media" => "all", "media-expr" => {"media-feature" => "none"}]], "media-rules" => [], '@' => "media"},
    },
    # we should also have extended the import at-rule
    import => {input => '@import url(example.css) screen and (color), projection and (color);',
               ast => {"url" => "example.css",
                       "media-list" => ["media-query" => ["media" => "screen", "media-expr" => {"media-feature" => "color"}],
                                        "media-query" => ["media" => "projection", "media-expr" => {"media-feature" => "color"}]]},
    },
    at-rule => {input => $embedded_page, ast => $embedded_page_ast},
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = CSS::Language::CSS3.parse( $input, :rule($rule), :actions($css_actions));
    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3 @media'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
