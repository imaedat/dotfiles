RELPATH := $(shell realpath --relative-to=$(HOME) $(PWD))

TARGETS := \
  bashrc \
  deltarc \
  gdbinit \
  irbrc \
  screenrc \
  tigrc \
  tmux.conf \
  vimrc \
  \

.PHONY: install
install:
	@cd $(HOME); \
	for f in $(TARGETS); do \
		ln -v -s $(RELPATH)/$$f ./.$$f 2>/dev/null || : ; \
	done
