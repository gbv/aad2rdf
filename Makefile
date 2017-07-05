rdf: aad.ttl aad.json aad.ndjson

aad.xml:
	perl download.pl > $@

URI=http://uri.gbv.de/terminology/aad/
MC2SKOS_OPTIONS=--uri '$(URI){control_number}' --scheme $(URI) --indexterms --notes

aad.ttl: aad.xml
	mc2skos -o turtle $(MC2SKOS_OPTIONS) $< $@

aad.json: aad.xml
	mc2skos -o jskos $(MC2SKOS_OPTIONS) $< $@

aad.ndjson: aad.xml
	mc2skos -o ndjson $(MC2SKOS_OPTIONS) $< $@

install:
	cpanm --installdeps .
	pip install 'mc2skos>=0.6.0'
