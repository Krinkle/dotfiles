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
