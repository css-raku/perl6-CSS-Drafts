use v6;

class CSS::Language::CSS3::Background::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Paged Media Module Extensions
# - reference: http://www.w3.org/TR/2012/CR-css3-background-20120724/
#

grammar CSS::Language::CSS3::Background::Syntax {

}

grammar CSS::Language::CSS3::Background:ver<20120724.000>
    is CSS::Language::CSS3::Background::Syntax
    is CSS::Language::CSS3::_Base {

    # ---- Properties ----#

    # - background: [ <bg-layer> , ]* <final-bg-layer>
    rule decl:sym<background> {:i (background) ':'  [ <bg-layer> +% ',' || <misc> ] }

    # - background-attachment: <attachment> [ , <attachment> ]*
    rule decl:sym<background-attachment> {:i (background\-attachment) ':'  [ <attachment> [ ',' <attachment> ]* || <misc> ] }

    # - background-clip: <box> [ , <box> ]*
    rule decl:sym<background-clip> {:i (background\-clip) ':'  [ <box> +% ',' || <misc> ] }

    # - background-color: <color>
    rule decl:sym<background-color> {:i (background\-color) ':'  [ <color> || <misc> ] }

    # - background-image: <bg-image> [ , <bg-image> ]*
    rule decl:sym<background-image> {:i (background\-image) ':'  [ <bg-image> +% ',' || <misc> ] }

    # - background-origin: <box> [ , <box> ]*
    rule decl:sym<background-origin> {:i (background\-origin) ':'  [ <box> +% ',' || <misc> ] }

    # - background-position: <position> [ , <position> ]*
    rule decl:sym<background-position> {:i (background\-position) ':'  [ <position> +% ',' || <misc> ] }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    rule decl:sym<background-repeat> {:i (background\-repeat) ':'  [ <repeat-style> +% ',' || <misc> ] }

    # - background-size: <bg-size> [ , <bg-size> ]*
    rule decl:sym<background-size> {:i (background\-size) ':'  [ <bg-size> +% ',' || <misc> ] }

    # - border: <border-width> || <border-style> || <color>
    rule decl:sym<border> {:i (border) ':'  [ [ <border-width> | <border-style> | <color> ]**1..3 || <misc> ] }

    # - border-color: <color>{1,4}
    rule decl:sym<border-color> {:i (border\-color) ':'  [ <color>**1..4 || <misc> ] }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    rule decl:sym<border-image> {:i (border\-image) ':'  [ [ <border-image-source> | <border-image-slice> [ [ '/' <border-image-width> | '/' <border-image-width>? '/' <border-image-outset> ] ]? | <border-image-repeat> ]**1..3 || <misc> ] }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    token border-image-outset {:i [ [ <length> | <number> ] ]**1..4 }
    rule decl:sym<border-image-outset> {:i (border\-image\-outset) ':'  [ <border-image-outset> || <misc> ] }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    token border-image-repeat {:i [ [ stretch | repeat | round | space ] & <keyw> ]**1..2 }
    rule decl:sym<border-image-repeat> {:i (border\-image\-repeat) ':'  [ <border-image-repeat> || <misc> ] }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    token border-image-slice {:i [ [ <number> | <percentage> ] ]**1..4 }
    rule decl:sym<border-image-slice> {:i (border\-image\-slice) ':'  [ <border-image-slice> || <misc> ] }

    # - border-image-source: none | <image>
    token border-image-source {:i none & <keyw> | <image> }
    rule decl:sym<border-image-source> {:i (border\-image\-source) ':'  [ <border-image-source> || <misc> ] }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    token border-image-width {:i [ [ <length> | <percentage> | <number> | auto & <keyw> ] ]**1..4 }
    rule decl:sym<border-image-width> {:i (border\-image\-width) ':'  [ <border-image-width> || <misc> ] }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    rule decl:sym<border-radius> {:i (border\-radius) ':'  [ [ [ <length> | <percentage> ] ]**1..4 [ '/' [ [ <length> | <percentage> ] ]**1..4 ]? || <misc> ] }

    # - border-style: <border-style>{1,4}
    rule decl:sym<border-style> {:i (border\-style) ':'  [ <border-style>**1..4 || <misc> ] }

    # - border-top|border-right|border-bottom|border-left: <border-width> || <border-style> || <color>
    rule decl:sym<border-top|border-right|border-bottom|border-left> {:i (border\-top|border\-right|border\-bottom|border\-left) ':'  [ [ <border-width> | <border-style> | <color> ]**1..3 || <misc> ] }

    # - border-top-color|border-right-color|border-bottom-color|border-left-color: <color>
    rule decl:sym<border-top-color|border-right-color|border-bottom-color|border-left-color> {:i (border\-top\-color|border\-right\-color|border\-bottom\-color|border\-left\-color) ':'  [ <color> || <misc> ] }

    # - border-top-left-radius|border-top-right-radius|border-bottom-right-radius|border-bottom-left-radius: [ <length> | <percentage> ]{1,2}
    rule decl:sym<border-top-left-radius|border-top-right-radius|border-bottom-right-radius|border-bottom-left-radius> {:i (border\-top\-left\-radius|border\-top\-right\-radius|border\-bottom\-right\-radius|border\-bottom\-left\-radius) ':'  [ [ [ <length> | <percentage> ] ]**1..2 || <misc> ] }

    # - border-top-style|border-right-style|border-bottom-style|border-left-style: <border-style>
    rule decl:sym<border-top-style|border-right-style|border-bottom-style|border-left-style> {:i (border\-top\-style|border\-right\-style|border\-bottom\-style|border\-left\-style) ':'  [ <border-style> || <misc> ] }

    # - border-top-width|border-right-width|border-bottom-width|border-left-width: <border-width>
    rule decl:sym<border-top-width|border-right-width|border-bottom-width|border-left-width> {:i (border\-top\-width|border\-right\-width|border\-bottom\-width|border\-left\-width) ':'  [ <border-width> || <misc> ] }

    # - border-width: <border-width>{1,4}
    rule decl:sym<border-width> {:i (border\-width) ':'  [ <border-width>**1..4 || <misc> ] }

    # - box-decoration-break: slice | clone
    rule decl:sym<box-decoration-break> {:i (box\-decoration\-break) ':'  [ [ slice | clone ] & <keyw> || <misc> ] }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    rule decl:sym<box-shadow> {:i (box\-shadow) ':'  [ none & <keyw> | <shadow> +% <shadow> || <misc> ] }

}

class CSS::Language::CSS3::Background::Actions
    is CSS::Language::CSS3::_Base::Actions {

    # - background: [ <bg-layer> , ]* <final-bg-layer>
    method decl:sym<background>($/) {
        $._make_decl($/, q{[ <bg-layer> , ]* <final-bg-layer>});
    }

    # - background-attachment: <attachment> [ , <attachment> ]*
    method decl:sym<background-attachment>($/) {
        $._make_decl($/, q{<attachment> [ , <attachment> ]*});
    }

    # - background-clip: <box> [ , <box> ]*
    method decl:sym<background-clip>($/) {
        $._make_decl($/, q{<box> [ , <box> ]*});
    }

    # - background-color: <color>
    method decl:sym<background-color>($/) {
        $._make_decl($/, q{<color>});
    }

    # - background-image: <bg-image> [ , <bg-image> ]*
    method decl:sym<background-image>($/) {
        $._make_decl($/, q{<bg-image> [ , <bg-image> ]*});
    }

    # - background-origin: <box> [ , <box> ]*
    method decl:sym<background-origin>($/) {
        $._make_decl($/, q{<box> [ , <box> ]*});
    }

    # - background-position: <position> [ , <position> ]*
    method decl:sym<background-position>($/) {
        $._make_decl($/, q{<position> [ , <position> ]*});
    }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    method decl:sym<background-repeat>($/) {
        $._make_decl($/, q{<repeat-style> [ , <repeat-style> ]*});
    }

    # - background-size: <bg-size> [ , <bg-size> ]*
    method decl:sym<background-size>($/) {
        $._make_decl($/, q{<bg-size> [ , <bg-size> ]*});
    }

    # - border: <border-width> || <border-style> || <color>
    method decl:sym<border>($/) {
        $._make_decl($/, q{<border-width> || <border-style> || <color>});
    }

    # - border-color: <color>{1,4}
    method decl:sym<border-color>($/) {
        $._make_decl($/, q{<color>{1,4}});
    }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    method decl:sym<border-image>($/) {
        $._make_decl($/, q{<‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>});
    }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    method border-image-outset($/) { make $.list($/) }
    method decl:sym<border-image-outset>($/) {
        $._make_decl($/, q{[ <length> | <number> ]{1,4}}, :body($<border-image-outset>));
    }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    method border-image-repeat($/) { make $.list($/) }
    method decl:sym<border-image-repeat>($/) {
        $._make_decl($/, q{[ stretch | repeat | round | space ]{1,2}}, :body($<border-image-repeat>));
    }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    method border-image-slice($/) { make $.list($/) }
    method decl:sym<border-image-slice>($/) {
        $._make_decl($/, q{[<number> | <percentage>]{1,4} }, :body($<border-image-slice>));
    }

    # - border-image-source: none | <image>
    method border-image-source($/) { make $.list($/) }
    method decl:sym<border-image-source>($/) {
        $._make_decl($/, q{none | <image>}, :body($<border-image-source>));
    }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    method border-image-width($/) { make $.list($/) }
    method decl:sym<border-image-width>($/) {
        $._make_decl($/, q{[ <length> | <percentage> | <number> | auto ]{1,4}}, :body($<border-image-width>));
    }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    method decl:sym<border-radius>($/) {
        $._make_decl($/, q{[ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?});
    }

    # - border-style: <border-style>{1,4}
    method decl:sym<border-style>($/) {
        $._make_decl($/, q{<border-style>{1,4}});
    }

    # - border-top|border-right|border-bottom|border-left: <border-width> || <border-style> || <color>
    method decl:sym<border-top|border-right|border-bottom|border-left>($/) {
        $._make_decl($/, q{<border-width> || <border-style> || <color>});
    }

    # - border-top-color|border-right-color|border-bottom-color|border-left-color: <color>
    method decl:sym<border-top-color|border-right-color|border-bottom-color|border-left-color>($/) {
        $._make_decl($/, q{<color>});
    }

    # - border-top-left-radius|border-top-right-radius|border-bottom-right-radius|border-bottom-left-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-top-left-radius|border-top-right-radius|border-bottom-right-radius|border-bottom-left-radius>($/) {
        $._make_decl($/, q{[ <length> | <percentage> ]{1,2}});
    }

    # - border-top-style|border-right-style|border-bottom-style|border-left-style: <border-style>
    method decl:sym<border-top-style|border-right-style|border-bottom-style|border-left-style>($/) {
        $._make_decl($/, q{<border-style>});
    }

    # - border-top-width|border-right-width|border-bottom-width|border-left-width: <border-width>
    method decl:sym<border-top-width|border-right-width|border-bottom-width|border-left-width>($/) {
        $._make_decl($/, q{<border-width>});
    }

    # - border-width: <border-width>{1,4}
    method decl:sym<border-width>($/) {
        $._make_decl($/, q{<border-width>{1,4}});
    }

    # - box-decoration-break: slice | clone
    method decl:sym<box-decoration-break>($/) {
        $._make_decl($/, q{slice | clone});
    }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    method decl:sym<box-shadow>($/) {
        $._make_decl($/, q{none | <shadow> [ , <shadow> ]*});
    }


}
