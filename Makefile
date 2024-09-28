SHELL := /bin/bash
.PHONY: refresh tmux-refresh reopen prepare

prepare:
	@sudo apt-get install stow curl ansible
refresh:
	@stow --target=$(HOME) .
	@echo "Sourcing .bashrc"
	@source $(HOME)/.bashrc || true
tmux-refresh:
	@tmux source-file .config/tmux/tmux.conf
reopen:
	@bash restoresession.sh
