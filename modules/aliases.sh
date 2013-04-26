if [ "$(uname)" == "Linux" -o "$(uname)" == "SunOS" ]
then
	# Ubuntu (Linux), Solaris (SunOS)
	alias ls='ls --color=auto'
else
	# Mac (Darwin)
    alias ls='ls -G'
fi

alias ll='ls -ahlF'
alias l='ll'
alias gi='git'
alias ..='cd ..'
alias jsonhint='jshint --extra-ext .json'
alias dsize='du -hs'
