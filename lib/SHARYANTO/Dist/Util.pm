package SHARYANTO::Dist::Util;

use 5.010001;
use strict;
use warnings;

use Config;
use File::Spec;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       packlist_for
                       list_dist_modules
               );

our $VERSION = '0.02'; # VERSION

sub packlist_for {
    my $mod = shift;

    unless ($mod =~ s/\.pm\z//) {
        $mod =~ s!::!/!g;
    }

    for (@INC) {
        return if ref($_);
        my $f = "$_/$Config{archname}/auto/$mod/.packlist";
        return $f if -f $f;
    }
    undef;
}

sub list_dist_modules {
    my $mod = shift;

    my $packlist = packlist_for($mod);
    return () unless $packlist;

    # path structure for .packlist: <libprefix> + <arch> + "auto" +
    # /Module/Name/ + "/.packlist". we want to get <libprefix>
    my $libprefix;
    {
        my ($vol, $dirs, $name) = File::Spec->splitpath(
            File::Spec->rel2abs($packlist));
        my @dirs = File::Spec->splitdir($dirs);
        for (0..@dirs-2) {
            if ($dirs[$_] eq $Config{archname} && $dirs[$_+1] eq 'auto') {
                $libprefix = File::Spec->catpath(
                    $vol, File::Spec->catdir(@dirs[0..$_-1]));
                last;
            }
        }
        die "Can't find libprefix for packlist $packlist" unless $libprefix;
    }

    open my($fh), "<", $packlist or return ();
    my @mods;
    while (my $l = <$fh>) {
        chomp $l;
        next unless $l =~ /\.pm\z/;
        $l =~ s/\A\Q$libprefix\E// or next;
        my @dirs = File::Spec->splitdir($l);
        shift @dirs; # ""
        shift @dirs if $dirs[0] eq $Config{archname};
        $dirs[-1] =~ s/\.pm\z//;
        push @mods, join("::", @dirs);
    }

    @mods;
}

1;
# ABSTRACT: Dist-related utilities

__END__

=pod

=encoding UTF-8

=head1 NAME

SHARYANTO::Dist::Util - Dist-related utilities

=head1 VERSION

version 0.02

=head1 SYNOPSIS

 use SHARYANTO::Dist::Util qw(
     packlist_for
     list_dist_modules
 );

 say packlist_for("Text::ANSITable"); # sample output: /home/steven/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2/x86_64-linux/auto/Text/ANSITable/.packlist
 my @mods = list_dist_modules("Text::ANSITable"); # -> ()

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 packlist_for($mod) => STR

Find C<.packlist> file for installed module C<$mod> (which can be in the form of
C<Package::SubPkg> or C<Package/SubPkg.pm>). Return undef if none is found.

Depending on the content of C<@INC>, the returned path may be absolute or
relative.

=head2 list_dist_modules($mod) => LIST

Given installed module name C<$mod> (which must be the name of the main module
of its distribution), list all the modules. This is done by first finding the
C<.packlist> file, then look at all the C<.pm> files listed in the packlist.

Will return empty list if fails to get the packlist.

=head1 SEE ALSO

L<SHARYANTO>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/SHARYANTO-Dist-Util>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-SHARYANTO-Dist-Util>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=SHARYANTO-Dist-Util>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
