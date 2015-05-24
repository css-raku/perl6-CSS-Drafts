use v6;
use Test;
use CSS::Drafts::MetaData;

is-deeply $CSS::Drafts::MetaData::property<azimuth>, {:default<center>, :level(2.1), :inherit, :synopsis("<angle> | [[ left-side | far-left | left | center-left | center | center-right | right | far-right | right-side ] || behind ] | leftwards | rightwards")}, 'azimuth';
is-deeply $CSS::Drafts::MetaData::property<border>, {:!inherit, :level(1.0), :synopsis("<'border-width'> || <'border-style'> || <color>")}, 'border';
is-deeply $CSS::Drafts::MetaData::property<border-style>, {:box, :default<none>, :!inherit, :level(1.0), :synopsis("[ none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset ]\{1,4}")}, 'border-style';
is-deeply $CSS::Drafts::MetaData::property<box-shadow>, {:default<none>, :!inherit, :level(3.0), :synopsis("none | <shadow>#")}, 'border-style';

done;
