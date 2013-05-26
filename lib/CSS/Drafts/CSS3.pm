use v6;

# volatile class; likely to vary over-time

use CSS::Language::CSS3::Values_and_Units;
use CSS::Language::CSS3::Backgrounds_and_Borders;
use CSS::Language::CSS3;

grammar CSS::Drafts::CSS3
    is CSS::Language::CSS3::Values_and_Units
    is CSS::Language::CSS3::Backgrounds_and_Borders
    is CSS::Language::CSS3
{};

class CSS::Drafts::CSS3::Actions
    is CSS::Language::CSS3::Values_and_Units::Actions
    is CSS::Language::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Language::CSS3::Actions
    {};
