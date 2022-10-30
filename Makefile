sync:
	cp -f ~/.bashrc ./dotfiles/bashrc
	cp -f ~/.bash_profile ./dotfiles/bash_profile
	cp -rf ~/.config/emacs ./dotfiles/
	cp -rf ~/.config/git/config ./dotfiles/gitconfig

copy:
	cp -f ./dotfiles/bashrc ~/.bashrc
	cp -f ./dotfiles/bash_profile ~/.bash_profile
	cp -rf ./dotfiles/emacs ~/.config/
	mkdir ~/.config/git && cp -rf ./dotfiles/gitconfig ~/.config/git/config

clean:
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	rm -rf ~/.config/emacs
	rm -rf ~/.config/git

.PHONY: sync copy clean
