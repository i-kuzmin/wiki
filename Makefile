.PHONY: all dirs html clean deepclean

all: html

WWW = .www
BLD = .build
DIRS += ${WWW} ${BLD}

CLEAN += ${BLD}
DEEPCLEAN += ${WWW} ${BLD}

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
CLEAN += ${1}
endef
#CLEAN += ${1} $(dir ${1})

# Converts t2t source file name to html destination file name
t2t_to_html = $(addprefix ${WWW}/,\
			  	$(subst /,_,\
				$(subst .t2t$,.html,\
				$(subst ./,,${1}))))

# -----------------------------------------------------------------------------------
# Install files procedure 
# -----------------------------------------------------------------------------------

# Install file to WWW directory
# @arg1 		  - MakeFile related file name
# @arg2[optional] - WWW related destination
define install =
$(if ${2},\
	$(eval $(call do_copy,${WWW}/${2},$(mkfdir)/${1})),\
	$(eval $(call do_copy,${WWW}/$(mkfdir)/${1},$(mkfdir)/${1})))
endef

define install_link =
$(if ${2},\
	$(eval $(call do_link,${WWW}/${2},$(mkfdir)/${1})),\
	$(eval $(call do_link,${WWW}/$(mkfdir)/${1},$(mkfdir)/${1})))
endef

# -----------------------------------------------------------------------------------
# Define dependency procedure 
# -----------------------------------------------------------------------------------
define do_build_depend =
$(if $(filter ${BLD}/${3}, ${DIRS}),,DIRS += ${BLD}/${3})
$(call t2t_to_html,${3}).html: ${BLD}/${3}/${1}
${BLD}/${3}/${1}: $(addprefix ${3}/, ${2})
endef

define do_depend =
$(call t2t_to_html, ${2}).html: ${2}/${1}
$(info $(call t2t_to_html, ${2}).html: ${2}/${1})
endef

# Add dependency
# add filder.html -> {BLD}/{1} -> {2} dependency, or
# or  filder.html -> {1}, if second argument is empty.
define depend =
$(if ${2},\
	$(eval $(call do_build_depend,${1},${2},$(mkfdir))),\
	$(eval $(call do_depend,${1},$(mkfdir))))
endef

# -----------------------------------------------------------------------------------
# Include Makefiles
# -----------------------------------------------------------------------------------
INCLUDES = $(shell find . -name 'Makefile.inc')
include ${INCLUDES}

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

# Find t2t sources
T2T=$(patsubst ./%, %, $(shell find . -name '*.t2t' -not -name '*.lk.t2t'))

# Populate rules
$(foreach t2t,${T2T},\
	$(eval \
		$(call t2t_html_rule,\
			$(call t2t_to_html,${t2t}),${t2t})))

# - # Populate directory dependency - rebuild folder.html if anything changed in folder
# - define add_dependency=
# - $(call t2t_to_html,${1}): $(basename ${1}) $(basename ${1})/*
# - endef
# - 
# - $(foreach folder,\
# - 	$(wildcard $(subst /Makefile.inc,.t2t,${INCLUDES})),\
# - 	$(eval $(call add_dependency, ${folder})))

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
	@echo "# deepclean: remove ${DEEPCLEAN}"
	rm -rf ${DEEPCLEAN}

clean:
	@echo "# clean: remove $(words ${CLEAN}) files"
	rm -rfd ${CLEAN}

# -----------------------------------------------------------------------------------
