use v6;
use Test;
use CSS::Drafts::CSS3::MetaData;

is-deeply $CSS::Drafts::CSS3::MetaData::property<azimuth>, {:default<center>, :inherit, :synopsis("<angle> | [[ left-side | far-left | left | center-left | center | center-right | right | far-right | right-side ] || behind ] | leftwards | rightwards")}, 'azimuth';
is-deeply $CSS::Drafts::CSS3::MetaData::property<border>, {:!inherit, :synopsis("<'border-width'> || <'border-style'> || <color>")}, 'border';
is-deeply $CSS::Drafts::CSS3::MetaData::property<border-style>, {:box, :default<none>, :!inherit, :synopsis("[ none | hidden | dotted | dashed | solid | double | groove | ridge | inset | outset ]\{1,4}")}, 'border-style';
is-deeply $CSS::Drafts::CSS3::MetaData::property<box-shadow>, {:default<none>, :!inherit, :synopsis("none | <shadow>#")}, 'border-style';

done;
