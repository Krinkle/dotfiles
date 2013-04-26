function _dotfiles-prompt-choice() {
	read -p "$1 (y/n): > " choice
	case "$choice" in
		y|Y)
			echo true
			;;
	esac
}

# MacOSX default PS1: '\h:\W \u\$'
function _dotfiles-ps1-setup() {
	local host
	local clr_host
	local supportcolor

	# On MacOSX $HOSTNAME is "FoobarMac.local" instead of "FoobarMac"
	# So use the PS1 magic "\h" instead, which is correct.
	host="\h"

	clr_host="$CLR_GREEN"

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=yes
	fi

	CLR_GITST_CLS="$CLR_GREEN" # Clear state
	CLR_GITST_SC="$CLR_YELLOW" # Staged changes
	CLR_GITST_USC="$CLR_RED" # Unstaged changes
	CLR_GITST_UT="$CLR_WHITE" # Untracked files
	CLR_GITST_BR="$CLR_GREEN"

	case "$KDF_CANONICAL_HOST" in
		"KrinkleMac")
			clr_host="$CLR_MAGENTA"
			;;
		*)
			if [ "$INSTANCENAME" != "" ]; then
				host="$INSTANCENAME"
			fi
	esac

	if [ "$supportcolor" != "" ]; then
	    PS1="$CLR_WHITE[\$(date +%H:%M\ %Z)] $CLR_CYAN\u$CLR_WHITE at $clr_host$host$CLR_WHITE in $CLR_YELLOW\w\$(_dotfiles-git-ps1)$CLR_NONE\n\$ "
	else
	    PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w\$ "
	fi
}

#
# Git status
# Based on the "official" git-completion.bash
# But more simplified and with colors.
#
function _dotfiles-git-ps1() {
	local st_staged=0
	local st_unstaged=0
	local st_untracked=0
	local indicator
	local branch

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
	echo -en "${CLR_GITST_BR} ($branch$indicator${CLR_GITST_BR})"
}


function dotfiles-pull() {
	cd $HOME/.krinkle.dotfiles

	git fetch origin

	# Sanity check before potentially executing arbitrary bash commands
	# (with fallbacks and inline color config since gitconfig may not loaded or
	# compatible with the local git version).
	git log-asi HEAD...origin/master || git log HEAD...origin/master --decorate --abbrev-commit --pretty=oneline --color=auto
	git diff origin/master --stat --color=auto && git diff origin/master --color=auto

	ret=$(_dotfiles-prompt-choice "OK to pull down?")
	if [[ -n ret ]]
	then
		git reset --hard origin/master && source $HOME/.krinkle.dotfiles/index.bash
		cd -
	else
		echo "Dotfiles update aborted."
		cd -
		return 1
	fi
}
