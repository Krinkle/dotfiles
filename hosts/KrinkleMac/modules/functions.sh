genpass() {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} <length>"
		return 1
	fi
    pwgen -Bs $1 1 | tee >(pbcopy)
    echo "Has been copied to clipboard"
}

doclonegerrit() {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	git clone ssh://gerrit.wikimedia.org:29418/$1 $2
}

doaddwmext() {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} <name>"
		return 1
	fi
	EXTDIR=~/Development/mediawiki-vagrant/mediawiki/extensions
	cd $EXTDIR && doclonegerrit mediawiki/extensions/$1 && cd $1
}

domwextforeach() {
	EXTDIR=~/Development/mediawiki-vagrant/mediawiki/extensions
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
	base=~/Development
	repoGroups=(
		$base
		~/Development/mediawiki-vagrant/mediawiki
		~/Development/mediawiki-vagrant/mediawiki/extensions
		~/Development/mediawiki-vagrant/mediawiki/extensions/VisualEditor/lib
		~/Development/wikimedia
		~/Development/wikimedia/integration
		~/Development/wikimedia/operations
	)
	for repoGroup in "${repoGroups[@]}"; do
		repos=( $repoGroup )
		repos+=( $repoGroup/*/ )
		for repo in "${repos[@]}"; do
			#echo "... checking $repo"
			if test -e "$repo/.git"; then
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
					echo "${repoGroup#$base/}/${CLR_BOLD}$(basename $repo)$CLR_NONE"
					printf '%s\n' "${content[@]}"
				fi
			fi
		done
	done
	cd $cwd
}
