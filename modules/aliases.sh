# Ubuntu (Linux), Solaris (SunOS)
# Mac (Darwin) normally needs `ls -G` instead of `ls --color`.
# However, KrinkleMac has GNU coreutils installed via Homebrew.
alias ls='ls --color=auto'

alias grep='grep --color=auto'

alias ll='ls -halF'
alias l='ll'

alias lchmod='stat -c "%a %n"'

alias g='git'
alias gi='git'
alias gir='git'

alias ..='cd ..'
alias ...='cd ../..'

alias nit='npm install && npm test'
alias jsonhint='jshint --extra-ext .json'
alias dsize='du -hs'

# http://unix.stackexchange.com/a/81699/37512
# dig @ns1.google.com -t txt o-o.myaddr.l.google.com +short
# dig @ns1-1.akamaitech.net whoami.akamai.net +short
alias wanip='dig @resolver1.opendns.com myip.opendns.com +short'

alias cvnlog='for dir in `ls -d /srv/cvn/services/cvnbot/* | sort -V`; do name=$(basename "$dir"); echo; echo "# $name"; (sudo cat /var/log/syslog | grep $name | tail -n10); done;'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
