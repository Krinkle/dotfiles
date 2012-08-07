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

	# if [[ -n "$(git status --porcelain 2> /dev/null)" ]]; then
	# 	if git diff-index --cached --quiet HEAD --; then
	# 		indicator="$indicator${CLR_GITST_USC}*" # Unstaged changes
	# 	fi
	# 	if git diff-index --quiet HEAD; then
	# 		indicator="$indicator${CLR_GITST_SC}*" # Staged changes
	# 	fi
	# fi
	# if [ -n "$(git ls-files --others --exclude-standard)" ]; then
	# 	indicator="$indicator${CLR_GITST_UT}?" # Untracked files
	# fi

	# IFS=$'\n'
	# for line in `git status --porcelain 2> /dev/null`; do
	# 	if [[ "$line" =~ ^[MADRCT]\ .* ]]; then
	# 		(( st_staged++ ))
	# 	fi
	# 	if [[ "$line" =~ ^[MADRCT\ ][MADRCT]\ .* ]]; then
	# 		(( st_unstaged++ ))
	# 	fi
	# 	if [[ "$line" =~ ^\?\?\ .* ]]; then
	# 		(( st_untracked++ ))
	# 	fi
	# done
	# unset IFS

	# if (( st_staged )); then
	# 	indicator="$indicator${CLR_GITST_SC}*" 
	# fi
	# if (( st_unstaged )); then
	# 	indicator="$indicator${CLR_GITST_USC}*" 
	# fi
	# if (( st_untracked )); then
	# 	indicator="$indicator${CLR_GITST_UT}?" 
	# fi

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
