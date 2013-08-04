#!/usr/bin/env perl6

use Test;
use JSON::Tiny;

use CSS::Language::CSS3::Backgrounds_and_Borders;
use CSS::Language::CSS3::CSS21_Imported;
use CSS::Grammar::Test;

my $css3x_actions = CSS::Language::CSS3::Backgrounds_and_Borders::Actions.new;
my $css21_actions = CSS::Language::CSS3::CSS21_Imported::Actions.new;

my $fh = open 't/css3x-backgrounds-and-borders.json', :r;

for ( $fh.lines ) {

    if .substr(0,2) eq '//' {
##        note '[' ~ .substr(2) ~ ']';
        next;
    }
    my ($rule, %test) = @( from-json($_) );
    my $input = %test<input>;

    $css3x_actions.reset;
    my $p3 = CSS::Language::CSS3::Backgrounds_and_Borders.parse( $input, :rule($rule), :actions($css3x_actions));

    CSS::Grammar::Test::parse_tests($input, $p3, :rule($rule), :suite('css3-backgrounds'),
                         :warnings($css3x_actions.warnings),
                         :expected(%test) );

    $css21_actions.reset;
    my $css21 = %test<css21> // {};
    my %css21_expected = (%test, %$css21);

    my $p-css21 = CSS::Language::CSS3::CSS21_Imported.parse( $input, :rule($rule), :actions($css21_actions));

    CSS::Grammar::Test::parse_tests($input, $p-css21, :rule($rule), :suite('css21'),
                         :warnings($css21_actions.warnings),
                         :expected(%css21_expected) );
}

done;
