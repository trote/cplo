#!/usr/bin/perl -w
# cplo.pl --- Copy to the same location
# Version: 0.01

use warnings;
use strict;

use File::Basename;
use File::Spec::Functions;
use File::Copy ();

our $VERSION = '0.01';

sub check_args(@);
sub cp($@);

my @files = check_args(@ARGV);
if ($#files < 1) {
    printUsage();
    exit 1;
}

cp $files[0], @files[1 .. $#files];

sub check_args(@) {
    my $source = shift;

    if ( ! -e $source ) {
        print STDERR <<EOE;
cplo: '$source' not found
    exiting...
EOE
        exit 1;
    } elsif ( (-d $source) || (! -r $source) ) {
        print STDERR <<EOE;
cplo: can not read '$source'
    exiting...
EOE
        exit 1;
    }
    
    my $target_dir = dirname($source);
    my @paths;
    push @paths, $source;
    foreach ( @_ ) {
        my $path = catfile($target_dir, $_);
        if ( (-e $path) || ($path eq $source) ) {
            print STDERR "cplo: did not copy '$source'. '$path' already exists\n";
            next;
        }
        push @paths, $path;
    }
    @paths;
}

sub cp($@) {
    my ( $source, @destination ) = @_;

    File::Copy::copy $source, $_ for @destination;
}

sub printUsage {
    print STDERR <<EOE;
Usage: cplo file1 file2...
EOE
}

__END__

=head1 NAME

cplo.pl - Copy to the same location

=head1 SYNOPSIS

cplo.pl [options] args

      -opt --long      Option description

=head1 DESCRIPTION

Stub documentation for cplo.pl, 

=cut
