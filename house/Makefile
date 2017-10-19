BLD ?= /tmp
${BLD}/contributions.inc: contributions.awk contributions.tsv
	@echo "# build $@"
	grep -v "^#" $(filter %.tsv,$^)|awk -F '\t' -f $(filter %.awk,$^) >$@
