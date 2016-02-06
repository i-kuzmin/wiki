.PHONY: all dirs html clean deepclean

all: html

WWW=.www
DIRS += ${WWW}
deepclean: ${WWW}

# -----------------------------------------------------------------------------------
# Auxiliary help functions
# -----------------------------------------------------------------------------------

# returns current makefile directory
mkfdir = $(patsubst %/,%,\
			$(dir \
				$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

define do_copy =
html: ${1} 
${1}: ${2} 
	@echo "# install $$< -> $$@"
	mkdir -p $(dir ${1})
	cp $$< $$@
CLEAN += ${1} $(dir ${1})
endef

define do_link=
html: ${1} 
${1}: ${2} 
	@echo "# link $$< -> $$@"
	mkdir -p $(dir ${1})
	cd $(dir ${1})
	ln -f -s ../$$< $$@
CLEAN += ${1} $(dir ${1})
endef

# -----------------------------------------------------------------------------------
# Install files procedure 
# -----------------------------------------------------------------------------------

# Install file to WWW directory
# @arg1 		  - MakeFile related file name
# @arg2[optional] - WWW related destination
define install =
$(if ${2},\
	$(eval $(call do_copy,${WWW}/${2},$(call mkfdir,${1})/${1})),\
	$(eval $(call do_copy,${WWW}/${1},$(call mkfdir,${1})/${1})))
endef

define install_link =
$(if ${2},\
	$(eval $(call do_link,${WWW}/${2},$(call mkfdir,${1})/${1})),\
	$(eval $(call do_link,${WWW}/${1},$(call mkfdir,${1})/${1})))
endef

# -----------------------------------------------------------------------------------
# Include Makefiles 
# -----------------------------------------------------------------------------------
incfiles = $(shell find . -name 'Makefile.inc')
include ${incfiles}

# -----------------------------------------------------------------------------------
# Build HTML from Text2Tags
# -----------------------------------------------------------------------------------
define t2t_html_rule = 
html: ${1}
${1}: ${2} |dirs
	@echo "# $$< -> $$@"
	txt2tags --config-file .tools/txt2tagsrc -t xhtml -o $$@ -q $$<
CLEAN += ${1}
endef

# Converts t2t source file name to html destination file name
t2t_to_html = $(addprefix ${WWW}/,\
			  	$(subst /,_,\
				$(subst .t2t$,.html,${1})))

# Find t2t sources
T2T=$(patsubst ./%, %, $(shell find . -name '*.t2t' -not -name '*.lk.t2t'))

# Populate rules
$(foreach t2t,${T2T},\
	$(eval \
		$(call t2t_html_rule,\
			$(call t2t_to_html,${t2t}),${t2t})))

# -----------------------------------------------------------------------------------
# Make Directory rules
# -----------------------------------------------------------------------------------
${DIRS}:
	@echo "# make $@"
	mkdir -p $@

dirs: ${DIRS}

# -----------------------------------------------------------------------------------
# Clean rules
# -----------------------------------------------------------------------------------
deepclean:
	@echo "# deepclean: remove $^"
	rm -rf $^

clean:
	@echo "# clean: remove $(words ${CLEAN}) files"
	rm -rfd ${CLEAN}

# -----------------------------------------------------------------------------------
