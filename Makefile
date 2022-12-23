sync:
	cp -f ~/.bashrc ./dotfiles/bashrc
	cp -f ~/.bash_profile ./dotfiles/bash_profile
	cp -rf ~/.config/emacs ./dotfiles/
	cp -rf ~/.config/git/config ./dotfiles/gitconfig
	cp -f ~/.config/xorg/urxvt.conf ./dotfiles/urxvt.conf
	cp -f ~/.config/inputrc ./dotfiles/inputrc

copy:
	cp -f ./dotfiles/bashrc ~/.bashrc
	cp -f ./dotfiles/bash_profile ~/.bash_profile
	cp -rf ./dotfiles/emacs ~/.config/
	mkdir ~/.config/git && cp -rf ./dotfiles/gitconfig ~/.config/git/config
	mkdir ~/.config/xorg && cp -f ./dotfiles/urxvt.conf ~/.config/xorg/urxvt.conf
	xrdb -merge ~/.config/urxvt.conf
	cp -f ./dotfiles/inputrc ~/.config/inputrc
	. ~/.bashrc

clean:
	rm -f ~/.bashrc
	rm -f ~/.bash_profile
	rm -rf ~/.config/emacs
	rm -rf ~/.config/git
	rm -f ~/.config/xorg/urxvt.conf
	rm -f ~/.config/inputrc

.PHONY: sync copy clean
