#.SUFFIXES: .t2t .html

T2T=$(patsubst ./%, %, $(shell find . -name '*.t2t' -not -name '*.lk.t2t'))
HTML=$(T2T:%.t2t=.www/%.html)
DIRS=$(sort $(dir $(HTML)))

.PHONY: clean
all: $(HTML)

.www:
	@mkdir -p $(DIRS)

.www/%.html: %.t2t |.www
	@echo "# $< -> $@"
	@if [ ! -d $(dir $@) ]; then mkdir -p $(dir $@); fi;
	txt2tags --config-file .tools/txt2tagsrc -t xhtml -o $@ -q $<
	
	@if [ ! -e .www/toc ] || ! grep "$@" .www/toc -q; then \
		echo "$@" >> .www/toc; \
	fi

all: .www/index.html
.www/index.html: .www/toc 
	@echo "# build index"
	.tools/build_index $< >$@

all: .www/MathJax
.www/MathJax: .tools/MathJax |.www
	@echo "# install MathJax"
	cd .www
	ln -f -s ../$< $@

clean:
	@echo "# clean"
	rm -rf .www

