use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#

use CSS::Language::CSS3::Values::Units; # additional units
use CSS::Language::CSS3::Values::Funcs;  # calc(), attr() ...

grammar CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::Values::Units
    is CSS::Language::CSS3::Values::Funcs
{};

class CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::Values::Units::Actions
    is CSS::Language::CSS3::Values::Funcs::Actions
{};
