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
	EXTDIR=~/Development/mediawiki/extensions;
	cd $EXTDIR && doclonegerrit mediawiki/extensions/$1 && cd $1
}

# Shows possibly forgotten git stashes and branches
do-globalgitstatus() {
	cwd=$PWD
	repoGroups=(
		~/Development
		~/Development/mediawiki
		~/Development/mediawiki/extensions
		~/Development/wikimedia/integration
		~/Development/wikimedia/operations
	)
	for repoGroup in "${repoGroups[@]}"; do
		for repo in $repoGroup/*; do
			if test -d "$repo/.git"; then
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
