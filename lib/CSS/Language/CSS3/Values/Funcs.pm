use v6;

class CSS::Language::CSS3::Values::Funcs::Actions {...}

use CSS::Language::CSS3::_Base;
# CSS3 Values and Units Module Level 3 - functions
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#

grammar CSS::Language::CSS3::Values::Funcs::Syntax {
    #tba
}

grammar CSS::Language::CSS3::Values::Funcs:ver<20130404.000>
    is CSS::Language::CSS3::Values::Funcs::Syntax
    is CSS::Language::CSS3::_Base {}

class CSS::Language::CSS3::Values::Funcs::Actions
    is CSS::Language::CSS3::_Base::Actions {

}

