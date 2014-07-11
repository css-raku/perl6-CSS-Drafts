use v6;

# volatile grammars and classes; likely to vary over-time

use CSS::Module::CSS3::Values_and_Units;
use CSS::Module::CSS3::Backgrounds_and_Borders;
use CSS::Module::CSS3;

grammar CSS::Drafts::CSS3
    is CSS::Module::CSS3::Values_and_Units
    is CSS::Module::CSS3::Backgrounds_and_Borders
    is CSS::Module::CSS3
{};

class CSS::Drafts::CSS3::Actions
    is CSS::Module::CSS3::Values_and_Units::Actions
    is CSS::Module::CSS3::Backgrounds_and_Borders::Actions
    is CSS::Module::CSS3::Actions
    {};
