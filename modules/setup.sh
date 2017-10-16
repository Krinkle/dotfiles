#
# Shell options
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
#

shopt -s autocd >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s globstar >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1

# Install: Bash autocompletion
test -f /etc/bash_completion && . /etc/bash_completion

#
# Variables
#

: ${HOME=~}
: ${UNAME=$(uname)}

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000

# Bins: Home
export PATH="${HOME}/bin:${PATH}"

# Fix "sort: string comparison failed: Illegal byte sequence"
export LC_ALL="C"
export LANG="en_US"
# Sort dotfiles before "a" in ls(1) and sort(1) (http://superuser.com/a/448294/164493)
export LC_COLLATE="C"

export EDITOR=vim

# http://serverfault.com/a/414763/180257
# See also gitconfig/core.pager
export LESSCHARSET=utf-8

#
# Colors
#

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

#
# Setup functions
#

PROMPT_COMMAND="_dotfiles-ps1-setup${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

#
# Install: Last command run-time (see functions.sh)
#
trap '_dotfiles-timer-start' DEBUG

# NOTE: This must be the very last thing in PROMPT_COMMAND
# As such, this setup.sh file is the last file the loads
# in index.bash.
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;} _dotfiles-timer-stop"
