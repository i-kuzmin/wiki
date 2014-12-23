#.SUFFIXES: .t2t .html

T2T=$(wildcard *.t2t)
HTML=$(T2T:%.t2t=.www/%.html)

.PHONY: clean

all: $(HTML)

.www/%.html: %.t2t
	txt2tags --config-file .tools/txt2tagsrc -t xhtml -o $@ $<

clean:
	rm .www/*.html

