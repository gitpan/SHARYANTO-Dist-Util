package SHARYANTO::Dist::Util;

use 5.010001;
use strict;
use warnings;

use Config;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       packlist_for
               );

our $VERSION = '0.01'; # VERSION

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

1;
# ABSTRACT: Dist-related utilities

__END__

=pod

=encoding UTF-8

=head1 NAME

SHARYANTO::Dist::Util - Dist-related utilities

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use SHARYANTO::Dist::Util qw(
     packlist_for
 );

=head1 DESCRIPTION

=head1 FUNCTIONS

=head2 packlist_for($mod) => STR

Find C<.packlist> file for module C<$mod> (which can be in the form of
C<Package::SubPkg> or C<Package/SubPkg.pm>). Return undef if none is found.

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
