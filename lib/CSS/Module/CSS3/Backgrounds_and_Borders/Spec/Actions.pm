use v6;
#  -- DO NOT EDIT --
# generated by css-gen-properties.pl --class=CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions etc/css3x-background-20120724.txt

class CSS::Module::CSS3::Backgrounds_and_Borders::Spec::Actions {

    #| background: [ <bg-layer> , ]* <final-bg-layer>
    method decl:sym<background>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-attachment: <attachment> [ , <attachment> ]*
    method decl:sym<background-attachment>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-clip: <box> [ , <box> ]*
    method decl:sym<background-clip>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-color: <color>
    method decl:sym<background-color>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-image: <bg-image> [ , <bg-image> ]*
    method decl:sym<background-image>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-origin: <box> [ , <box> ]*
    method decl:sym<background-origin>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-position: <position> [ , <position> ]*
    method decl:sym<background-position>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-repeat: <repeat-style> [ , <repeat-style> ]*
    method decl:sym<background-repeat>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| background-size: <bg-size> [ , <bg-size> ]*
    method decl:sym<background-size>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border: <border-width> || <border-style> || <color>
    method decl:sym<border>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-color: <color>{1,4}
    method decl:sym<border-color>($/) { make $.decl($/, &?ROUTINE.WHY, :boxed) }

    #| border-image: <‘border-image-source’> || <‘border-image-slice’> [ / <‘border-image-width’> | / <‘border-image-width’>? / <‘border-image-outset’> ]? || <‘border-image-repeat’>
    method decl:sym<border-image>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-image-outset: [ <length> | <number> ]{1,4}
    method decl:sym<border-image-outset>($/) { make $.decl($/, &?ROUTINE.WHY, :boxed) }
    method expr-border-image-outset($/) { make $.list($/) }

    #| border-image-repeat: [ stretch | repeat | round | space ]{1,2}
    method decl:sym<border-image-repeat>($/) { make $.decl($/, &?ROUTINE.WHY) }
    method expr-border-image-repeat($/) { make $.list($/) }

    #| border-image-slice: [<number> | <percentage>]{1,4} && fill?
    method decl:sym<border-image-slice>($/) { make $.decl($/, &?ROUTINE.WHY) }
    method expr-border-image-slice($/) { make $.list($/) }

    #| border-image-source: none | <image>
    method decl:sym<border-image-source>($/) { make $.decl($/, &?ROUTINE.WHY) }
    method expr-border-image-source($/) { make $.list($/) }

    #| border-image-width: [ <length> | <percentage> | <number> | auto ]{1,4}
    method decl:sym<border-image-width>($/) { make $.decl($/, &?ROUTINE.WHY, :boxed) }
    method expr-border-image-width($/) { make $.list($/) }

    #| border-radius: [ <length> | <percentage> ]{1,4} [ / [ <length> | <percentage> ]{1,4} ]?
    method decl:sym<border-radius>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-style: <border-style>{1,4}
    method decl:sym<border-style>($/) { make $.decl($/, &?ROUTINE.WHY, :boxed) }

    #| border-top: <border-width> || <border-style> || <color>
    method decl:sym<border-top>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-right: <border-width> || <border-style> || <color>
    method decl:sym<border-right>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom: <border-width> || <border-style> || <color>
    method decl:sym<border-bottom>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-left: <border-width> || <border-style> || <color>
    method decl:sym<border-left>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-top-color: <color>
    method decl:sym<border-top-color>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-right-color: <color>
    method decl:sym<border-right-color>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom-color: <color>
    method decl:sym<border-bottom-color>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-left-color: <color>
    method decl:sym<border-left-color>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-top-left-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-top-left-radius>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-top-right-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-top-right-radius>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom-right-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-bottom-right-radius>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom-left-radius: [ <length> | <percentage> ]{1,2}
    method decl:sym<border-bottom-left-radius>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-top-style: <border-style>
    method decl:sym<border-top-style>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-right-style: <border-style>
    method decl:sym<border-right-style>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom-style: <border-style>
    method decl:sym<border-bottom-style>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-left-style: <border-style>
    method decl:sym<border-left-style>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-top-width: <border-width>
    method decl:sym<border-top-width>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-right-width: <border-width>
    method decl:sym<border-right-width>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-bottom-width: <border-width>
    method decl:sym<border-bottom-width>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-left-width: <border-width>
    method decl:sym<border-left-width>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| border-width: <border-width>{1,4}
    method decl:sym<border-width>($/) { make $.decl($/, &?ROUTINE.WHY, :boxed) }

    #| box-decoration-break: slice | clone
    method decl:sym<box-decoration-break>($/) { make $.decl($/, &?ROUTINE.WHY) }

    #| box-shadow: none | <shadow> [ , <shadow> ]*
    method decl:sym<box-shadow>($/) { make $.decl($/, &?ROUTINE.WHY) }
}
