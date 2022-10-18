sync:
	cp -f ~/.bashrc ./dotfiles/bashrc
	cp -f ~/.bash_profile ./dotfiles/bash_profile
	cp -rf ~/.bashrc.d ./dotfiles/bashrc.d
	cp -rf ~/.config/emacs ./dotfiles/
	cp -rf ~/.config/git/config ./dotfiles/gitconfig

copy:
	cp -f ./dotfiles/bashrc ~/.bashrc
	cp -f ./dotfiles/bash_profile ~/.bash_profile
	cp -rf ./dotfiles/bashrc.d ~/.bashrc.d
	cp -rf ./dotfiles/emacs ~/.config/
	mkdir ~/.config/git && cp -rf ./dotfiles/gitconfig ~/.config/git/config

clean:
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	rm -rf ~/.bashrc.d
	rm -rf ~/.config/emacs
	rm -rf ~/.config/git

.PHONY: sync copy clean
