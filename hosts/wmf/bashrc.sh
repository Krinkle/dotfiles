# This file is a concatenation of selected smaller modules
# maintained by Krinkle at https://github.com/Krinkle/dotfiles

## index

[ -z "$PS1" ] && return

export KDF_CANONICAL_HOST="$( hostname -f 2>/dev/null )"

## setup

shopt -s globstar >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

: ${HOME=~}
: ${UNAME=$(uname)}

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=1000
export HISTFILESIZE=2000

export PATH=$PATH:$HOME/bin

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

export EDITOR=vim
export GREP_OPTIONS='--color=auto'

PROMPT_COMMAND="_dotfiles-ps1-setup && _dotfiles_wmf_setscreentitle"

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
		if [ "$HOSTNAME" == "fenari" ]
		then
			echo -ne "\033k$(basename $PWD)$\033\\"
		else
			echo -ne "\033k$HOSTNAME$\033\\"
		fi
	fi
}

ssh() {
        inargs="$@"
        if [ "$TERM" == "screen" ]
        then
                host="${inargs#*@}"
                host="${host% *}"
                echo -ne "\033k$host\033\\"
        fi
        /usr/bin/ssh $inargs
        _dotfiles_wmf_setscreentitle
}

## aliases

alias ls='ls --color=auto'
alias ll='ls -ahlF'
alias l='ll'
alias gir='git'
alias got='git'
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'
#alias jsonhint='jshint --extra-ext .json'
alias dsize='du -hs'
#alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi
