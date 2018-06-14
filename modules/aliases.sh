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

alias nit='npm install-test'
alias dsize='du -hs'

# http://unix.stackexchange.com/a/81699/37512
# dig @resolver1.opendns.com ANY myip.opendns.com +short # Both IPv6 and IPv4
# dig @ns1.google.com TXT o-o.myaddr.l.google.com +short # Only IPv4
# dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short # Only IPv4
alias wanip='dig @resolver1.opendns.com ANY myip.opendns.com +short'
alias wanip4='dig @resolver1.opendns.com ANY myip.opendns.com +short -4'

alias cvnlog='for dir in `ls -d /srv/cvn/services/cvnbot/* | sort -V`; do name=$(basename "$dir"); echo; echo "# $name"; (sudo cat /var/log/syslog | grep $name | tail -n10); done;'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
