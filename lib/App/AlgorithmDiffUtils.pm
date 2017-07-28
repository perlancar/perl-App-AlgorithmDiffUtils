package App::AlgorithmDiffUtils;

# DATE
# VERSION

use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'CLI utilities based on Algorithm::Diff',
};

sub _read_files {
    my $args = shift;

    my $fh;
    open $fh, "<", $args->{file1} or die "Can't open file '$args->{file1}': $!";
    chomp(my @seq1 = <$fh>);
    open $fh, "<", $args->{file2} or die "Can't open file '$args->{file2}': $!";
    chomp(my @seq2 = <$fh>);

    return (\@seq1, \@seq2);
}

my %args_common = (
    file1 => {
        schema => 'filename*',
        req => 1,
        pos => 0,
    },
    file2 => {
        schema => 'filename*',
        req => 1,
        pos => 0,
    },
);

$SPEC{algodiff_lcs} = {
    v => 1.1,
    summary => "Perform LCS() on two files",
    args => {
        %args_common,
    },
};
sub algodiff_lcs {
    require Algorithm::Diff;
    my %args = @_;

    my ($seq1, $seq2) = _read_files(\%args);
    my $lcs = Algorithm::Diff::LCS($seq1, $seq2);
    [200, "OK", $lcs];
}

$SPEC{algodiff_diff} = {
    v => 1.1,
    summary => "Perform diff() on two files",
    args => {
        %args_common,
    },
};
sub algodiff_diff {
    require Algorithm::Diff;
    my %args = @_;

    my ($seq1, $seq2) = _read_files(\%args);
    my $diff = Algorithm::Diff::diff($seq1, $seq2);
    [200, "OK", $diff];
}

1;
# ABSTRACT:

=head1 SYNOPSIS

=head1 DESCRIPTION

This distribution includes several utilities:

#INSERT_EXECS_LIST
