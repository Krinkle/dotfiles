#
# Bash History
#

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


#
# Editor
#
export EDITOR=vim

#
# Terminal
#

# Fix svn merge errors about "svnserver: warning: cannot set locale"
# Source: http://armenianeagle.com/2008/03/18/svn-warning-cannot-set-lc_ctype-locale-solution/
export LC_ALL=C

# Terminal color codes
# Source: http://www.pixelbeat.org/docs/terminal_colours/
# Source: http://www.developerzen.com/2011/01/10/show-the-current-git-branch-in-your-command-prompt/
# These are wrapped in non-printing characters for the prompt, however when used in echo directly
# we need to use \001 and \002 instead of \[ and \].
CLR_BLACK="\001\033[0;30m\002"
CLR_D_GREY="\001\033[1;30m\002"
CLR_RED="\001\033[0;31m\002"
CLR_L_RED="\001\033[1;31m\002"
CLR_GREEN="\001\033[0;32m\002"
CLR_L_GREEN="\001\033[1;32m\002"
CLR_YELLOW="\001\033[0;33m\002"
CLR_L_YELLOW="\001\033[1;33m\002"
CLR_BLUE="\001\033[0;34m\002"
CLR_L_BLUE="\001\033[1;34m\002"
CLR_PURPLE="\001\033[0;35m\002"
CLR_L_PURPLE="\001\033[1;35m\002"
CLR_CYAN="\001\033[0;36m\002"
CLR_L_CYAN="\001\033[1;36m\002"
CLR_L_GREY="\001\033[0;37m\002"
CLR_WHITE="\001\033[1;37m\002"
CLR_NONE="\001\033[0m\002"

P_CLR_BLACK="\[\033[0;30m\]"
P_CLR_D_GREY="\[\033[1;30m\]"
P_CLR_RED="\[\033[0;31m\]"
P_CLR_L_RED="\[\033[1;31m\]"
P_CLR_GREEN="\[\033[0;32m\]"
P_CLR_L_GREEN="\[\033[1;32m\]"
P_CLR_YELLOW="\[\033[0;33m\]"
P_CLR_L_YELLOW="\[\033[1;33m\]"
P_CLR_BLUE="\[\033[0;34m\]"
P_CLR_L_BLUE="\[\033[1;34m\]"
P_CLR_PURPLE="\[\033[0;35m\]"
P_CLR_L_PURPLE="\[\033[1;35m\]"
P_CLR_CYAN="\[\033[0;36m\]"
P_CLR_L_CYAN="\[\033[1;36m\]"
P_CLR_L_GREY="\[\033[0;37m\]"
P_CLR_WHITE="\[\033[1;37m\]"
P_CLR_NONE="\[\033[0m\]"

# PS1
#MacOSX Default: PS1='\h:\W \u\$'

# On MacOSX $HOSTNAME is "FoobarMac.local" instead of "FoobarMac"
# So use the PS1 magic "\h" instead, which is correct.
P_HOST="\h"

CLR_HOME="$CLR_L_GREEN"
CLR_GITBR="$CLR_CYAN"

CLR_GITST_CLS="$CLR_GREEN" # Clear state
CLR_GITST_SC="$CLR_YELLOW" # Staged changes
CLR_GITST_USC="$CLR_RED" # Unstaged changes
CLR_GITST_UT="$CLR_L_GREY" # Untracked files

case $P_CANONICAL_HOST in
	KrinkleMac)
		CLR_GITBR="$CLR_GREEN"
		CLR_HOME="$CLR_L_CYAN"
		;;
	*)
		if [ "$INSTANCENAME" != "" ]; then
			P_HOST="$INSTANCENAME"
		fi
esac

if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	P_SUPPORT_COLOR=yes
else
	P_SUPPORT_COLOR=
fi


if [ "$P_SUPPORT_COLOR" = yes ]; then
    PS1="$CLR_L_GREY[\$(date +%H:%M\ %Z)] $CLR_HOME\u@$P_HOST$CLR_NONE:$CLR_YELLOW\w\$(get-git-info)$CLR_NONE\$ "
else
    PS1="[\$(date +%H:%M\ %Z)] \u@\h:\w\$ "
fi
