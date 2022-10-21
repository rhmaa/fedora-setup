alias em='zile'
alias ls='ls -v --group-directories-first --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias pine="alpine -p $HOME/.config/pine/pinerc -passfile $HOME/.config/pine/pinepwd"
alias top='top -e m -E m'

# Change between dark mode and light mode quickly.
alias lt="gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3' && gsettings set org.gnome.desktop.interface color-scheme 'default'"
alias dt="gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"
