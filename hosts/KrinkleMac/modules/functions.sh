genpass() {
	if [ -z $1 ]; then
		echo "usage: genpasswd <length>"
		return 1
	fi
    pwgen -Bs $1 1 | pbcopy | pbpaste
    echo "Has been copied to clipboard"
}
