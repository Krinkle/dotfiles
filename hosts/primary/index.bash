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
	if [ -z "$2" ]; then
		echo "usage: ${FUNCNAME[0]} <link-path> <link-dest>"
		return 1
	fi
	local path="$1"
	local dest="$2"
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

# Default PS1 on macOS: '\h:\W \u\$'
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

function genpass {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <length>"
		return 1
	fi
    pwgen -Bs $1 1 | tee >(pbcopy)
    echo "Has been copied to clipboard"
}

function doclonegerrit {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	git clone https://gerrit.wikimedia.org/r/$1 $2
}

function doaddwmext {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	local extDir="$HOME/Development/mediawiki/extensions"
	cd "$extDir" && doclonegerrit "mediawiki/extensions/$1" && cd "$1"
}

function domwextforeach {
	local extDir="$HOME/Development/mediawiki/extensions"
	cd "$extDir"
	for dir in $(ls); do
		if [[ "$dir" == "README" ]]; then
			continue
		fi
		echo "Next: $dir"
		cd "$dir"
		bash -c "$1"
		cd "$extDir"
	done
}

function doupdatemwext {
	domwextforeach 'git checkout master -q && git pull -q'
}

function _globalgitstatus_read {
	local treedir
	while read gitdir; do
		treedir=$(dirname "$gitdir")
		cd "$treedir"
		# there should generally be only one local branch
		# (e.g. 'master', 'production', or 'dev')
		# with a few exceptions, such as gh-pages.
		branches=$(git branch | grep -vE 'gh-pages|puppet-stage')
		branchCount=$(echo "$branches" | wc -l)
		stash=$(git stash list)
		content=()
		if [[ $branchCount -gt 1 ]]; then
			content+=("$branches")
		fi
		if test -n "$stash"; then
			content+=("$stash")
		fi
		content=$(printf '%s\n' "${content[@]}")
		if test -n "$content"; then
			echo
			echo "$(dirname "$treedir")/${CLR_BOLD}$(basename "$treedir")$CLR_NONE"
			printf '%s\n' "$content"
		fi
	done
}

# Find possibly forgotten git stashes and branches.
# Check all .git repositories (upto a certain depth)
# and report any stashes and custom branches.
function do-globalgitstatus {
	cwd=$PWD
	base="$HOME/Development"
	find "$base" -type d -name '.git' -mindepth 1 -maxdepth 6 | _globalgitstatus_read
	cd $cwd
}

function vlc-convert-m4a {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <input>"
		return 1
	fi
	vlc="/Applications/VLC.app/Contents/MacOS/VLC"
	input="$1"
	# swap last extension
	output="${input%.*}.m4a"
	# strip any quotes
	output="${output//\"}"
	"$vlc" -I dummy --sout "#transcode{acodec=mp4a,ab=256,channels=2,samplerate=44100}:std{access=file,mux=mp4,dst=\"$output\"}" "$input" "vlc://quit"
}

# Workaround: 'arc patch' doesn't work properly when applying patches
# that upstream Phabricator knows will go into an SVN repo, when the
# local is a Git repo. It will eagerly demand to find the latest SVN
# revision in the local Git repo by scanning every commit in the history
# for the right 'git-svn-id:' text in the commit message, which takes
# forever.
#
# https://secure.phabricator.com/T9044
#
function pullfrom0ad {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <Dnnn>"
		return 1
	fi
	patch="$1"
	curl "https://code.wildfiregames.com/{$patch}?download=true" -L 2>/dev/null > /tmp/arc.diff
	# Create or overwrite a dedicated branch and quitely reset to latest origin/master.
	# This uses 'git checkout -B' instead of 'git branch -f' because the latter doesn't
	# work if you're already on the given branch.
	git checkout -q -B "arcpatch_$patch" origin/master
	# Note, ideally this should be:
	# `arc patch --force --nocommit --patch /tmp/arc.diff`
	#
	# ... because Arcanist is from Phabricator, which is where the patch is downloaded
	# from. Unfortunately, arc-diff doesn't understand its own output.
	# For new files it uses '--- /dev/null +++ new/file.txt', which arc-diff fails to apply:
	# > error: dev/null: does not exist in index
	# > Usage Exception: Unable to apply patch!
	#
	# Work around by using 'git apply' instead, which does understand it.
	git apply -p0 --index -v /tmp/arc.diff
	git commit -q -m "${patch}"
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

# Version control
alias g='git'
alias gi='git'
alias gir='git'
alias dogitcommit='git commit -F ~/Development/Temp/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'
alias gigisu='git lg-prefix'

alias domakejenkinscommit='git remote update origin && git co -b jenkins -t origin/master && touch jenkins.js jenkins.css jenkins.php .jenkins && git add jenkins.js jenkins.css jenkins.php .jenkins && git commit -m "Sample commit for Jenkins"'

alias diff='colordiff'
alias sdi='svn diff | colordiff'

# http://ariejan.net/2011/11/08/fixing-a-slow-starting-terminal-or-iterm2-on-mac-os-x
# https://discussions.apple.com/thread/2178316?start=0&tstart=0
# http://osxdaily.com/2010/05/06/speed-up-a-slow-terminal-by-clearing-log-files/
alias dotruncateasl='sudo rm /var/log/asl/*.asl'

# http://support.apple.com/kb/ht5343
alias doflushdns='sudo killall -HUP mDNSResponder'

# https://snipt.net/Yannick/delete-recursively-a-file-ds_store-thumbsdb-desktopini-etc/
alias dormdsstore='find . -name ".DS_Store" -type f -exec rm {} \;'
alias dormnodedirs='find . -name "node_modules" -type d -print -exec rm -rf {} \; 2>/dev/null'

alias dotfiles-push='cd $KDF_BASE_DIR; git add -p && _dotfiles-prompt-choice "OK to push now?" && git commit -m "update dotfiles" && git push origin HEAD; cd -'

# -------------------------------------------------
# § 3. Setup
# -------------------------------------------------

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
shopt -s autocd >/dev/null 2>&1 || true
shopt -s checkwinsize >/dev/null 2>&1 || true
shopt -s globstar >/dev/null 2>&1 || true
shopt -s histappend >/dev/null 2>&1 || true
shopt -s hostcomplete >/dev/null 2>&1 || true
shopt -s interactive_comments >/dev/null 2>&1 || true
shopt -s no_empty_cmd_completion >/dev/null 2>&1 || true
shopt -u mailwarn >/dev/null 2>&1 || true

export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Based  on `brew --prefix ruby`
export PATH=/usr/local/opt/ruby/bin:$PATH
# Based on `gem environment gemdir`
export PATH=/usr/local/lib/ruby/gems/2.7.0/bin:$PATH

# Bins: Homebrew's coreutils (e.g. realpath)
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# Bins: Homebrew's PHP
export PATH=/usr/local/opt/php@7.2/bin:$PATH

# Bins: Sublime Text (subl)
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Bins: Composer global
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Bins: Misc dotfiles utilities
export PATH="$KDF_BASE_DIR/hosts/primary/bin:$PATH"

# Bins: Git contrib: diff-highlight
export PATH="/usr/local/opt/git/share/git-core/contrib/diff-highlight:$PATH"

# Bins: Arcnanist
# https://secure.phabricator.com/book/phabricator/article/arcanist_quick_start/
export PATH="${PATH}:${HOME}/Development/arcanist/bin"

# Bins: Home
export PATH="${HOME}/bin:${PATH}"

# GnuPG
export GPG_TTY=$(tty)

# MediaWiki
export MW_SERVER='http://default.web.mw.localhost:8080'
export MW_SCRIPT_PATH='/mediawiki'
export MEDIAWIKI_USER='Admin'
export MEDIAWIKI_PASSWORD='dockerpass'

# - Fix "sort: string comparison failed: Illegal byte sequence"
# - Fix Ruby stuff
# NOTE: This depends on the arguably broken way that (some version of)
# Darwin/macOS has these locales configured. It should not be copied to
# my dotfiles for Linux.
export LANG="en_US"
export LC_ALL="C"

# Sort dotfiles before "a" in ls(1) and sort(1)
# https://superuser.com/a/448294/164493
export LC_COLLATE="C"

# See also gitconfig/core.pager
# https://serverfault.com/a/414763/180257
export LESSCHARSET=utf-8

export EDITOR=vim

# If running interactively, do the below as well (non-interactively, it's not useful and causes issues).
# Except when we're provisioning, as it would fail due to missing files.
if [ -n "${PS1:-}" ] && [ -z "${KDF_INSTALLER:-}" ]; then
	# Completion modules from Homebrew-installed packages
	. /usr/local/etc/bash_completion
	# See also "Aliases"
	__git_complete g _git
	__git_complete gi _git
	__git_complete gir _git

	[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh

	# Bash prompt
	PROMPT_COMMAND="_dotfiles-ps1-setup${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

	# Measure duration of last command
	trap '_dotfiles-timer-start' DEBUG

	# This MUST be the very last thing in PROMPT_COMMAND.
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;} _dotfiles-timer-stop"
fi
