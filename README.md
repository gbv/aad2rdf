# Gattungsbegriffe der Arbeitsgemeinschaft Alte Drucke beim GBV in RDF

Die Gattungsbegriffe der Arbeitsgemeinschaft Alte Drucke beim GBV (AAD) dient
zur einheitlichen Verschlagwortung Alter Drucke im GBv bis zum Erscheinungsjahr
1850. Die Normdatei ist aus der sogenannten "Göttinger"-Liste und der
VD17-Liste hervorgegangen. Die einzelnen der rund 275 Gattungsbegriffe können
durch Thesaurus-Relationen miteinander verknüpft werden.

Die Gattungsbegriffe werden von der [Arbeitsgemeinschaft Alte Drucke] gemeinsam
gepflegt und in Form von Normdatensätzen im Verbundkatalog des GBV (GVK)
verwaltet.  Die Daten sind unter [CC0] frei verfügbar. Um die ursprünglich im
PICA-Format vorliegenden Datensätzen nach RDF zu konvertieren besteht folgender
Workflow:

* Die Datensätze lassen sich im Format [MARC 21 Authority] (MARCXML)
  aus dem GVK per SRU abrufen (`pica.tbs=xgt`).

      $ make aad.xml
    
  Die Datensätze werden dabei um einige Felder ergänzt um die Konvertierung zu
  erleichtern.

* Die gesamten MARCXML-Datensätze werden anschließend mit [mc2skos] nach RDF
  konvertiert wobei die Formate RDF/Turtle und JSKOS angeboten werden.

      $ make rdf

## Weitere Informationen zu den Gattungsbegriffen

* [Arbeitsgemeinschaft Alte Drucke](https://aad.gbv.de/)
* [Empfehlungen der AAD zur Gattungsbegriffen](http://aad.gbv.de/empfehlung/gattung.htm)
* [Eintrag in BARTOC](http://bartoc.org/en/node/18627)

[MARC 21 Authority]: http://www.loc.gov/marc/authority/
[CC0]: https://creativecommons.org/publicdomain/zero/1.0/deed.de
[mc2skos]: https://pypi.python.org/pypi/mc2skos
