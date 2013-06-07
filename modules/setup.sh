#
# Bash history
#

# Append to the history file, don't overwrite it
shopt -s histappend

# Don't put duplicate lines in the history
export HISTCONTROL="ignorespace:erasedups"

# Large history
export HISTSIZE=10000
export HISTFILESIZE=20000

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
# Misc
#

export EDITOR=vim

# Sort dotfiles before a in ls and sort (http://superuser.com/a/448294/164493)
export LC_COLLATE="C"

export GREP_OPTIONS='--color=auto'

# Fix gem/ruby errors about "unable to convert U+3002 from UTF-8 to US-ASCII for lib/shortener.rb, skipping"
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"
unset LC_ALL

# Enable Bash 4 features if available
shopt -s globstar 2> /dev/null


#
# Setup functions
#

_dotfiles-ps1-setup
