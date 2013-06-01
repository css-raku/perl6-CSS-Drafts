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
    rule decl:sym<background> {:i (background) ':'  <val(rx:s:i[ [ <ref=.bg-layer> ',' ]* <ref=.final-bg-layer> ])> }

    # - background-attachment: <attachment> [ , <attachment> ]*
    rule decl:sym<background-attachment> {:i (background\-attachment) ':'  <val(rx:s:i[ <ref=.attachment> +% ',' ])> }

    # - background-clip: <box> [ , <box> ]*
    # - background-origin: <box> [ , <box> ]*
    rule decl:sym<background-[clip|origin]> {:i (background\-[clip|origin]) ':'  <val(rx:s:i[ <box> +% ',' ])> }

    # - background-color: <color>
    rule decl:sym<background-color> {:i (background\-color) ':'  <val(rx:s:i[ <color> ])> }

    # - background-image: <bg-image> [ , <bg-image> ]*
    rule decl:sym<background-image> {:i (background\-image) ':'  <val(rx:s:i[ <ref=.bg-image> +% ',' ])> }


    # - background-position: <position> [ , <position> ]*
    # simplification of <position>
    rule position {:i [ <percentage> | <length> | [ [ left | center | right | top | bottom ] & <keyw> ] [ <percentage> | <length> ] ? ] ** 1..2 }
    rule decl:sym<background-position> {:i (background\-position) ':'  <val(rx:s:i[ <ref=.position> +% ',' ])> }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    rule decl:sym<background-repeat> {:i (background\-repeat) ':'  <val(rx:s:i[ <ref=.repeat-style> +% ',' ])> }

    # - background-size: <bg-size> [ , <bg-size> ]*
    rule bg-size {:i [ <length> | <percentage> | auto & <keyw> ] ** 1..2 | [cover | contain ] & <keyw> }
    rule decl:sym<background-size> {:i (background\-size) ':'  <val(rx:s:i[ <ref=.bg-size> +% ',' ])> }

    # - border: <border-width> || <border-style> || <color>
    rule border-style {:i [ none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset ] & <keyw> }
    rule decl:sym<border> {:i (border) ':'  [ [ <border-width> | <border-style> | <color> ]**1..3 || <misc> ] }

    # - border-color: <color>{1,4}
    rule decl:sym<border-color> {:i (border\-color) ':'  <val(rx:s:i[ <color>**1..4 ])> }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    rule decl:sym<border-image> {:i (border\-image) ':'  <val(rx:s:i[ [ <border-image-source> | <border-image-slice> [ [ '/' <border-image-width> | '/' <border-image-width>? '/' <border-image-outset> ] ]? | <border-image-repeat> ]**1..3 ])> }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    token border-image-outset {:i [ [ <length> | <number> ] ]**1..4 }
    rule decl:sym<border-image-outset> {:i (border\-image\-outset) ':'  <val(rx:s:i[ <ref=.border-image-outset> ])> }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    token border-image-repeat {:i [ [ stretch | repeat | round | space ] & <keyw> ]**1..2 }
    rule decl:sym<border-image-repeat> {:i (border\-image\-repeat) ':'  <val(rx:s:i[ <ref=.border-image-repeat> ])> }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    token border-image-slice {:i [ [ <number> | <percentage> ] ]**1..4 }
    rule decl:sym<border-image-slice> {:i (border\-image\-slice) ':'  <val(rx:s:i[ <ref=.border-image-slice> ])> }

    # - border-image-source: none | <image>
    token border-image-source {:i none & <keyw> | <image> }
    rule decl:sym<border-image-source> {:i (border\-image\-source) ':'  <val(rx:s:i[ <ref=.border-image-source> ])> }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    token border-image-width {:i [ [ <length> | <percentage> | <number> | auto & <keyw> ] ]**1..4 }
    rule decl:sym<border-image-width> {:i (border\-image\-width) ':'  <val(rx:s:i[ <ref=.border-image-width> ])> }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    rule decl:sym<border-radius> {:i (border\-radius) ':'  <val(rx:s:i[ [ [ <length> | <percentage> ] ]**1..4 [ '/' [ [ <length> | <percentage> ] ]**1..4 ]? ])> }

    # - border-style: <border-style>{1,4}
    rule decl:sym<border-style> {:i (border\-style) ':'  <val(rx:s:i[ <ref=.border-style>**1..4 ])> }

    # - border-[top|right|bottom|left]: <border-width> || <border-style> || <color>
    rule border-width {:i <length> | [ thin | medium | thick ] & <keyw> }
    rule decl:sym<border-[top|right|bottom|left]> {:i (border\-[top|right|bottom|left]) ':'  <val(rx:s:i[ [ <border-width> | <border-style> | <color> ]**1..3 || ])> }

    # - border-[top|right|bottom|left]-color: <color>
    rule decl:sym<border-[top|right|bottom|left]-color> {:i (border\-[top|right|bottom|left]\-color) ':'  [ <color> || <misc> ] }

    # - border-[top-left|top-right|bottom-right|bottom-left]-radius: [ <length> | <percentage> ]{1,2}
    rule decl:sym<border-[top|bottom]-[left|right]-radius> {:i (border\-[top|bottom]\-[left|right]\-radius) ':'  <val(rx:s:i[ [ [ <length> | <percentage> ] ]**1..2 ])> }

    # - border-[top|right|bottom|left]-style: <border-style>
    rule decl:sym<border-[top|right|bottom|left]-style> {:i (border\-[top|right|bottom|left]\-style) ':'  <val(rx:s:i[ <border-style> ])> }

    # - border-[top|right|bottom|left]-width: <border-width>
    rule decl:sym<border-[top|right|bottom|left]-width> {:i (border\-[top|right|bottom|left]\-width) ':'  <val(rx:s:i[ <border-width> ])> }

    # - border-width: <border-width>{1,4}
    rule decl:sym<border-width> {:i (border\-width) ':'  <val(rx:s:i[ <ref=.border-width>**1..4 ])> }

    # - box-decoration-break: slice | clone
    rule decl:sym<box-decoration-break> {:i (box\-decoration\-break) ':'  <val(rx:s:i[ [ slice | clone ] & <keyw> ])> }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    rule shadow {:i [ <length> | <color> | inset & <keyw> ]+ }
    rule decl:sym<box-shadow> {:i (box\-shadow) ':'  <val(rx:s:i[ none & <keyw> | <shadow> +% ',' ])> }

}

class CSS::Language::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Language::CSS3::_Base::Actions {

    method image($/) {  make $<uri>.ast }
    method bg-image($/) {  make $.node($/) }
    method box($/) { make $.token($<keyw>.ast) }
    method repeat-style($/) { make $.node($/)}
    method bg-layer($/) { make $.node($/) }
    method final-bg-layer($/) { make $.node($/) }
    # - background: [ <bg-layer> , ]* <final-bg-layer>
    method decl:sym<background>($/) {
        make $._decl($0, $<val>, q{[ <bg-layer> , ]* <final-bg-layer>});
    }

    # - background-attachment: <attachment> [ , <attachment> ]*
    method attachment($/) { make $.node($/) }
    method decl:sym<background-attachment>($/) {
        make $._decl($0, $<val>, q{<attachment> [ , <attachment> ]*});
    }

    # - background-clip: <box> [ , <box> ]*
    # - background-origin: <box> [ , <box> ]*
    method decl:sym<background-[clip|origin]>($/) {
        make $._decl($0, $<val>, q{<box> [ , <box> ]*});
    }

    # - background-color: <color>
    method decl:sym<background-color>($/) {
        make $._decl($0, $<val>, q{<color>});
    }

    # - background-image: <bg-image> [ , <bg-image> ]*
    method decl:sym<background-image>($/) {
        make $._decl($0, $<val>, q{<bg-image> [ , <bg-image> ]*});
    }

    # - background-position: <position> [ , <position> ]*
    method position($/) { make $.list($/) }
    method decl:sym<background-position>($/) {
        make $._decl($0, $<val>, q{<position> [ , <position> ]*} );
    }

    # - background-repeat: <repeat-style> [ , <repeat-style> ]*
    method decl:sym<background-repeat>($/) {
        make $._decl($0, $<val>, q{<repeat-style> [ , <repeat-style> ]*});
    }

    # - background-size: <bg-size> [ , <bg-size> ]*
    method bg-size($/) { make $.list($/) }
    method decl:sym<background-size>($/) {
        make $._decl($0, $<val>, q{<bg-size> [ , <bg-size> ]*});
    }

    # - border: <border-width> || <border-style> || <color>
    method decl:sym<border>($/) {
        make $._decl($0, $<val>, q{<border-width> || <border-style> || <color>});
    }

    # - border-color: <color>{1,4}
    method decl:sym<border-color>($/) {
        make $._decl($0, $<val>, q{<color>{1,4}}, :expand<box>);
    }

    # - border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    method decl:sym<border-image>($/) {
        make $._decl($0, $<val>, q{<‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>});
    }

    # - border-image-outset: [ <length> | <number> ]{1,4}
    method border-image-outset($/) { make $.list($/) }
    method decl:sym<border-image-outset>($/) {
        make $._decl($0, $<val>, q{[ <length> | <number> ]{1,4}}, :expand<box>);
    }

    # - border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    method border-image-repeat($/) { make $.list($/) }
    method decl:sym<border-image-repeat>($/) {
        make $._decl($0, $<val>, q{[ stretch | repeat | round | space ]{1,2}});
    }

    # - border-image-slice: [<number> | <percentage>]{1,4} 
    method border-image-slice($/) { make $.list($/) }
    method decl:sym<border-image-slice>($/) {
        make $._decl($0, $<val>, q{[<number> | <percentage>]{1,4} }, :expand<box>);
    }

    # - border-image-source: none | <image>
    method border-image-source($/) { make $.list($/) }
    method decl:sym<border-image-source>($/) {
        make $._decl($0, $<val>, q{none | <image>});
    }

    # - border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    method border-image-width($/) { make $.list($/) }
    method decl:sym<border-image-width>($/) {
        make $._decl($0, $<val>, q{[ <length> | <percentage> | <number> | auto ]{1,4}}, :expand<box>);
    }

    # - border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    method decl:sym<border-radius>($/) {
        make $._decl($0, $<val>, q{[ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?}, :expand<box>);
    }

    # - border-style: <border-style>{1,4}
    method border-style($/) { make $.list($/) }
    method decl:sym<border-style>($/) {
        make $._decl($0, $<val>, q{<border-style>{1,4}}, :expand<box>);
    }

    # - border-[top|right|bottom|left]: <border-width> || <border-style> || <color>
    method border-width($/) { make $.node($/) }
    method decl:sym<border-[top|right|bottom|left]>($/) {
        make $._decl($0, $<val>, q{<border-width> || <border-style> || <color>});
    }

    # - border-[top|right|bottom|left]-color: <color>
    method decl:sym<border-[top|right|bottom|left]-color>($/) {
        make $._decl($0, $<val>, q{<color>});
    }

    # - border-[top-left|top-right|bottom-right|bottom-left]-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-[top|bottom]-[left|right]-radius>($/) {
        make $._decl($0, $<val>, q{[ <length> | <percentage> ]{1,2}});
    }

    # - border-[top|right|bottom|left]-style: <border-style>
    method decl:sym<border-[top|right|bottom|left]-style>($/) {
        make $._decl($0, $<val>, q{<border-style>});
    }

    # - border-[top|right|bottom|left]-width: <border-width>
    method decl:sym<border-[top|right|bottom|left]-width>($/) {
        make $._decl($0, $<val>, q{<border-width>});
    }

    # - border-width: <border-width>{1,4}
    method decl:sym<border-width>($/) {
        make $._decl($0, $<val>, q{<border-width>{1,4}}, :expand<box>);
    }

    # - box-decoration-break: slice | clone
    method decl:sym<box-decoration-break>($/) {
        make $._decl($0, $<val>, q{slice | clone});
    }

    # - box-shadow: none | <shadow> [ , <shadow> ]*
    method shadow($/) { make $.node($/) }
    method decl:sym<box-shadow>($/) {
        make $._decl($0, $<val>, q{none | <shadow> [ , <shadow> ]*});
    }

}
