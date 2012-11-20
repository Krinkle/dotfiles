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
# GIT
#

# function parse_git_status() {
# 	local char
# 	local git_status="`git status -unormal 2>&1`"
# 	if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
# 		if [[ "$git_status" =~ nothing\ to\ commit ]]; then
# 			char="${CLR_GITST_CLS}${CLR_GITBR}"
# 		elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
# 			char="${CLR_GITST_UT}!${CLR_GITBR}"
# 		else
# 			char="${CLR_GITST_USC}*${CLR_GITBR}"
# 		fi
# 		echo -en "$char"
# 	fi
# }

function get-git-info() {
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
	echo -en "${CLR_GITBR} ($branch$indicator${CLR_GITBR})"
}

#
# Dotfiles
#

function dotfiles-pull() {
	cd $HOME/.krinkle.dotfiles

	git fetch origin
	git log-asi master...origin/master
	git diff master origin/master --stat && git diff master origin/master

	read -p "Continue (y/n): > " choice
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
