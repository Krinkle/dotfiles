#
# Bash history
#

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

#
# Terminal
#

export EDITOR=vim

if [ -x /usr/bin/dircolors ]
then
	eval "`dircolors -b`"
fi

# Colors http://linux.101hacks.com/ps1-examples/prompt-color-using-tput/
CLR_NONE=`tput sgr0`
CLR_LINE=`tput smul`
CLR_BOLD=`tput bold`
CLR_BLACK=`tput setaf 0`
CLR_RED=`tput setaf 1`
CLR_GREEN=`tput setaf 2`
CLR_YELLOW=`tput setaf 3`
CLR_BLUE=`tput setaf 4`
CLR_MAGENTA=`tput setaf 5`
CLR_CYAN=`tput setaf 6`
CLR_WHITE=`tput setaf 7`

# Sort dotfiles before a in ls and sort (http://superuser.com/a/448294/164493)
export LC_COLLATE="C"

#
# Setup functions
#

_dotfiles-ps1-setup
