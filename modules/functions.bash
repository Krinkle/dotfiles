# Inspiration:
# - http://www.opinionatedprogrammer.com/2011/01/colorful-bash-prompt-reflecting-git-status/
# - https://github.com/sorin-ionescu/prezto/blob/master/helper.zsh
# - https://github.com/sorin-ionescu/prezto/blob/master/plugins/git/functions/git-info
# - http://stackoverflow.com/questions/11122410/fastest-way-to-get-git-status-in-bash

#
# CHEAT SHEAT:
# -z: string is null, that is, has zero length
# -n: string is not null
#

#
# PS1
# MacOSX Default: PS1='\h:\W \u\$'
#
function _dotfiles-ps1-setup() {
	local host
	local clr_home
	local supportcolor

	# On MacOSX $HOSTNAME is "FoobarMac.local" instead of "FoobarMac"
	# So use the PS1 magic "\h" instead, which is correct.
	host="\h"

	clr_home="$CLR_L_GREEN"

	CLR_GITST_CLS="$CLR_GREEN" # Clear state
	CLR_GITST_SC="$CLR_YELLOW" # Staged changes
	CLR_GITST_USC="$CLR_RED" # Unstaged changes
	CLR_GITST_UT="$CLR_L_GREY" # Untracked files
	CLR_GITST_BR="$CLR_GREEN"

	case "$P_CANONICAL_HOST" in
		"KrinkleMac")
			CLR_GITST_BR="$CLR_CYAN"
			clr_home="$CLR_L_CYAN"
			;;
		*)
			if [ "$INSTANCENAME" != "" ]; then
				host="$INSTANCENAME"
			fi
	esac

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=yes
	fi


	if [ "$supportcolor" != "" ]; then
	    PS1="$CLR_L_GREY[\$(date +%H:%M\ %Z)] $clr_home\u@$host$CLR_NONE:$CLR_YELLOW\w\$(_dotfiles-git-ps1)$CLR_NONE\$ "
	else
	    PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w\$ "
	fi


}

#
# Git status
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
		indicator="$indicator${CLR_GITST_SC}*" # Staged changes
	fi
	if [[ -n "$(git ls-files --modified 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_USC}*" # Unstaged changes
	fi

	if [[ -n "$(git ls-files --others --exclude-standard 2> /dev/null)" ]]; then
		indicator="$indicator${CLR_GITST_UT}?" # Untracked files
	fi

	branch="`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`"
	echo -en "${CLR_GITST_BR} ($branch$indicator${CLR_GITST_BR})"
}


#
# Dotfiles
#
function dotfiles-pull() {
	cd $HOME/.krinkle.dotfiles

	git fetch origin
	git log-asi master...origin/master

	# Sanity check before potentially executing arbitrary
	# bash commands.

	git diff master origin/master --stat && git diff master origin/master

	read -p "OK to pull down? (y/n): > " choice
	case "$choice" in
		y|Y)
			git reset --hard origin/master && source $HOME/.krinkle.dotfiles/index.bash
			;;
		* )
			echo "Dotfiles update aborted."
			cd -
			return 1
			;;
	esac

	cd -
}
