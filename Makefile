#.SUFFIXES: .t2t .html

T2T=$(patsubst ./%, %, $(shell find . -name '*.t2t'))

HTML=$(T2T:%.t2t=.www/%.html)

DIRS=$(sort $(dir $(HTML)))

.PHONY: clean

all: $(HTML)

.www:
	mkdir -p $(DIRS)

.www/%.html: %.t2t |.www
	echo "# $< -> $@"
	txt2tags --config-file .tools/txt2tagsrc -t xhtml -o $@ -q $<

clean:
	echo "# clean"
	rm -rf .www

