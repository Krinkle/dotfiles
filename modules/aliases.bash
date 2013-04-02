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

alias ..='cd ..'

alias jsonhint='jshint --extra-ext .json'

# Size calculation
alias dsize='du -hs'
