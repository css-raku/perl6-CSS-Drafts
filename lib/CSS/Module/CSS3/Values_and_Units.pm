use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#
class CSS::Module::CSS3::Values_and_Units::Actions {...}
use CSS::AST :CSSValue;
use CSS::Module::CSS3::_Base;

grammar CSS::Module::CSS3::Values_and_Units
    is CSS::Module::CSS3::_Base {

    # -- Units -- #

    # add viewport as a new type of length-units
    token length-units:sym<viewport> {:i vw|vh|vmin|vmax}

    # override/extend css::grammar <rel-font-units> & <angle-units>
    token rel-font-units   {:i[em|ex|ch|rem]}
    token angle-units      {:i[deg|rad|rad|turn]}
    # override/extend css::language::css3::_base <resolution-units>
    token resolution-units {:i dp[i|cm|px]}

    # -- Math -- #

    rule math      {:i 'calc(' <calc=.sum> ')' }
    rule sum       { <product> *% [<.ws>$<op>=< + - ><.ws>] } 
    rule product   { <unit> [ $<op>='*' <unit> | $<op>='/' [<integer> | <number>] ]* }
    rule attr-expr {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' [ <unit> | <calc=.math> ] ]? ')' }
    rule unit      { <integer> | <number> | <dimension> | <percentage> | '(' <sum> ')' | <calc=.math> | <attr-expr> }

    token unit-name {<units=.angle-units>|<units=.length-units>|<units=.rel-font-units>|<units=.resolution-units>}

    token type {:i [string|color|url|integer|number|length|angle|time|frequency] & <keyw> }

    # extend module grammars
    rule length:sym<math>     {<math>}
    rule frequency:sym<math>  {<math>}
    rule angle:sym<math>      {<math>}
    rule time:sym<math>       {<math>}
    rule resolution:sym<math> {<math>}

    # implement proforma rules for attr() and toggle()
    # - see <val> rule in CSS::Specification::_Base.
    rule toggle-val { <val($*EXPR, $*USAGE)> }
    rule toggle     {:i 'toggle(' <toggle-val> +% ',' ')' }
    rule attr       {:i 'attr(' <attr-name=.qname> [<type>|<unit-name>]? [ ',' <val($*EXPR, $*USAGE)> ]? ')' }
    rule proforma:sym<toggle> { <toggle> }
    rule proforma:sym<attr>   { <attr> }
};

class CSS::Module::CSS3::Values_and_Units::Actions
    is CSS::Module::CSS3::_Base::Actions {

    method length-units:sym<viewport>($/) { make $.token( $/.lc, :type(CSSValue::LengthComponent) ) }
    method rel-font-units($/)             { make $.token( $/.lc, :type(CSSValue::LengthComponent) ) }
    method angle-units($/)                { make $.token( $/.lc, :type(CSSValue::AngleComponent) ) }
    method resolution-units($/)           { make $.token( $/.lc, :type(CSSValue::ResolutionComponent) ) }

    method math($/) { make $.token( $.node($/), :type( $<calc>.ast.type )) }

    method _coerce-types($lhs, $rhs) {
        return do {
            when $lhs eq $rhs                          {$lhs}
            when $lhs eq CSSValue::PercentageComponent {$rhs} 
            when $rhs eq CSSValue::PercentageComponent {$lhs} 
            when ($lhs, $rhs) (>=) (CSSValue::IntegerComponent, CSSValue::NumberComponent) {CSSValue::NumberComponent}
 
            default {Any}
        }
    }

    multi method _resolve-op-type('+', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _resolve-op-type('-', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _resolve-op-type('*', $lhs, $rhs) {

        my $Int = CSSValue::IntegerComponent;
        my $Num = CSSValue::NumberComponent;

        my $l-int = $lhs eq $Int;
        my $r-int = $rhs eq $Int;

        return do {
           when $l-int && $r-int {$Int}

           my $l-num = $l-int || $lhs eq $Num;
           my $r-num = $r-int || $rhs eq $Num;

           when $l-num && $r-num {$Num}
           when $r-num           {$lhs}
           when $l-num           {$rhs}
           default               {Any}
        }
    }

    multi method _resolve-op-type('/', $lhs, $rhs) {
        die "lhs of '/' has type {$rhs} - expected number or integer"
           unless $rhs eq CSSValue::NumberComponent | CSSValue::IntegerComponent;
        return CSSValue::NumberComponent
            if $lhs eq CSSValue::IntegerComponent;
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

    method toggle-val($/) {
        my $decl = $.decl( $/ );
        make $decl<expr>;
    }

    method toggle($/) { 
        my $vals = [ $<toggle-val>>>.ast ];
        return Any if $vals.grep: {! .defined};
        make $vals;
    }

    method attr($/) {
        my %ast = %( $.node($/) );
        if $<val> {
            %ast<val>:delete;
            %ast<fallback> = $.decl( $/ )<expr>;
        }

        my $type = $<type> && $<type>.ast;
        my $units;
        if $<unit-name> {
            $units = $<unit-name> && lc $<unit-name>;
        }
        else {
            $type //= CSSValue::StringComponent;
        }

        make $.token( %ast, :$type, :$units);
    }

    method proforma:sym<toggle>($/) { make $.node($/) }
    method proforma:sym<attr>($/)   { make $.node($/) }

    method attr-expr($/) {
        my $expr = $.list($/);
        my $type;
        my $units;

        if $<type> {
            $type = $<type>.ast;
        }
        elsif $<unit-name> {
            $units = $<unit-name>.lc;
            $type = CSS::AST::CSSUnits.enums{ $units }
                or die "unknown unit: $units";
        }
        else {
            $type = CSSValue::StringComponent;
        }

        make $.token( $expr, :type($type));
    }
    method unit($/) {
        my $item = $/.caps[0].value.ast;
        my $type = $item.type
            // ($item.units eq '%' && CSSValue::PercentageComponent);
        make $.token( $.node($/), :type($type) );
    }
    method type($/)      { make $<keyw>.ast }
    method unit-name($/) { make $<units>.ast }

    method _type-check-expr($expr, $base-type) {
        my $expr-ast = $expr.ast;

        my $expr-type = $expr-ast.type;
        unless $expr-type.defined {
            $.warning("incompatible types in expression", ~$/);
            return Any;
        }

        my $type = $._coerce-types($base-type, $expr-type);
        unless $type.defined {
            $.warning("expected an expresssion of type {$base-type}, got: {$expr-type}", ~$expr);
            return Any;
        }

        $expr-ast.type = $type;
        return $expr-ast;
    }

    method length:sym<math>($/)     { make $._type-check-expr($<math>, CSSValue::LengthComponent); }
    method frequency:sym<math>($/)  { make $._type-check-expr($<math>, CSSValue::FrequencyComponent); }
    method angle:sym<math>($/)      { make $._type-check-expr($<math>, CSSValue::AngleComponent); }
    method time:sym<math>($/)       { make $._type-check-expr($<math>, CSSValue::TimeComponent); }
    method resolution:sym<math>($/) { make $._type-check-expr($<math>, CSSValue::ResolutionComponent); }

};
