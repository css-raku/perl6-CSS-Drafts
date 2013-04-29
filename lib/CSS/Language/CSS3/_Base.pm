use v6;

use CSS::Grammar::CSS3;
use CSS::Language::Actions;

grammar CSS::Language::CSS3::_Base
    is CSS::Grammar::CSS3 {
        # http://www.w3.org/TR/2013/CR-css3-values-20130404/ 3.1.1
        # - all properties accept the 'initial' and 'inherit' keywords
        token integer     {[\+|\-]?\d+ <!before ['%'|\w|'.']>}
        token number      {<num> <!before ['%'|\w]>}
        token uri         {<url>}
        token keyw        {<ident>}           # keywords (case insensitive)
        token identifier  {<name>}            # identifiers (case sensitive)
        rule identifiers  {[ <identifier> ]+} # sequence of identifiers
        token inherit     {:i inherit}
        token initial     {:i initial}
        token misc        { <inherit> | <initial> || <any-args> }
}

class CSS::Language::CSS3::_Base::Actions 
    is CSS::Language::Actions {
}
