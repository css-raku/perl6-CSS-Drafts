use v6;

# This class implements CSS3 Values and Units Module Level 3
# - reference: http://www.w3.org/TR/2013/CR-css3-values-20130404/
#
class CSS::Module::CSS3::Values_and_Units::Actions {...}
use CSS::Grammar::AST :CSSValue;
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

    rule math      {:i 'calc(' <sum> ')' }
    rule sum       { <product> *% [ <op(rx/< + - >/)> ] } 
    rule product   { <unit> [ <op('*')> <unit> | <op('/')> [<integer> | <number>] ]* }
    rule attr-expr {:i 'attr(' <qname> [[<.type>|<.unit-name>] && <keyw>]? [ ',' [ <unit> | <calc=.math> ] ]? ')' }
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
    rule toggle-arg { <val($*EXPR, $*USAGE)> }
    rule toggle     {:i 'toggle(' <expr=.toggle-arg> +% ',' ')' }
    rule attr       {:i 'attr(' <qname> [[<.type>|<.unit-name>] && <keyw>]? [ <op(',')> <val($*EXPR, $*USAGE)> ]? ')' }
    rule proforma:sym<toggle> { <toggle> }
    rule proforma:sym<attr>   { <attr> }
};

class CSS::Module::CSS3::Values_and_Units::Actions
    is CSS::Module::CSS3::_Base::Actions {

    role Cast {
        has $.cast is rw;
    }

    method cast($node is copy, :$cast is copy, :$type) {

        $node = $.token($node, :$type)
            if $type.defined;

        $node.value does Cast
            unless $node.value.can('cast');

        # map units to base type. E.g. ms => time
        if my $units-type = CSS::Grammar::AST::CSSUnits.enums{$cast} {
            $cast = $units-type;
        }

        $node.value.cast = $cast if $cast.defined;

        return $node;
    }

    method length-units:sym<viewport>($/) { make $/.lc }
    method rel-font-units($/)             { make $/.lc }
    method angle-units($/)                { make $/.lc }
    method resolution-units($/)           { make $/.lc }

    method math($/) {
        make $.cast( $.func( 'calc', $<sum>.ast, :arg-type<expr>),
                      :cast( $<sum>.ast.value.cast ) );
    }

    method _coerce-types($lhs, $rhs) {
        return do {
            when $lhs eq $rhs                          {$lhs}
            when $lhs eq CSSValue::PercentageComponent {$rhs} 
            when $rhs eq CSSValue::PercentageComponent {$lhs} 
            when ($lhs, $rhs) (>=) (CSSValue::IntegerComponent, CSSValue::NumberComponent) {CSSValue::NumberComponent}
 
            default {Any}
        }
    }

    multi method _cast-operands('+', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _cast-operands('-', $lhs, $rhs) {
        return $._coerce-types($lhs, $rhs);
    }

    multi method _cast-operands('*', $lhs, $rhs) {

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

    multi method _cast-operands('/', $lhs, $rhs) {
        die "lhs of '/' has type {$rhs} - expected number or integer"
            unless $rhs eq CSSValue::NumberComponent | CSSValue::IntegerComponent;
        return CSSValue::NumberComponent
            if $lhs eq CSSValue::IntegerComponent;
        return $lhs;
    }

    method _cast-chained-expr($expr-ast) {
        my ($lhs-ast, @rhs) = @$expr-ast;
        my ($lhs) = $lhs-ast.values;
        my $cast = $lhs.cast // $lhs.type;

        for @rhs -> $op-ast, $rhs-ast {
            my ($op) = $op-ast.values;
            my ($rhs) = $rhs-ast.values;

            my $rhs-type = $rhs.can('cast') && $rhs.cast || $rhs-ast.keys[0];

            $cast = $._cast-operands($op, $cast, $rhs-type);
            $lhs = $rhs;
        }
        return $cast;
    }

    method sum ($/) {
        my $expr = $.list($/);
        my $cast = $._cast-chained-expr($expr);
        make $.cast( $expr, :type<expr>, :$cast );
    }

    method product($/) {
        my $expr = $.list($/);
        my $cast = $._cast-chained-expr($expr);
        make $.cast( $expr, :type<expr>, :$cast );
    }

    method toggle-arg($/) {
        my $decl = $.decl( $/ );
        make $decl<expr>;
    }

    method toggle($/) { 
        return Any if $<expr>>>.ast.grep: {! .defined};
        my $args = $.list( $/ ).map: {
            # rule may have consumed argumments, e.g. font-family
            .<expr>:exists && .<expr>.first({.<op> && .<op> eq ','})
            ?? .<expr>.grep({!.<op> || .<op> ne ','}).map: { %( expr => [$_] ).item }
            !! $_;
        }

        make $.func('toggle', $args);
    }

    method attr($/) {
        my @ast = @( $.list($/) );
        if $<val> {
            @ast[*-1] = {'expr:fallback' => $.decl( $/ )<expr>};
        }

        make $.func( 'attr', @ast, :arg-type<expr> );
    }

    method proforma:sym<toggle>($/) { make $.node($/) }
    method proforma:sym<attr>($/)   { make $.node($/) }

    method attr-expr($/) {
        make $.func( 'attr', $.list($/) );
    }

    method unit($/) {
        my $item = $/.caps[0].value.ast;
        $item = $.cast( $item, :cast($item.key) )
            unless $item.value.can('cast') && $item.value.cast;
        make $item;
    }

    method _cast-expr($expr, $base-type) {
        my $expr-ast = $expr.ast;

        my $expr-type = $expr-ast.value.cast;
        unless $expr-type.defined {
            $.warning("incompatible types in expression", ~$/);
            return Any;
        }

        my $cast = $._coerce-types($base-type, $expr-type);
        unless $cast.defined {
            $.warning("expected an expresssion of type {$base-type}, got: {$expr-type}", ~$expr);
            return Any;
        }

        $expr-ast.value.cast = $cast;
        return $expr-ast;
    }

    method length:sym<math>($/)     { make $._cast-expr($<math>, CSSValue::LengthComponent); }
    method frequency:sym<math>($/)  { make $._cast-expr($<math>, CSSValue::FrequencyComponent); }
    method angle:sym<math>($/)      { make $._cast-expr($<math>, CSSValue::AngleComponent); }
    method time:sym<math>($/)       { make $._cast-expr($<math>, CSSValue::TimeComponent); }
    method resolution:sym<math>($/) { make $._cast-expr($<math>, CSSValue::ResolutionComponent); }

};
