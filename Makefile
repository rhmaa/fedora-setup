sync:
	cp -f ~/.bashrc ./dotfiles/bashrc
	cp -f ~/.bash_profile ./dotfiles/bash_profile
	cp -rf ~/.config/emacs ./dotfiles/
	cp -rf ~/.config/git/config ./dotfiles/gitconfig
	cp -f ~/.config/Xresources ./dotfiles/Xresources

copy:
	cp -f ./dotfiles/bashrc ~/.bashrc
	cp -f ./dotfiles/bash_profile ~/.bash_profile
	cp -rf ./dotfiles/emacs ~/.config/
	mkdir ~/.config/git && cp -rf ./dotfiles/gitconfig ~/.config/git/config
	cp -f ./dotfiles/Xresources ~/.config/Xresources
	xrdb -merge ~/.config/Xresources

clean:
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	rm -rf ~/.config/emacs
	rm -rf ~/.config/git
	rm -f ~/.config/Xresources

.PHONY: sync copy clean
