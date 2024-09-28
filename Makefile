SHELL := /bin/bash
.PHONY: refresh tmux-refresh

refresh:
	@stow --target=$(HOME) .
	@echo "Sourcing .bashrc"
	@source $(HOME)/.bashrc || true
tmux-refresh:
	@tmux source-file .config/tmux/tmux.conf
