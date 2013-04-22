#!/usr/bin/env perl6

use Test;

use CSS::Grammar;
use CSS::Grammar::CSS3;
use CSS::Grammar::Actions;
use CSS::Language::CSS3::Namespaces;

# prepare our own composite class with namespace extensions

grammar t::CSS3::NamespaceGrammar
      is CSS::Language::CSS3::Namespaces
      is CSS::Grammar::CSS3
      {};

class t::CSS3::NamespaceActions
    is CSS::Language::CSS3::Namespaces::Actions
    is CSS::Grammar::Actions
{};

use lib '.';
use t::AST;

my $css_actions = t::CSS3::NamespaceActions.new;

for (
    at-decl => {input => 'namespace empty "";',
                ast => {"prefix" => "empty", "url" => "", '@' => "namespace"},
    },
    at-decl => {input => 'NAMESPACE "";',
                ast => {"url" => "", '@' => "namespace"},
    },
    at-decl => {input => 'namespace "http://www.w3.org/1999/xhtml";',
                ast => {"url" => "http://www.w3.org/1999/xhtml", '@' => "namespace"},
    },
    at-decl => {input => 'namespace svg "http://www.w3.org/2000/svg";',
                ast => {"prefix" => "svg", "url" => "http://www.w3.org/2000/svg", '@' => "namespace"},
    },
    stylesheet => {input => '@namespace toto url(http://toto.example.org);',
                ast => [at-rule => {"prefix" => "toto", "url" => "http://toto.example.org", '@' => "namespace"}],
    },
    ) {
    my $rule = $_.key;
    my %test = $_.value;
    my $input = %test<input>;

    $css_actions.reset;
    my $p3 = t::CSS3::NamespaceGrammar.parse( $input, :rule($rule), :actions($css_actions));
    t::AST::parse_tests($input, $p3, :rule($rule), :suite('css3-namespace'),
                         :warnings($css_actions.warnings),
                         :expected(%test) );
}

done;
