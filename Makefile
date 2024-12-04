SHELL := /bin/bash
.PHONY: refresh tmux-refresh reopen prepare pubkeys-rights scan

prepare:
	@sudo apt-get install stow curl ansible
refresh:
	@stow --target=$(HOME) .
	@echo "Sourcing .bashrc"
	@source $(HOME)/.bashrc || true
	@source $(HOME)/.bash_aliases || true
tmux-refresh:
	@tmux source-file .config/tmux/tmux.conf
reopen:
	@bash restoresession.sh
scan:
	@clamscan --recursive /  --quiet
pubkeys-rights:
	@chmod 700 ~/.ssh/*pub
