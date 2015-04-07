# Ubuntu (Linux), Solaris (SunOS)
# On Mac (Darwin), this should be `ls -G`. However coreutils is installed
# from Homebrew, so 'which ls' != '/bin/ls' on Mac.
alias ls='ls --color=auto'

alias ll='ls -ahlF'
alias l='ll'

alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

alias nit='npm install && npm test'
alias jsonhint='jshint --extra-ext .json'
alias dsize='du -hs'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
