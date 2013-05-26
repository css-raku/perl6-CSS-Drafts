use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#
class CSS::Language::CSS3::Values_and_Units::Actions {...}

use CSS::Language::CSS3::_Base;

grammar CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::_Base {

    # -- Units -- #

    # add viewport as a new type of distance-units
    token distance-units:sym<viewport> {:i vw|vh|vmin|vmax}

    # override/extend css::grammar <rel-font-units> & <angle-units>
    token rel-font-units   {:i[em|ex|ch|rem]}
    token angle-units      {:i[deg|rad|rad|turn]}
    # override/extend css::language::css3::_base <resolution-units>
    token resolution-units {:i[dpi|dpcm|dppx]}

    # -- Math -- #

    rule math      {:i 'calc(' <calc=.sum> ')' }
    rule sum       { <product> *% [<.ws>$<op>=['+'|'-']<.ws>] } 
    rule product   { <unit> [ $<op>='*' <unit> | $<op>='/' [<integer> | <number>] ]* }
    rule attr-expr {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' [ <unit> | <calc> ] ]? ')' }
    rule unit      { <integer> | <number> | <dimension> | <percentage> | '(' <sum> ')' | <calc> | <attr-expr> }

    token unit-name {<units=.angle-units>|<units=.distance-units>|<units=.rel-font-units>|<units=.resolution-units>}

    token type {:i [string|color|url|integer|number|length|angle|time|frequency] & <keyw> }

    # extend language grammars
    token length:sym<math>     {<math>}
    token frequency:sym<math>  {<math>}
    token angle:sym<math>      {<math>}
    token time:sym<math>       {<math>}
    token resolution:sym<math> {<math>}

    # override property val rule to enable funky property handling,
    # i.e. expression toggling attributes
    # experimental!? can you toggle inherit, initial !?
    rule toggle($expr) {:i 'toggle(' $<expr>=$expr:i +% [ ',' ] ')' }
    rule attr($expr)   {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' $<fallback>=$expr:i ]? ')' }
    rule val($expr)    {:i <toggle($expr)> | <attr($expr)> | $<expr>=$expr:i || <misc> } 

    #
    # extend core grammar
    token term:sym<math>       {<math>}

};

class CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::_Base::Actions {

    method val($/) {
        my $node = $<toggle> || $<attr> ?? $/ !! $<expr>;
        make $.node($node);
    }

    method distance-units:sym<viewport>($/) { make $.token( $/.Str.lc, :type<length> ) }
    method rel-font-units($/) { make $.token( $/.Str.lc, :type<length> ) }
    method angle-units($/) { make $.token( $/.Str.lc, :type<angle> ) }
    method resolution-units($/) { make $.token( $/.Str.lc, :type<resolution> ) }

    method math($/) { make $.token( $.node($/), :type( $/.caps[0].value.ast.type )) }

    method _coerce-types($lhs, $rhs) {
        return $lhs if $lhs eq $rhs;
        return 'number' if ($lhs, $rhs).sort eqv ('integer', 'number');
        return $rhs if $lhs eq 'percentage';
        return $lhs if $rhs eq 'percentage';
        return 'incompatible';
    }

    method _resolve-op-type:sym<+>($lhs,$rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    method _resolve-op-type:sym<->($lhs,$rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    method _resolve-op-type:sym<*>($lhs,$rhs) {

        my $l-int = $lhs eq 'integer';
        my $r-int = $rhs eq 'integer';

        return 'integer' if $l-int && $r-int;

        my $l-num = $l-int || $lhs eq 'number';
        my $r-num = $r-int || $rhs eq 'number';

        return 'number' if $l-num && $r-num;
        return $lhs if $r-num;
        return $rhs if $l-num;
        return 'incompatible';
    }

    method _resolve-op-type:sym</>($lhs,$rhs) {
       die "lhs of '/' has type {$rhs} - expected number or integer"
           unless $rhs eq 'number' || $rhs eq 'integer';
        return 'number' if $lhs eq 'integer';
        return $lhs;
    }

    method _resolve-expr-type($expr-ast) {
        my ($lhs-ast, @rhs) = @$expr-ast;
        my $lhs = $lhs-ast.value;
        my $type = $lhs.type;

        for @rhs -> $op-ast, $rhs-ast {
            my $op = $op-ast.value;
            my $rhs = $rhs-ast.value;

            my $derived-type = self."_resolve-op-type:sym<$op>"($type, $rhs.type);
            $type = $derived-type;
            $lhs = $rhs;
        }
        return $type;
    }

    method sum ($/) {
        my $expr = $.list($/, :capture<op>);
        my $type = $._resolve-expr-type($expr);
        make $.token( $expr, :type($type));
    }

    method product ($/) {
        my $expr = $.list($/, :capture<op>);
        my $type = $._resolve-expr-type($expr);
        make $.token( $expr, :type($type));
    }

    method toggle($/) { make [ $<expr>.map({$.node($_)}) ] }

    method attr($/) {
        my %ast = $.node($/);

        %ast<fallback> = $.list($<fallback>)
            if $<fallback>;

        my $type = $<type> && $<type>.ast;
        $type //= $<unit-name> && $<unit-name>.ast.type;
        $type //= 'string';

        make $.token( %ast, :type($type));
    }

    method attr-expr($/) {
        my $expr = $.list($/);
        my $type = $<type> && $<type>.ast;
        $type //= $<unit-name> && $<unit-name>.ast.type;
        $type //= 'string';
        make $.token( $expr, :type($type));
    }
    method unit($/)      { make $.token( $.node($/), :type($/.caps[0].value.ast.type)) }
    method type($/)      { make $<keyw>.ast }
    method unit-name($/) { make $<units>.ast }

    method _grok-expr($expr, $base-type) {
        my $expr-ast = $expr.ast;

        my $expr-type = $expr-ast.type;
        if $expr-type eq 'incompatible' {
            $.warning("incompatible types in expression", $/.Str);
            return Any;
        }

        my $type = $._coerce-types($base-type, $expr-type);
        if $type eq 'incompatible' {
            $.warning("expected an expresssion of type {$base-type}, got: {$expr-type}", $/.Str);
            return Any;
        }

        $expr-ast.type = $type;
        return $expr-ast;
    }

    method length:sym<math>($/)  { make $._grok-expr($<math>, <length>); }
    method frequency:sym<math>($/) { make $._grok-expr($<math>, <frequency>); }
    method angle:sym<math>($/) { make $._grok-expr($<math>, <angle>); }
    method time:sym<math>($/) { make $._grok-expr($<math>, <time>); }
    method resolution:sym<math>($/) { make $._grok-expr($<math>, <resolution>); }

};
