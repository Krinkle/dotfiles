# Copyright 2021 Timo Tijhof <https://github.com/Krinkle/dotfiles>
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
	git log HEAD^...origin/main --decorate --abbrev-commit --pretty=oneline --color=auto
	git diff HEAD...origin/main --stat --color=auto && git diff HEAD...origin/main --color=auto

	if _dotfiles-prompt-choice "OK to pull down now?"; then
		git reset --hard origin/main
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
	if [ -z $2 ]; then
		dest=$(echo "$1" | tr '/' '-')
	else
		dest="$2"
	fi
	git clone "https://gerrit.wikimedia.org/r/$1" "$dest"
}

function doaddwmext {
	if [ -z "$1" ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	local extDir="$HOME/Development/mediawiki/extensions"
	cd "$extDir" && doclonegerrit "mediawiki/extensions/$1" "$1" && cd "$1"
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

function gigisu {
	git lg-prefix "${1:-}" | less
}

[ -z "${PS1:-}" ] && return

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

alias fit='fresh-node -- npm install-test'
alias fet='fresh-node -- npm test'
alias dsize='du -hs'

# Avoid insertion of Unicode Fullwidth Quotation Mark. https://github.com/yt-dlp/yt-dlp/issues/4547#issuecomment-1817679265
alias _yt='yt-dlp -o "$HOME/dlp/%(upload_date>%Y-%m-%d)s %(uploader)s - %(title)s.%(ext)s" --no-playlist --compat-options filename-sanitization'
# Omit --write-description. https://github.com/yt-dlp/yt-dlp/issues/8616
alias yt='_yt --format b --embed-subs --embed-metadata --print-to-file description "$HOME/dlp/%(upload_date>%Y-%m-%d)s %(uploader)s - %(title)s %(id)s.txt"'
alias yt-audio='_yt --format ba -x --audio-format m4a'

# https://unix.stackexchange.com/a/81699/37512
# dig @resolver3.opendns.com myip.opendns.com +short                   # IPv4
# dig @resolver4.opendns.com myip.opendns.com +short                   # IPv4
# dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short # IPv6
# dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short               # IPv4
# dig @ns1.google.com TXT o-o.myaddr.l.google.com +short               # IPv4+IPv6
# dig @ns1.google.com TXT o-o.myaddr.l.google.com +short -4            # IPv4
# dig @ns1.google.com TXT o-o.myaddr.l.google.com +short -6            # IPv6
alias wanip='dig @resolver4.opendns.com myip.opendns.com +short'
alias wanip4='dig @resolver4.opendns.com myip.opendns.com +short -4'
alias wanip6='dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6'

# Version control
alias g='git'
alias gi='git'
alias gir='git'
alias dogitcommit='git commit -F ~/Temp/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'

alias domakejenkinscommit="git remote update origin && git co -f -b jenkins-sample -t origin/master && echo \"mw.log( 'Jenkins' );\" > jenkins.js && git add jenkins.js && git commit -m '[DNM][WIP] Sample commit for Jenkins'"

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
CLR_NONE=$(tput sgr0 2>/dev/null || true)
CLR_LINE=$(tput smul 2>/dev/null || true)
CLR_BOLD=$(tput bold 2>/dev/null || true)
CLR_BLACK=$(tput setaf 0 2>/dev/null || true)
CLR_RED=$(tput setaf 1 2>/dev/null || true)
CLR_GREEN=$(tput setaf 2 2>/dev/null || true)
CLR_YELLOW=$(tput setaf 3 2>/dev/null || true)
CLR_BLUE=$(tput setaf 4 2>/dev/null || true)
CLR_MAGENTA=$(tput setaf 5 2>/dev/null || true)
CLR_CYAN=$(tput setaf 6 2>/dev/null || true)
CLR_WHITE=$(tput setaf 7 2>/dev/null || true)

# Meta variables for Krinkle Dotfiles itself
export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
export KDF_PS1_HOST_NAME="$( hostname -f 2>/dev/null )"
export KDF_PS1_HOST_COLOR="$CLR_CYAN"

# Bash
#
# Shell configuration
# https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s autocd >/dev/null 2>&1 || true
shopt -s checkwinsize >/dev/null 2>&1 || true
shopt -s globstar >/dev/null 2>&1 || true
shopt -s hostcomplete >/dev/null 2>&1 || true
shopt -s interactive_comments >/dev/null 2>&1 || true
shopt -s no_empty_cmd_completion >/dev/null 2>&1 || true
shopt -u mailwarn >/dev/null 2>&1 || true
# Shell history
#
# - Let multiple tabs append instead of overwrite
shopt -s histappend >/dev/null 2>&1 || true
# - Hide sensitive commands, and increase capacity
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=50000
export HISTFILESIZE=50000
# - Sync after every command instead of only when closing a tab
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# - Hstr preferences
#   https://github.com/dvorka/hstr/blob/master/CONFIGURATION.md
export HSTR_CONFIG=hicolor,help-on-opposite-side

# GnuPG
export GPG_TTY=$(tty)

# difft by Difftastic https://difftastic.wilfred.me.uk/
export DFT_SKIP_UNCHANGED=true

# MediaWiki
export MW_SERVER='http://localhost:4000'
export MW_SCRIPT_PATH=''
export MEDIAWIKI_USER='Admin'
export MEDIAWIKI_PASSWORD='dockerpass'

# Fixes "sort: string comparison failed: Illegal byte sequence"
# Fixes Ruby stuff
#
# NOTE: This depends on the arguably broken way that (some version of)
# Darwin/macOS has these locales configured. It should not be copied to
# my dotfiles for Linux.
export LANG=en_US.UTF-8
export LC_ALL="C"

# Fixes "ArgumentError: invalid byte sequence in US-ASCII" from
# everything Ruby/Jekyll-related.
#
# Yes, this is mutually exclusive with the above, so do this manually
# as-needed. It's only here as reminder.
#
# https://github.com/jekyll/jekyll/issues/960#issuecomment-21311957
# export LC_ALL="en_US.UTF-8"

# Sort dotfiles before "a" in ls(1) and sort(1)
# https://superuser.com/a/448294/164493
export LC_COLLATE="C"

# See also gitconfig/core.pager
# https://serverfault.com/a/414763/180257
export LESSCHARSET=utf-8

export EDITOR=vim

# Homebrew
#
# From `brew shellenv`
export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
# https://github.com/Homebrew/brew/blob/3.0.9/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1
# Don't reinstall the whole world when installing one package
# https://brew.sh/2021/06/21/homebrew-3.2.0/
export HOMEBREW_NO_INSTALL_UPGRADE=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1

# Bins
#
# - System overrides via Homebrew
#   These keg-only packages from Homebrew will override the macOS system defaults.
#   * gnu-coreutils without 'g' prefix, e.g. realpath
#   * bison, libiconv, and icu4c for php-src development
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/libiconv/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/bin:$PATH"
export PATH="/opt/homebrew/opt/icu4c/sbin:$PATH"
# - Gems
#   https://stackoverflow.com/a/14138490/319266
#   Based on "`gem environment gemdir`/bin"
export PATH="/opt/homebrew/lib/ruby/gems/3.2.0/bin:$PATH"
# - Sublime Text (subl)
#   https://www.sublimetext.com/docs/command_line.html
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
# - Homebrew's Git provides diff-highlight
export PATH="/opt/homebrew/opt/git/share/git-core/contrib/diff-highlight:$PATH"
# - Arcanist
#   https://secure.phabricator.com/book/phabricator/article/arcanist_quick_start/
export PATH="${PATH}:${HOME}/Development/arcanist/bin"
# - git-cinnabar for Mozilla development
#   https://firefox-source-docs.mozilla.org/setup/macos_build.html
export PATH="${PATH}:${HOME}/.mozbuild/git-cinnabar"
# - My dotfiles
export PATH="$KDF_BASE_DIR/hosts/primary/bin:$PATH"
# - My Home
export PATH="${HOME}/.local/bin:${PATH}"

# C++ development
#
# - System overrides via Homebrew
#   * libiconv for php-src dev --with-iconv
#   * icu4c for php-src dev --with-intl
export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include"
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/icu4c/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/icu4c/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/icu4c/lib/pkgconfig"

# If running interactively, do the below as well (non-interactively, it's not useful and causes issues).
# Except when we're provisioning, as it would fail due to missing files.
if [ -n "${PS1:-}" ] && [ -z "${KDF_INSTALLER:-}" ]; then
	# Completion modules from Homebrew-installed packages
	. /opt/homebrew/etc/profile.d/bash_completion.sh
	# See also "Aliases"
	__git_complete g __git_main
	__git_complete gi __git_main
	__git_complete gir __git_main

	# Autojump
	. /opt/homebrew/etc/profile.d/autojump.sh

	# Bash prompt
	PROMPT_COMMAND="_dotfiles-ps1-setup${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

	# Measure duration of last command
	trap '_dotfiles-timer-start' DEBUG

	# This MUST be the very last thing in PROMPT_COMMAND.
	PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;} _dotfiles-timer-stop"
fi
