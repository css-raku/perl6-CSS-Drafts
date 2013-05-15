use v6;

class CSS::Language::CSS3::Units::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Values and Units Module Level 3
# includes additional units and mathematical expressions calc()
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#

grammar CSS::Language::CSS3::Units::Syntax {

    # add viewport as a new units family
    token distance-units:sym<rel-viewport> {:i vw|vh|vmin|vmax}

    # override css::grammar <rel-font-units> & <angle-units>
    token rel-font-units {:i[em|ex|ch|rem]}
    token angle-units    {:i[deg|rad|rad|turn]}
    # override css::language::css3::_base <resolution-units>
    # css::language::css3::mediaqueries makes use of this
    token resolution-units {:i[dpi|dpcm|dppx]}

}

grammar CSS::Language::CSS3::Units:ver<20120724.000>
    is CSS::Language::CSS3::Units::Syntax
    is CSS::Language::CSS3::_Base {

    # ---- Properties ----#

}

class CSS::Language::CSS3::Units::Actions
    is CSS::Language::CSS3::_Base::Actions
 {

}

