use v6;

class CSS::Language::CSS3::Values::Units::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Values and Units Module Level 3 - Units
# includes additional units and mathematical expressions calc()
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#

grammar CSS::Language::CSS3::Values::Units::Syntax {

    # add viewport as a new units family
    token distance-units:sym<rel-viewport> {:i vw|vh|vmin|vmax}

    # override/extend css::grammar <rel-font-units> & <angle-units>
    token rel-font-units {:i[em|ex|ch|rem]}
    token angle-units    {:i[deg|rad|rad|turn]}
    # override/extend css::language::css3::_base <resolution-units>
    token resolution-units {:i[dpi|dpcm|dppx]}

}

grammar CSS::Language::CSS3::Values::Units:ver<20130404.000>
    is CSS::Language::CSS3::Values::Units::Syntax
    is CSS::Language::CSS3::_Base {

    # ---- Properties ----#

}

class CSS::Language::CSS3::Values::Units::Actions
    is CSS::Language::CSS3::_Base::Actions {

}

