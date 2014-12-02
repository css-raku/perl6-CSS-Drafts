use v6;

# CSS3 Background and Borders Extension Module
# - reference: http://www.w3.org/TR/2012/CR-css3-background-20120724/
#
use CSS::Module::CSS3::_Base;

class CSS::Module::CSS3::Backgrounds_and_Borders::Actions {...}

use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Interface;
use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Grammar;
use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions;

grammar CSS::Module::CSS3::Backgrounds_and_Borders:ver<20120724.000>
    is CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Grammar
    is CSS::Module::CSS3::_Base
    does CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Interface {

    rule image      { <uri> }
    rule bg-layer($final?) { [:my @*SEEN; <expr-background-image> <!seen(0)> | <position> [ '/' <expr-background-size> ]? <!seen(1)> | <expr-background-repeat> <!seen(2)> | <attachment> <!seen(3)> | <expr-background-clip>**1..2 <!seen(4)> | <color> <!seen(5)> <?{$final}> ]+}
    rule final-bg-layer{ <bg-layer(True)> }
    # work around for RT#117955
##    rule position   {:i [ <percentage> | <length> | [ [ left | center | right | top | bottom ] & <keyw> ] [ <percentage> | <length> ] ? ] ** 1..2 }
    rule position   {:i [ <percentage> | <length> | <keyw( rx:i[ left | center | right | top | bottom ] )> [ <percentage> | <length> ] ? ] ** 1..2 }
    rule shadow     {:i [ <length> | <color> | inset & <keyw> ]+ }
    rule attachment {:i [ scroll | fixed | local ] & <keyw> }
    rule box        {:i [ border\-box | padding\-box | content\-box ] & <keyw> }
}

class CSS::Module::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions
    is CSS::Module::CSS3::_Base::Actions
    does CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Interface {

    method image($/)      { make $<uri>.ast }
    method bg-layer($/)   { make $.token( $.list($/), :type<expr:bg-layer> ) }
    method final-bg-layer($/) { make $<bg-layer>.ast }
    method position($/)   { make $.token( $.list($/), :type<expr:position> ) }
    method shadow($/)     { make $.token( $.list($/), :type<expr:shadow> ) }
    method attachment($/) { make $<keyw>.ast }
    method box($/)        { make $<keyw>.ast }

}
