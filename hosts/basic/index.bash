# Copyright 2020 Timo Tijhof <https://github.com/Krinkle/dotfiles>
# This is free and unencumbered software released into the public domain.

# Overview:
#
# 1. Functions
# 2. Aliases
# 3. Setup

# -------------------------------------------------
# § 1. Functions
# -------------------------------------------------

# Dependency-free version
function genpass {
	# Courtesy of @tstarling
	tr -cd [:alnum:] < /dev/urandom | head -c10
	echo
}

function _dotfiles-prompt-choice {
	read -p "$1 (y/n): > " choice
	case "$choice" in
		y|Y)
			return 0
			;;
	esac
	return 1
}

function _dotfiles-ps1-time {
	local text=""
	if [[ "$KDF_timer_show" != "0" ]]; then
		text="${KDF_timer_show}s "
	fi
	echo "$text"
}

function _dotfiles-ensure-link {
	if [ -z $2 ]; then
		echo "usage: ${FUNCNAME[0]} <link-path> <link-dest>"
		return 1
	fi
	local path=$1
	local dest=$2
	local name="$(basename $dest)"
	local backup_dest="$HOME/.dotfiles.backup"
	local suffix
	# Do nothing if the path is already a link to the same destination.
	if [[ ! -L "$path" || "$(readlink $path)" != "$dest" ]]; then
		if [ -L "$path" ]; then
			# Remove existing link with different destination.
			rm "$path"
		fi
		if [ -e "$path" ]; then
			# Create backup of existing non-link (file or directory).
			echo "... moving existing $name to ~/.dotfiles.backup"
			suffix=".$(date +%Y-%m-%dT%H%I%S).$RANDOM.bak"
			mkdir -p "$backup_dest"
			mv "$path" "$backup_dest/${name}${suffix}"
		fi
		echo "... linking $name"
		ln -s "$dest" "$path"
	fi
}

function _dotfiles-ensure-copy {
	if [ -z $2 ]; then
		echo "usage: ${FUNCNAME[0]} <src> <dest>"
		return 1
	fi
	local src=$1
	local dest=$2
	local name="$(basename $src)"
	local backup_dest="$HOME/.dotfiles.backup"
	local suffix
	if [[ -e $dest ]]; then
		if [[ -L $dest ]]; then
			# Remove link (without backup)
			rm "$dest"
		else
			# Create backup of non-link (file or directory).
			echo "... moving existing $name to ~/.dotfiles.backup"
			suffix=".$(date +%Y-%m-%dT%H%I%S).$RANDOM.bak"
			mkdir -p "$backup_dest"
			mv "$dest" "$backup_dest/${name}${suffix}"
		fi
	fi
	echo "... copying $name template"
	cp "$src" "$dest"
}

function _dotfiles-ps1-setup {
	local ec="$?"
	local host="$KDF_PS1_HOST_NAME"
	local clr_user="$CLR_CYAN"
	local clr_host="$KDF_PS1_HOST_COLOR"
	local prompt="\$"
	local supportcolor

	if [ "$LOGNAME" = "root" ]; then
		clr_user="$CLR_RED"
		prompt="#"
	fi

	if [[ $ec != 0 ]]; then
		prompt="\[$CLR_RED\]$ec\[$CLR_NONE\] $prompt"
	fi

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=1
	fi

	if [[ -n $supportcolor ]]; then
		PS1="\[$CLR_WHITE\][\$(date +%H:%M\ %Z)] \[$clr_user\]\u\[$CLR_WHITE\] at \[$clr_host\]$host\[$CLR_WHITE\] in \[$CLR_YELLOW\]\w\$(_dotfiles-git-ps1)\[$CLR_NONE\]\n\$(_dotfiles-ps1-time)$prompt "
	else
		PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w$prompt "
	fi
}

# Last command run-time measuring
#
# http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
#
# Installation:
# > trap '_dotfiles-timer-start' DEBUG
# > PROMPT_COMMAND="$PROMPT_COMMAND; _dotfiles-timer-stop"
# > PS1='[${KDF_timer_show}s] [\w]$ "

function _dotfiles-timer-start {
	export KDF_timer=${KDF_timer:-$SECONDS}
}

function _dotfiles-timer-stop {
	export KDF_timer_show=$(($SECONDS - $KDF_timer))
	unset KDF_timer
}

# Git status
#
# Based on the "official" git-completion.bash
# But more simplified and with colors.
#
function _dotfiles-git-ps1 {
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
		# ls-files has no way to list files that are staged, we have to use the
		# significantly slower (for large repos)  diff-index command instead
		indicator="$indicator${CLR_GITST_SC}+" # Staged changes
	fi
	if [[ -n "$(git ls-files --modified 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_USC}*" # Unstaged changes
	fi
	if [[ -n "$(git ls-files --others --exclude-standard 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_UT}%" # Untracked files
	fi

	branch="`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
	echo -n "${CLR_GITST_BR} ($branch$indicator${CLR_GITST_BR})"
}

# Source: http://coopology.com/2013/10/using-ps-to-output-human-readable-memory-usage-for-each-process-using-awk/
#
# Example usage:
# $ ps u | awk_ps_format
#
function awk_ps_format {
	awk '{
for ( x=1 ; x<=4 ; x++ ) { printf("%s\t",$x) }
for ( x=5 ; x<=6 ; x++ ) {  if (NR>1) { printf("%13.2fMb\t",hr=$x/1024) }
else { printf("\t%s\t",$x)  }
}
for ( x=7 ; x<=10 ; x++ ) { printf("%s\t",$x) }
for ( x=11 ; x<=NF ; x++ ) { printf("%s ",$x) }
print ""
}'
}

# Example usage:
# $ ps_filter mycommand
#
function ps_filter {
	local pattern="$1"
	local res=`ps aux`
	echo "$res" | awk_ps_format | head -1
	echo "$res" | awk_ps_format | grep "$pattern" | grep -vE 'nohup|grep'
}

# Abstraction for essentially the following:
# $ sudo tail -n100 -f /var/log/syslog | grep --line-buffered CVNBot.exe | sed 's/#012/\n\t/g'
#
# Explanation:
#
# - Read last N lines from syslog.
# - Follow in real-time.
# - Filter for a specific pattern.
# - Ensure grep flushes each line so that sed can filter.
# - Use sed to expand the single-line compressed traces from log4net.
#
# Usage:
# $ syslog_filter [-n N=100] <pattern>
#
function syslog_filter {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} [-n NUM] <pattern>"
		return 1
	fi

	local lines=100
	if [[ "$1" == "-n" ]]; then
		lines="$2"
		shift
		shift
	fi

	sudo tail -n"$lines" -f /var/log/syslog | grep --line-buffered "$1" | sed 's/#012/\n\t/g'
}

function dotfiles-pull {
	cd $KDF_BASE_DIR

	git fetch origin

	# Sanity check before potentially executing arbitrary bash commands
	git log HEAD^...origin/master --decorate --abbrev-commit --pretty=oneline --color=auto
	git diff HEAD...origin/master --stat --color=auto && git diff HEAD...origin/master --color=auto

	if _dotfiles-prompt-choice "OK to pull down now?"; then
		git reset --hard origin/master && source $KDF_BASE_DIR/index.bash
		cd -
	else
		echo "Dotfiles update aborted."
		cd -
		return 1
	fi
}

# -------------------------------------------------
# § 2. Aliases
# -------------------------------------------------

# Enable 'ls' colors by default.
# For Ubuntu/Debian/Solaris: 'ls --color'
# For macOS (Darwin): 'ls -G', but I install GNU coreutils via Homebrew,
# which means 'ls --color' will work there just as well.
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

# For hosts = cvn.wmflabs.org
alias cvnlog='for dir in `ls -d /srv/cvn/services/cvnbot/* | sort -V`; do name=$(basename "$dir"); echo; echo "# $name"; (sudo cat /var/log/syslog | grep -F "[$name]" | tail -n10); done;'

# For os = Ubuntu or Debian
if which ack-grep > /dev/null 2>&1
then
	alias ack=ack-grep
fi

# -------------------------------------------------
# § 3. Setup
# -------------------------------------------------

# Bins: Home
export PATH="${HOME}/bin:${PATH}"

# Fix "sort: string comparison failed: Illegal byte sequence"
export LC_ALL="C"
export LANG="en_US"
# Sort dotfiles before "a" in ls(1) and sort(1) (http://superuser.com/a/448294/164493)
export LC_COLLATE="C"

# http://serverfault.com/a/414763/180257
# See also gitconfig/core.pager
export LESSCHARSET=utf-8

export EDITOR=vim

# Colors
# http://linux.101hacks.com/ps1-examples/prompt-color-using-tput/
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

# Meta variables for Krinkle Dotfiles itself
export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
export KDF_PS1_HOST_NAME="$( hostname -f 2>/dev/null )"
export KDF_PS1_HOST_COLOR="$CLR_CYAN"

# Shell configuration
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s autocd >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s globstar >/dev/null 2>&1
shopt -s histappend >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000


# If not running interactively, stop here
if [ -n "${PS1:-}" ]; then

	test -f /etc/bash_completion && . /etc/bash_completion

	# Bash prompt
	PROMPT_COMMAND="_dotfiles-ps1-setup${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

	# Measure duration of last command
	trap '_dotfiles-timer-start' DEBUG

	# This MUST be the very last thing in PROMPT_COMMAND.
	# As such, per-host index.bash MAY NOT change PROMPT_COMMAND.
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;} _dotfiles-timer-stop"
fi
