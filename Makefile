rdf: aadgenres.ttl aadgenres.json aadgenres.ndjson

aadgenres.xml:
	perl download.pl > $@

URI=http://uri.gbv.de/terminology/aadgenres/
MC2SKOS_OPTIONS=--uri '$(URI){control_number}' --scheme $(URI) --indexterms --notes

aadgenres.ttl: aadgenres.xml
	mc2skos -o turtle $(MC2SKOS_OPTIONS) $< $@

aadgenres.json: aadgenres.xml
	mc2skos -o jskos $(MC2SKOS_OPTIONS) $< $@

aadgenres.ndjson: aadgenres.xml
	mc2skos -o ndjson $(MC2SKOS_OPTIONS) $< $@

install:
	cpanm --installdeps .
	pip install 'mc2skos>=0.6.0'
