# Replaces generic from /modules/functions.sh
function genpass {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} <length>"
		return 1
	fi
    pwgen -Bs $1 1 | tee >(pbcopy)
    echo "Has been copied to clipboard"
}

function doclonegerrit {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	git clone https://gerrit.wikimedia.org/r/$1 $2
}

function doaddwmext {
	if [ -z $1 ]; then
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
		cd "$EXTDIR"
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
			printf '%s\n' "${content[@]}"
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
