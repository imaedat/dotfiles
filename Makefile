RELPATH := $(shell realpath --relative-to=$(HOME) $(PWD))

targets := \
  .bashrc \
  .deltarc \
  .gdbinit \
  .irbrc \
  .screenrc \
  .tmux.conf \
  .vimrc \
  \

.PHONY: install
install:
	@cd $(HOME); \
	for f in $(targets); do \
		ln -s $(RELPATH)/$$f . || : ; \
	done
