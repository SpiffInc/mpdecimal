TARFILES := $(wildcard *.tar.gz)

CLEAN_TARGETS := $(addprefix .clean_,$(TARFILES))
EXTRACT_TARGETS := $(addprefix .extract_,$(TARFILES))

default: lib

clean: $(CLEAN_TARGETS)

extract: $(EXTRACT_TARGETS)

lib: $(EXTRACT_TARGETS)
	cd mpdecimal-2.5.1 && ./configure
	$(MAKE) -C mpdecimal-2.5.1

$(CLEAN_TARGETS): .clean_%: %
	rm -rf $(shell tar tf $* | head -1)
	rm -f $(addprefix .extract_,$<)

$(EXTRACT_TARGETS): .extract_%: %
	tar xvzf $<
	touch $@

.PHONY: default clean extract lib $(CLEAN_TARGETS)
