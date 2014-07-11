use v6;

multi MAIN( Bool :$interfaces=True, Bool :$grammars=True, Bool :$actions=True ) {
    for (
         'etc/css3x-background-20120724.txt' => <CSS3 Backgrounds_and_Borders>,
        ) {
        my ($spec, $class-isa) = .kv;

        my @productions;

        @productions.push: 'role'    => 'Interface'
            if $interfaces;

        @productions.push: 'class'   => 'Actions'
            if $actions;

        @productions.push: 'grammar' => 'Grammar'
            if $grammars;

        for @productions {
            my ($opt, $subclass) = .kv;
            my $flags = $opt eq 'grammar' ?? ' --proforma' !! '';
            my $class-name = (<CSS Module>, @$class-isa, <Spec>,  $subclass).join('::');
            my $class-path = (<lib CSS Module>, @$class-isa, <Spec>, $subclass).join('/');
            my $perl6 = $*EXECUTABLE_NAME;
            # See CSS::Specification
            my $cmd = "perl6 css-gen-properties.pl --{$opt}={$class-name}$flags $spec > {$class-path}.pm";
            say $cmd;
            shell $cmd;
        }
    }
}
     
