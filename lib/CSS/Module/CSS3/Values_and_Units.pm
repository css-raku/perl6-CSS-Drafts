use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#
class CSS::Module::CSS3::Values_and_Units::Actions {...}
use CSS::Module::CSS3::_Base;

grammar CSS::Module::CSS3::Values_and_Units
    is CSS::Module::CSS3::_Base {

    # -- Units -- #

    # add viewport as a new type of distance-units
    token distance-units:sym<viewport> {:i vw|vh|vmin|vmax}

    # override/extend css::grammar <rel-font-units> & <angle-units>
    token rel-font-units   {:i[em|ex|ch|rem]}
    token angle-units      {:i[deg|rad|rad|turn]}
    # override/extend css::language::css3::_base <resolution-units>
    token resolution-units {:i dp[i|cm|px]}

    # -- Math -- #

    rule math      {:i 'calc(' <calc=.sum> ')' }
    rule sum       { <product> *% [<.ws>$<op>=['+'|'-']<.ws>] } 
    rule product   { <unit> [ $<op>='*' <unit> | $<op>='/' [<integer> | <number>] ]* }
    rule attr-expr {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' [ <unit> | <calc=.math> ] ]? ')' }
    rule unit      { <integer> | <number> | <dimension> | <percentage> | '(' <sum> ')' | <calc=.math> | <attr-expr> }

    token unit-name {<units=.angle-units>|<units=.distance-units>|<units=.rel-font-units>|<units=.resolution-units>}

    token type {:i [string|color|url|integer|number|length|angle|time|frequency] & <keyw> }

    # extend language grammars
    rule length:sym<math>     {<math>}
    rule frequency:sym<math>  {<math>}
    rule angle:sym<math>      {<math>}
    rule time:sym<math>       {<math>}
    rule resolution:sym<math> {<math>}

    # override property val rule to enable funky property handling,
    # i.e. expression toggling attributes
    rule toggle($expr) {:i 'toggle(' <val($*EXPR)> +% [ ',' ] ')' }
    rule attr($expr)   {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' <fallback=.val($*EXPR)> ]? ')' }
    rule proforma:sym<toggle> { <toggle($*EXPR)> }
    rule proforma:sym<attr>   { <attr($*EXPR)> }

    #
    # extend core grammar
    rule term:sym<math>       {<math>}

};

class CSS::Module::CSS3::Values_and_Units::Actions
    is CSS::Module::CSS3::_Base::Actions {

    method distance-units:sym<viewport>($/) { make $.token( (~$/).lc, :type<length> ) }
    method rel-font-units($/) { make $.token(   (~$/).lc, :type<length> ) }
    method angle-units($/) { make $.token(      (~$/).lc, :type<angle> ) }
    method resolution-units($/) { make $.token( (~$/).lc, :type<resolution> ) }

    method math($/) { make $.token( $.node($/), :type( $<calc>.ast.type )) }

    method _coerce-types($lhs, $rhs) {
        return do {
            when $lhs eq $rhs             {$lhs}
            when $lhs eq 'percentage'     {$rhs} 
            when $rhs eq 'percentage'     {$lhs} 
            when ($lhs, $rhs).sort
                eqv ('integer', 'number') {'number'}
 
            default {'incompatible'}
        }
    }

    multi method _resolve-op-type('+', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _resolve-op-type('-', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _resolve-op-type('*', $lhs, $rhs) {

        my $l-int = $lhs eq 'integer';
        my $r-int = $rhs eq 'integer';

        return do {
           when $l-int && $r-int {'integer'}

           my $l-num = $l-int || $lhs eq 'number';
           my $r-num = $r-int || $rhs eq 'number';

           when $l-num && $r-num {'number'}
           when $r-num           {$lhs}
           when $l-num           {$rhs}
           default               {'incompatible'}
        }
    }

    multi method _resolve-op-type('/', $lhs, $rhs) {
        die "lhs of '/' has type {$rhs} - expected number or integer"
           unless $rhs eq 'number' || $rhs eq 'integer';
        return 'number' if $lhs eq 'integer';
        return $lhs;
    }

    method _resolved-chained-expr($expr-ast) {
        my ($lhs-ast, @rhs) = @$expr-ast;
        my ($lhs) = $lhs-ast.values;
        my $type = $lhs.type;

        for @rhs -> $op-ast, $rhs-ast {
            my ($op) = $op-ast.values;
            my ($rhs) = $rhs-ast.values;

            my $rhs-type = $rhs.type;

            my $derived-type = $._resolve-op-type($op, $type, $rhs-type);
            $type = $derived-type;
            $lhs = $rhs;
        }
        return $type;
    }

    method sum ($/) {
        my $expr = $.list($/, :capture<op>);
        my $type = $._resolved-chained-expr($expr);
        make $.token( $expr, :type($type));
    }

    method product ($/) {
        my $expr = $.list($/, :capture<op>);
        my $type = $._resolved-chained-expr($expr);
        make $.token( $expr, :type($type));
    }

    method toggle($/) { 
        my @expr = $<val>>>.ast;
        make @expr;
    }

    method attr($/) {
        my %ast = %( $.node($/) );

        my $type = $<type> && $<type>.ast;
        $type //= $<unit-name> && $<unit-name>.ast.type;
        $type //= 'string';

        make $.token( %ast, :type($type));
    }

    method proforma:sym<toggle>($/) { make $.node($/) }
    method proforma:sym<attr>($/) { make $.node($/) }

    method attr-expr($/) {
        my $expr = $.list($/);
        my $type = $<type> && $<type>.ast;
        $type //= $<unit-name> && $<unit-name>.ast.type;
        $type //= 'string';
        make $.token( $expr, :type($type));
    }
    method unit($/) {
        my $item = $/.caps[0].value.ast;
        my $type = $item.type
            // ($item.units eq '%' && 'percentage');
        make $.token( $.node($/), :type($type) );
    }
    method type($/)      { make $<keyw>.ast }
    method unit-name($/) { make $<units>.ast }

    method _grok-expr($expr, $base-type) {
        my $expr-ast = $expr.ast;

        my $expr-type = $expr-ast.type;
        if $expr-type eq 'incompatible' {
            $.warning("incompatible types in expression", ~$/);
            return Any;
        }

        my $type = $._coerce-types($base-type, $expr-type);
        if $type eq 'incompatible' {
            $.warning("expected an expresssion of type {$base-type}, got: {$expr-type}", ~$expr);
            return Any;
        }

        $expr-ast.type = $type;
        return $expr-ast;
    }

    method length:sym<math>($/)     { make $._grok-expr($<math>, <length>); }
    method frequency:sym<math>($/)  { make $._grok-expr($<math>, <frequency>); }
    method angle:sym<math>($/)      { make $._grok-expr($<math>, <angle>); }
    method time:sym<math>($/)       { make $._grok-expr($<math>, <time>); }
    method resolution:sym<math>($/) { make $._grok-expr($<math>, <resolution>); }

};
