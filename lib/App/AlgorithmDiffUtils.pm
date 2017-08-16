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

    open my $fh1, "<", $args->{file1} or die "Can't open file '$args->{file1}': $!";
    chomp(my @seq1 = <$fh1>);
    close $fh1;

    open my $fh2, "<", $args->{file2} or die "Can't open file '$args->{file2}': $!";
    chomp(my @seq2 = <$fh2>);
    close $fh2;

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
        pos => 1,
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

$SPEC{algodiff_sdiff} = {
    v => 1.1,
    summary => "Perform sdiff() on two files",
    args => {
        %args_common,
    },
};
sub algodiff_sdiff {
    require Algorithm::Diff;
    my %args = @_;

    my ($seq1, $seq2) = _read_files(\%args);
    my $sdiff = Algorithm::Diff::sdiff($seq1, $seq2);
    [200, "OK", $sdiff];
}

$SPEC{algodiff_compact_diff} = {
    v => 1.1,
    summary => "Perform compact_diff() on two files",
    args => {
        %args_common,
    },
};
sub algodiff_compact_diff {
    require Algorithm::Diff;
    my %args = @_;

    my ($seq1, $seq2) = _read_files(\%args);
    my $cdiff = Algorithm::Diff::compact_diff($seq1, $seq2);
    [200, "OK", $cdiff];
}

$SPEC{algodiff_hunks} = {
    v => 1.1,
    summary => "Show hunks information",
    args => {
        %args_common,
    },
};
sub algodiff_hunks {
    require Algorithm::Diff;
    my %args = @_;

    my ($seq1, $seq2) = _read_files(\%args);
    my $diff = Algorithm::Diff->new($seq1, $seq2);

    my @res;
    my $i = -1;
    while ($diff->Next) {
        $i++;
        push @res, [
            $i,
            $diff->Same ? "same" : "diff",
            $diff->Get(qw/Min1 Max1 Min2 Max2/),
        ];
    }
    [200, "OK", \@res,
     {'table.fields'=>[qw/idx type min1 max1 min2 max2/]}];
}

1;
# ABSTRACT:

=head1 SYNOPSIS

=head1 DESCRIPTION

This distribution includes several utilities:

#INSERT_EXECS_LIST
