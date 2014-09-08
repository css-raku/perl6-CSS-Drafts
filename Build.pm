use v6;

use CSS::Specification::Build;
use Panda::Builder;
use Panda::Common;

class Build is Panda::Builder {

    method build($where, Bool :$interfaces=True, Bool :$grammars=True, Bool :$actions=True ) {

        indir $where, {
            for ('etc/css3x-background-20120724.txt' => <CSS3 Backgrounds_and_Borders>,
                ) {
                my ($input-spec, $class-isa) = .kv;

                my @productions;

                @productions.push: 'interface'    => 'Interface'
                    if $interfaces;

                @productions.push: 'actions'   => 'Actions'
                    if $actions;

                @productions.push: 'grammar' => 'Grammar'
                    if $grammars;

                for @productions {
                    my ($type, $subclass) = .kv;
                    my $name = (<CSS Module>, @$class-isa, <Spec>,  $subclass).join('::');

                    my $class-dir = (<lib CSS Module>, @$class-isa, <Spec>).join('/');
                    mkdir $class-dir;

                    my $class-path = $class-dir ~ '/' ~ $subclass ~ '.pm';

                    my %opts = proforma  =>  $class-isa !=== <CSS1>
                        if $type eq 'grammar';

                    say "Building $input-spec => $name";
                    temp $*IN  = open $input-spec, :r;
                    temp $*OUT = open $class-path, :w;

                    CSS::Specification::Build::generate( $type, $name, |%opts );
                }
            }
        }
    }
}

# Build.pm can also be run standalone 
sub MAIN(Str $working-directory = '.', Bool :$interfaces=True, Bool :$grammars=True, Bool :$actions=True ) {
    Build.new.build($working-directory, :$interfaces, :$grammars, :$actions);
}
