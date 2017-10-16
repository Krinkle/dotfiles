# This file is a concatenation of selected smaller modules
# maintained by Krinkle at https://github.com/Krinkle/dotfiles

## index

[ -z "$PS1" ] && return

export KDF_CANONICAL_HOST="$( hostname -f 2>/dev/null )"

## setup

shopt -s autocd >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s globstar >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1

test -f /etc/bash_completion && . /etc/bash_completion

: ${HOME=~}
: ${UNAME=$(uname)}

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000
export PATH="${HOME}/bin:${PATH}"
export LC_ALL="en_US.UTF-8"
export LANG="en_US"
export LC_COLLATE="C"
export EDITOR=vim

if [ -x /usr/bin/dircolors ]
then
	eval "`dircolors -b`"
fi
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

PROMPT_COMMAND="_dotfiles-ps1-setup; _dotfiles_wmf_setscreentitle; $PROMPT_COMMAND"

## functions

function _dotfiles-ps1-exit_code() {
	[[ $1 != 0 ]] && echo "\[$CLR_RED\]$1\[$CLR_NONE\] "
}

function _dotfiles-git-ps1() {
	local st_staged=0
	local st_unstaged=0
	local st_untracked=0
	local indicator
	local branch

	CLR_GITST_CLS="$CLR_GREEN" # Clear state
	CLR_GITST_SC="$CLR_YELLOW" # Staged changes
	CLR_GITST_USC="$CLR_RED" # Unstaged changes
	CLR_GITST_UT="$CLR_WHITE" # Untracked files
	CLR_GITST_BR="$CLR_GREEN"

	if [[ -z "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]]; then
		return 1
	fi

	if [[ -n "$(git diff-index --cached HEAD 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_SC}+" # Staged changes
	fi
	if [[ -n "$(git ls-files --modified 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_USC}*" # Unstaged changes
	fi
	if [[ -n "$(git ls-files --others --exclude-standard 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_UT}%" # Untracked files
	fi

	branch="`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
	echo -en "${CLR_GITST_BR} ($branch$indicator${CLR_GITST_BR})"
}

function _dotfiles-ps1-setup() {
	local ec="$?"
	local host="$KDF_CANONICAL_HOST"
	local clr_user="$CLR_CYAN"
	local clr_host="$CLR_CYAN"
	local prompt="\$"
	local supportcolor

	# elif echo $KDF_CANONICAL_HOST | grep -q -E '\.wikimedia\.org|\.wmnet'; then
	clr_host="$CLR_GREEN"

	if [ "$LOGNAME" = "root" ]; then
		clr_user="$CLR_RED"
		prompt="#"
	fi

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=1
	fi

	if [[ -n $supportcolor ]]; then
		PS1="\[$CLR_WHITE\][\$(date +%H:%M\ %Z)] \[$clr_user\]\u\[$CLR_WHITE\] at \[$clr_host\]$host\[$CLR_WHITE\] in \[$CLR_YELLOW\]\w\$(_dotfiles-git-ps1)\[$CLR_NONE\]\n$(_dotfiles-ps1-exit_code $ec)$prompt "
	else
		PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w$prompt "
	fi
}

## functions-wmf

function _dotfiles_wmf_setscreentitle() {
	if [ "$TERM" == "screen" ]
	then
		echo -ne "\033k$(basename $PWD)$\033\\"
	fi
}

## aliases

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -halF'
alias l='ll'
alias gir='git'
alias ..='cd ..'
alias ...='cd ../..'
alias dsize='du -hs'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
