if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
	# Linux
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
else
	# Mac
    alias ls='ls -G'
fi

# Shortcuts
alias ll='ls -ahlF'
alias l='ll'
alias gi='git'

# Size calculation
alias dsize='du -hs'

# Actions
GITLOGASI="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(cyan)<%an>%Creset' --abbrev-commit --date=relative"
alias dotfiles-pull="cd ~/.krinkle.dotfiles && git fetch origin && git reset --hard origin/master && $GITLOGASI -n5 && cd -"
