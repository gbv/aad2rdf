#!/usr/bin/env perl
use v5.14;
use LWP::Simple;
use Catmandu -all;
use Catmandu::Fix::marc_map as => 'marc_map';
use Catmandu::Exporter::MARC;

sub log { say STDERR @_ }

my $exporter = exporter('MARC', type => 'XML', pretty => 1);

# get all AAD records via SRU
my $importer = importer('SRU', 
    base => 'http://sru.gbv.de/gsocat',
    query => 'pica.tbs=xgt',
    recordSchema => 'marcxml',
    parser => 'marcxml',
);

log $importer->url;

# import MARC records and extract mapping from labels to IDs
my %ids;
my $records = $importer->map(sub{
    my $marc = shift;

	marc_map($marc, '150a','label');
	$ids{$marc->{label}} = $marc->{_id};

    return $marc;
})->to_array(); 

sub fix_marc_field {
    my $m = shift;

    return if $m->[0] eq '667' and $m->[4] eq 'VD-17';
    return if $m->[0] eq '670';

    if ($m->[0] eq '680') { # Benutzungshinweis
        $m->[0] = '667'; # => skos:editorialNote
    } elsif ($m->[0] eq '679') { # Definition
        $m->[0] = '677'; # => skos:definition
    } elsif ($m->[0] eq '550') {

		# non-standard subfield $9 
		my $rel = $m->[6]; # $i = 4:[ouv]bal
		if ($rel eq '4:obal') {
			$m->[8] = 'g';	# broader
		} elsif ($rel eq '4:ubal') {
			return; # don't explicitly add narrower
		}

		my $label = $m->[4];
		my $id = $ids{$label} // log "Broken link to $label from ".$_[0]->{label};
		push @$m, '0', $id;
	}

    return $m;
}

# fix and export MARC records
foreach my $marc (@$records) {
    $marc->{record} = [ map { fix_marc_field($_,$marc) } @{$marc->{record}} ];
    $exporter->add($marc);
}

$exporter->commit;
log $exporter->count . " records.";
