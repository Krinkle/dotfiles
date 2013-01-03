#
# Bash History
#

# Don't put duplicate lines in the history. See bash(1) for more options
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

#
# Editor
#
export EDITOR=vim

#
# Terminal
#

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

# Call setup functions

_dotfiles-ps1-setup
