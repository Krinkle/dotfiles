if [ "$UNAME" == "Linux" -o "$UNAME" == "SunOS" ]
then
	# Ubuntu (Linux), Solaris (SunOS)
	alias ls='ls --color=auto'
else
	# Mac (Darwin)
    alias ls='ls -G'
fi

alias ll='ls -ahlF'
alias l='ll'
alias gir='git'
alias got='git'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias jsonhint='jshint --extra-ext .json'
alias dsize='du -hs'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
