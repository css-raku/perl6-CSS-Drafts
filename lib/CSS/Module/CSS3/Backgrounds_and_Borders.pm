use v6;

# CSS3 Background and Borders Extension Module
# - reference: http://www.w3.org/TR/2012/CR-css3-background-20120724/
#
class CSS::Module::CSS3::Backgrounds_and_Borders::Actions {...}

use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Interface;
use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Grammar;
use CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions;

grammar CSS::Module::CSS3::Backgrounds_and_Borders:ver<20120724.000>
    is CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Grammar {

    rule image        {<uri>}
    rule box          {:i [  border\-box | padding\-box | content\-box ] & <keyw> }
    rule bg-layer {:i [:my @*SEEN; <bg-image=.expr-background-image> <!seen(0)> | <position> [ '/' <bg-size> ]? <!seen(1)> | <repeat-style=.expr-background-repeat> <!seen(2)> | <attachment> <!seen(3)> | <box=.expr-background-clip>**1..2 <!seen(4)> ]+ }
    rule final-bg-layer { [ <bg-layer> | <color> ] ** 1..2}
    rule position {:i [ <percentage> | <length> | [ [ left | center | right | top | bottom ] & <keyw> ] [ <percentage> | <length> ] ? ] ** 1..2 }
    rule shadow {:i [ <length> | <color> | inset & <keyw> ]+ }
}

class CSS::Module::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions {

    method image($/) { make $<uri>.ast }
    method box($/) { make $.token($<keyw>.ast) }
    method bg-layer($/) { make $.list($/) }
    method final-bg-layer($/) { make $.list($/) }

    method position($/) { make $.list($/) }
    method shadow($/) { make $.list($/) }

}
