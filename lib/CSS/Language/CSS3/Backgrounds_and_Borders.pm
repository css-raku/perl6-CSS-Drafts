use v6;

class CSS::Language::CSS3::Backgrounds_and_Borders::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Background and Borders Extension Module
# - reference: http://www.w3.org/TR/2012/CR-css3-background-20120724/
#

grammar CSS::Language::CSS3::Backgrounds_and_Borders::Syntax {

}

grammar CSS::Language::CSS3::Backgrounds_and_Borders:ver<20120724.000>
    is CSS::Language::CSS3::Backgrounds_and_Borders::Syntax
    is CSS::Language::CSS3::_Base {

    # ---- Properties ----#

    rule attachment   {:i [ scroll | fixed | local ] & <keyw> }
    rule image {<uri>}
    rule bg-image     {:i <image> | none & <keyw> }
    rule box          {:i [  border\-box | padding\-box | content\-box ] & <keyw> }
    rule repeat-style {:i [ repeat\-x | repeat\-y ] & <keyw>
                           | [ [repeat | space | round | no\-repeat] & <keyw> ] ** 1..2 }
    rule bg-layer {:i [ <bg-image> | <position> [ '/' <bg-size> ]? | <repeat-style> | <attachment> | <box>**1..2 ] ** 1..5 }
    rule final-bg-layer { [ <bg-layer> | <color> ] ** 1..2}
    # - background: [ <bg-layer> , ]* <final-bg-layer>
    rule decl:sym<background> {:i (background) ':'  [ [ <ref=.bg-layer> ',' ]* <ref=.final-bg-layer> || <misc> ] }

    # - background-attachment: <attachment> [ , <attachment> ]*
    rule decl:sym<background-attachment> {:i (background\-attachment) ':'  [ <ref=.attachment> +% ',' || <misc> ] }

    # - background-clip: <box> [ , <box> ]*
    # - background-origin: <box> [ , <box> ]*
    rule decl:sym<background-[clip|origin]> {:i (background\-[clip|origin]) ':'  [ <box> +% ',' || <misc> ] }

    # - background-color: <color>
    rule decl:sym<background-color> {:i (background\-color) ':'  [ <color> || <misc> ] }

    # - background-image: <bg-image> [ , <bg-image> ]*
    rule decl:sym<background-image> {:i (background\-image) ':'  [ <ref=.bg-image> +% ',' || <misc> ] }


    # - background-position: <position> [ , <position> ]*
    # simplification of <position>
    rule position {:i [ <percentage> | <length> | [ [ left | center | right | top | bottom ] & <keyw> ] [ <percentage> | <length> ] ? ] ** 1..2 }
    rule decl:sym<background-position> {:i (background\-position) ':'  [ <ref=.position> +% ',' || <misc> ] }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    rule decl:sym<background-repeat> {:i (background\-repeat) ':'  [ <ref=.repeat-style> +% ',' || <misc> ] }

    # - background-size: <bg-size> [ , <bg-size> ]*
    rule bg-size {:i [ <length> | <percentage> | auto & <keyw> ] ** 1..2 | [cover | contain ] & <keyw> }
    rule decl:sym<background-size> {:i (background\-size) ':'  [ <ref=.bg-size> +% ',' || <misc> ] }

    # - border: <border-width> || <border-style> || <color>
    rule border-style {:i [ none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset ] & <keyw> }
    rule decl:sym<border> {:i (border) ':'  [ [ <border-width> | <border-style> | <color> ]**1..3 || <misc> ] }

    # - border-color: <color>{1,4}
    rule decl:sym<border-color> {:i (border\-color) ':'  [ <color>**1..4 || <misc> ] }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    rule decl:sym<border-image> {:i (border\-image) ':'  [ [ <border-image-source> | <border-image-slice> [ [ '/' <border-image-width> | '/' <border-image-width>? '/' <border-image-outset> ] ]? | <border-image-repeat> ]**1..3 || <misc> ] }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    token border-image-outset {:i [ [ <length> | <number> ] ]**1..4 }
    rule decl:sym<border-image-outset> {:i (border\-image\-outset) ':'  [ <ref=.border-image-outset> || <misc> ] }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    token border-image-repeat {:i [ [ stretch | repeat | round | space ] & <keyw> ]**1..2 }
    rule decl:sym<border-image-repeat> {:i (border\-image\-repeat) ':'  [ <ref=.border-image-repeat> || <misc> ] }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    token border-image-slice {:i [ [ <number> | <percentage> ] ]**1..4 }
    rule decl:sym<border-image-slice> {:i (border\-image\-slice) ':'  [ <ref=.border-image-slice> || <misc> ] }

    # - border-image-source: none | <image>
    token border-image-source {:i none & <keyw> | <image> }
    rule decl:sym<border-image-source> {:i (border\-image\-source) ':'  [ <ref=.border-image-source> || <misc> ] }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    token border-image-width {:i [ [ <length> | <percentage> | <number> | auto & <keyw> ] ]**1..4 }
    rule decl:sym<border-image-width> {:i (border\-image\-width) ':'  [ <ref=.border-image-width> || <misc> ] }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    rule decl:sym<border-radius> {:i (border\-radius) ':'  [ [ [ <length> | <percentage> ] ]**1..4 [ '/' [ [ <length> | <percentage> ] ]**1..4 ]? || <misc> ] }

    # - border-style: <border-style>{1,4}
    rule decl:sym<border-style> {:i (border\-style) ':'  [ <ref=.border-style>**1..4 || <misc> ] }

    # - border-[top|right|bottom|left]: <border-width> || <border-style> || <color>
    rule border-width {:i <length> | [ thin | medium | thick ] & <keyw> }
    rule decl:sym<border-[top|right|bottom|left]> {:i (border\-[top|right|bottom|left]) ':'  [ [ <border-width> | <border-style> | <color> ]**1..3 || <misc> ] }

    # - border-[top|right|bottom|left]-color: <color>
    rule decl:sym<border-[top|right|bottom|left]-color> {:i (border\-[top|right|bottom|left]\-color) ':'  [ <color> || <misc> ] }

    # - border-[top-left|top-right|bottom-right|bottom-left]-radius: [ <length> | <percentage> ]{1,2}
    rule decl:sym<border-[top|bottom]-[left|right]-radius> {:i (border\-[top|bottom]\-[left|right]\-radius) ':'  [ [ [ <length> | <percentage> ] ]**1..2 || <misc> ] }

    # - border-[top|right|bottom|left]-style: <border-style>
    rule decl:sym<border-[top|right|bottom|left]-style> {:i (border\-[top|right|bottom|left]\-style) ':'  [ <border-style> || <misc> ] }

    # - border-[top|right|bottom|left]-width: <border-width>
    rule decl:sym<border-[top|right|bottom|left]-width> {:i (border\-[top|right|bottom|left]\-width) ':'  [ <border-width> || <misc> ] }

    # - border-width: <border-width>{1,4}
    rule decl:sym<border-width> {:i (border\-width) ':'  [ <ref=.border-width>**1..4 || <misc> ] }

    # - box-decoration-break: slice | clone
    rule decl:sym<box-decoration-break> {:i (box\-decoration\-break) ':'  [ [ slice | clone ] & <keyw> || <misc> ] }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    rule shadow {:i [ <length> | <color> | inset & <keyw> ]+ }
    rule decl:sym<box-shadow> {:i (box\-shadow) ':'  [ none & <keyw> | <shadow> +% ',' || <misc> ] }

}

class CSS::Language::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Language::CSS3::_Base::Actions {

    method attachment($/) { make $.token($<keyw>.ast) }
    method image($/) {  make $<uri>.ast }
    method bg-image($/) {  make $.node($/) }
    method box($/) { make $.token($<keyw>.ast) }
    method repeat-style($/) { make $.token($<keyw>.ast) }
    method bg-layer($/) { make $.node($/) }
    method final-bg-layer($/) { make $.node($/) }
    # - background: [ <bg-layer> , ]* <final-bg-layer>
    method decl:sym<background>($/) {
        $._make_decl($/, q{[ <bg-layer> , ]* <final-bg-layer>});
    }

    # - background-attachment: <attachment> [ , <attachment> ]*
    method decl:sym<background-attachment>($/) {
        $._make_decl($/, q{<attachment> [ , <attachment> ]*});
    }

    # - background-clip: <box> [ , <box> ]*
    # - background-origin: <box> [ , <box> ]*
    method decl:sym<background-[clip|origin]>($/) {
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

    # - background-position: <position> [ , <position> ]*
    method position($/) { make $.list($/) }
    method decl:sym<background-position>($/) {
        $._make_decl($/, q{<position> [ , <position> ]*} );
    }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    method decl:sym<background-repeat>($/) {
        $._make_decl($/, q{<repeat-style> [ , <repeat-style> ]*});
    }

    # - background-size: <bg-size> [ , <bg-size> ]*
    method bg-size($/) { make $.list($/) }
    method decl:sym<background-size>($/) {
        $._make_decl($/, q{<bg-size> [ , <bg-size> ]*});
    }

    # - border: <border-width> || <border-style> || <color>
    method decl:sym<border>($/) {
        $._make_decl($/, q{<border-width> || <border-style> || <color>});
    }

    # - border-color: <color>{1,4}
    method decl:sym<border-color>($/) {
        $._make_decl($/, q{<color>{1,4}}, :expand<box>);
    }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    method decl:sym<border-image>($/) {
        $._make_decl($/, q{<‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>});
    }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    method border-image-outset($/) { make $.list($/) }
    method decl:sym<border-image-outset>($/) {
        $._make_decl($/, q{[ <length> | <number> ]{1,4}}, :expand<box>);
    }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    method border-image-repeat($/) { make $.list($/) }
    method decl:sym<border-image-repeat>($/) {
        $._make_decl($/, q{[ stretch | repeat | round | space ]{1,2}});
    }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    method border-image-slice($/) { make $.list($/) }
    method decl:sym<border-image-slice>($/) {
        $._make_decl($/, q{[<number> | <percentage>]{1,4} }, :expand<box>);
    }

    # - border-image-source: none | <image>
    method border-image-source($/) { make $.list($/) }
    method decl:sym<border-image-source>($/) {
        $._make_decl($/, q{none | <image>});
    }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    method border-image-width($/) { make $.list($/) }
    method decl:sym<border-image-width>($/) {
        $._make_decl($/, q{[ <length> | <percentage> | <number> | auto ]{1,4}}, :expand<box>);
    }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    method decl:sym<border-radius>($/) {
        $._make_decl($/, q{[ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?}, :expand<box>);
    }

    # - border-style: <border-style>{1,4}
    method border-style($/) { make $.list($/) }
    method decl:sym<border-style>($/) {
        $._make_decl($/, q{<border-style>{1,4}}, :expand<box>);
    }

    # - border-[top|right|bottom|left]: <border-width> || <border-style> || <color>
    method border-width($/) { make $.node($/) }
    method decl:sym<border-[top|right|bottom|left]>($/) {
        $._make_decl($/, q{<border-width> || <border-style> || <color>});
    }

    # - border-[top|right|bottom|left]-color: <color>
    method decl:sym<border-[top|right|bottom|left]-color>($/) {
        $._make_decl($/, q{<color>});
    }

    # - border-[top-left|top-right|bottom-right|bottom-left]-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-[top|bottom]-[left|right]-radius>($/) {
        $._make_decl($/, q{[ <length> | <percentage> ]{1,2}});
    }

    # - border-[top|right|bottom|left]-style: <border-style>
    method decl:sym<border-[top|right|bottom|left]-style>($/) {
        $._make_decl($/, q{<border-style>});
    }

    # - border-[top|right|bottom|left]-width: <border-width>
    method decl:sym<border-[top|right|bottom|left]-width>($/) {
        $._make_decl($/, q{<border-width>});
    }

    # - border-width: <border-width>{1,4}
    method decl:sym<border-width>($/) {
        $._make_decl($/, q{<border-width>{1,4}}, :expand<box>);
    }

    # - box-decoration-break: slice | clone
    method decl:sym<box-decoration-break>($/) {
        $._make_decl($/, q{slice | clone});
    }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    method shadow($/) { make $.node($/) }
    method decl:sym<box-shadow>($/) {
        $._make_decl($/, q{none | <shadow> [ , <shadow> ]*});
    }

}
