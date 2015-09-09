genpass() {
	if [ -z $1 ]; then
		echo "usage: genpasswd <length>"
		return 1
	fi
    pwgen -Bs $1 1 | pbcopy | pbpaste
    echo "Has been copied to clipboard"
}

doclonegerrit() {
	git clone ssh://gerrit.wikimedia.org:29418/$1 $2
}

doaddwmext() {
	EXTDIR=~/Development/mediawiki/core/extensions
	cd $EXTDIR && doclonegerrit mediawiki/extensions/$1 && cd $1
}

domwextforeach() {
	EXTDIR=~/Development/mediawiki/core/extensions
	cd $EXTDIR
	for dir in $(ls); do
		echo "Next: $dir"
		cd $dir
		bash -c "$1"
		cd $EXTDIR
	done
}

doupdatemwext() {
	domwextforeach 'git checkout master -q && git pull -q'
}

# Shows possibly forgotten git stashes and branches
do-globalgitstatus() {
	cwd=$PWD
	repoGroups=(
		~/Development
		~/Development/mediawiki
		~/Development/mediawiki/core/extensions
		~/Development/mediawiki/core/extensions/VisualEditor/lib
		~/Development/wikimedia/integration
		~/Development/wikimedia/operations
	)
	for repoGroup in "${repoGroups[@]}"; do
		for repo in $repoGroup/*; do
			if test -e "$repo/.git"; then
				#echo "... checking $repo"
				cd $repo
				branches=$(git branch)
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
					echo ".../$(basename $repoGroup)/${CLR_BOLD}$(basename $repo)$CLR_NONE"
					printf '%s\n' "${content[@]}"
				fi
			fi
		done
	done
	cd $cwd
}
