use v6;

# CSS3 Background and Borders Extension Module
# - reference: http://www.w3.org/TR/2012/CR-css3-background-20120724/
#
class CSS::Language::CSS3::Backgrounds_and_Borders::Actions {...}

use CSS::Language::CSS3::_Base;
use CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Interface;
use CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Grammar;
use CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Actions;

grammar CSS::Language::CSS3::Backgrounds_and_Borders:ver<20120724.000>
    is CSS::Language::CSS3::_Base
    is CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Grammar
    does CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Interface {

    rule attachment   {:i [ scroll | fixed | local ] & <keyw> }
    rule image        {<uri>}
    rule bg-image     {:i <image> | none & <keyw> }
    rule box          {:i [  border\-box | padding\-box | content\-box ] & <keyw> }
    rule repeat-style {:i [ repeat\-x | repeat\-y ] & <keyw>
                           | [ [repeat | space | round | no\-repeat] & <keyw> ] ** 1..2 }
    rule bg-layer {:i [ <bg-image> | <position> [ '/' <bg-size> ]? | <repeat-style> | <attachment> | <box>**1..2 ] ** 1..5 }
    rule final-bg-layer { [ <bg-layer> | <color> ] ** 1..2}
    rule position {:i [ <percentage> | <length> | [ [ left | center | right | top | bottom ] & <keyw> ] [ <percentage> | <length> ] ? ] ** 1..2 }
    rule bg-size {:i [ <length> | <percentage> | auto & <keyw> ] ** 1..2 | [cover | contain ] & <keyw> }
    rule border-style {:i [ none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset ] & <keyw> }
    rule border-width {:i <length> | [ thin | medium | thick ] & <keyw> }
    rule shadow {:i [ <length> | <color> | inset & <keyw> ]+ }
}

class CSS::Language::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Language::CSS3::_Base::Actions
    is CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Actions
    does CSS::Language::CSS3::Backgrounds_and_Borders::Spec::Interface {

    method image($/) { make $<uri>.ast }
    method bg-image($/) {  make $.list($/) }
    method box($/) { make $.token($<keyw>.ast) }
    method repeat-style($/) { make $.list($/)}
    method bg-layer($/) { make $.list($/) }
    method final-bg-layer($/) { make $.list($/) }

    method attachment($/) { make $.list($/) }
    method position($/) { make $.list($/) }
    method bg-size($/) { make $.list($/) }
    method border-style($/) { make $.list($/) }
    method border-width($/) { make $.list($/) }
    method shadow($/) { make $.list($/) }

}
