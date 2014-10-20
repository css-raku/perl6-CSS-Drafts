use v6;

use CSS::Specification::Build;
use Panda::Builder;
use Panda::Common;

class Build is Panda::Builder {

    method build($where) {

        indir $where, {
            for ('etc/css3x-background-20120724.txt' => <CSS3 Backgrounds_and_Borders>,
                ) {
                my ($input-spec, $class-isa) = .kv;

                for interface => 'Interface',
                    actions => 'Actions',
                    grammar => 'Grammar' {
                    my ($type, $subclass) = .kv;
                    my $name = (<CSS Module>, @$class-isa, <Spec>,  $subclass).join('::');

                    my $class-dir = (<lib CSS Module>, @$class-isa, <Spec>).join('/');
                    mkdir $class-dir;

                    my $class-path = $class-dir ~ '/' ~ $subclass ~ '.pm';

                    say "Building $input-spec => $name";
                    temp $*IN  = open $input-spec, :r;
                    temp $*OUT = open $class-path, :w;

                    CSS::Specification::Build::generate( $type, $name );
                }
            }
        }
    }
}

# Build.pm can also be run standalone 
sub MAIN(Str $working-directory = '.') {
    Build.new.build($working-directory);
}
