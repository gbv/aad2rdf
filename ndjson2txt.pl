#!/usr/bin/env perl
use v5.14;
use JSON;

binmode STDOUT, ':encoding(UTF-8)';

my %concepts = map {
        my $c = decode_json($_);
        ($c->{uri} => $c) 
    } <>;
my %labels   = map { ($_->{prefLabel}{de} => $_->{uri}) } values %concepts;

# narrower => broader
for my $uri (keys %concepts) {
    for (list($concepts{$uri}->{broader})) {
        my $n = $concepts{$_->{uri}}->{narrower} //= [];
        push @$n, { uri => $uri };
    }
}

sub label { $_[0]->{prefLabel}{de} }
sub list { @{ref($_[0] // []) ? ($_[0] // []) : [$_[0]]} } # FIXME

for (grep { $_->{altLabel} } values %concepts) {
    my $uri = $_->{uri};
    $labels{$_} = $uri for list($_->{altLabel}{de});
}

for my $label (sort keys %labels) {
    my $concept = $concepts{$labels{$label}};

    say "# $label";
    my $prefLabel = label($concept);
    if ($prefLabel eq $label) {
        say "DEF: ".$_->{de} for grep {$_} ($concept->{definition});
        say "OB: $_" for sort map { label($concepts{$_->{uri}}) } list($concept->{broader});
        say "UB: $_" for sort map { label($concepts{$_->{uri}}) } list($concept->{narrower});
        say "VB: $_" for sort map { label($concepts{$_->{uri}}) } list($concept->{related});
    } else {
        say "BS: $prefLabel";
    }
    say;
}
