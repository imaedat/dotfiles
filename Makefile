RELPATH := $(shell realpath --relative-to=$(HOME) $(PWD))

targets := \
  .bashrc \
  .deltarc \
  .gdbinit \
  .irbrc \
  .screenrc \
  .tigrc \
  .tmux.conf \
  .vimrc \
  \

.PHONY: install
install:
	@cd $(HOME); \
	for f in $(targets); do \
		ln -v -s $(RELPATH)/$$f . 2>/dev/null || : ; \
	done
