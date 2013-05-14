use v6;

class CSS::Language::CSS3::Units::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Values and Units Module Level 3
# includes additional units and mathematical expressions calc()
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#

grammar CSS::Language::CSS3::Units::Syntax {

    token distance-units:sym<rel-viewport> {:i vw|vh|vmin|vmax}

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

