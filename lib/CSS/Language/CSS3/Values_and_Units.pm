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

    # -- Math -- #

    rule math    { <calc> | <attr> | <toggle> }
    token op     {<punct>}
    rule calc    {:i 'calc(' <sum> ')' }
    rule sum     { <product> +% [ ['+'|'-'] & <op> ] } 
    rule product { <unit> [ ['*' & <op>] <unit> | ['/' & <op>] <number> ]* }
    rule attr    {:i 'attr(' <qname> <type-or-unit>? [ ',' [ <unit> | <calc> ] ]? ')' }
    rule unit    { <number> | <dimension> | <percentage> | '(' <sum> ')' | <calc> | <attr> }

    token unit-name {<angle-units>|<distance-units>|<rel-font-units>|<resolution-units>}

    token type-or-unit {:i [string|color|url|integer|number|length|angle|time|frequency] & <keyw>
                                | <unit-name> }

    rule toggle {:i 'toggle(' <term> +% [ ',' ] ')' }

    # extend language grammars
    token length:sym<math>     {<math>}
    token angle:sym<math>      {<math>}
    token frequency:sym<math>  {<math>}
    token time:sym<math>       {<math>}
    token resolution:sym<math> {<math>}
    token color:sym<math>      {<math>}
    # todo: strings urls
    # todo: handle keyword toggling - ideally without complicating
    # property declarations.
    rule keyw-toggle           {:i 'toggle(' <ident> +% [ ',' ] }

    # override misc rule to catch and eventually handle toggled keywords
    rule misc                   {<keyw-toggle> | <proforma>**0..1 <any-arg>*}
};

class CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::_Base::Actions {

    method misc($/) {
        return $/.warn('tba - toggle(...) on keywords')
            if $<keyw-toggle>;

        make $<proforma>[0].ast
            if $<proforma> && !$<any-args>;
    }

};
