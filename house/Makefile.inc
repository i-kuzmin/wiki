$(call install,img/plan.jpg)
$(call install,docs/proxy.rtf)
$(call build,contributions.inc,contributions.awk contributions.tsv)

#$(call depend,contributions.inc,contributions.awk contributions.tsv)
#${BLD}/house/contributions.inc:
#	@echo "# build $@"
#	awk -F '\t'  -f $^ >$@
