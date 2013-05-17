use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#
class CSS::Language::CSS3::Values_and_Units::Actions {...}

use CSS::Language::CSS3::_Base;

grammar CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::_Base {

    # -- Units -- #

    # add viewport as a new units family
    token distance-units:sym<rel-viewport> {:i vw|vh|vmin|vmax}

    # override/extend css::grammar <rel-font-units> & <angle-units>
    token rel-font-units {:i[em|ex|ch|rem]}
    token angle-units    {:i[deg|rad|rad|turn]}
    # override/extend css::language::css3::_base <resolution-units>
    token resolution-units {:i[dpi|dpcm|dppx]}

    # -- Functions -- #

    token op     {<punct>}
    rule math    {<calc> }
    rule calc    {:i 'calc(' <sum> ')' }
    rule sum     { <product> +% [['+'|'-'] & <op> ] } 
    rule product { <unit> [ ['*' & <op>] <unit> | ['/' & <op>] <number> ]* }
    rule attr    {:i 'attr(' <qname> <type-or-unit>? [ ',' [ <unit> | <calc> ] ]? ')' }
    rule unit    { <number> | <dimension> | <percentage> | '(' <sum> ')' | <calc> | <attr> }

    rule toggle {:i 'toggle(' <term> +% [ ',' ] ')' }

    token unit-name {<angle-units>|<distance-units>|<rel-font-units>|<resolution-units>}
    token type-or-unit {:i [string|color|url|integer|number|length|angle|time|frquency] & <keyw> | <unit-name> }


};

class CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::_Base::Actions {

};
