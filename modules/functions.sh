function _dotfiles-prompt-choice() {
	read -p "$1 (y/n): > " choice
	case "$choice" in
		y|Y)
			return 0
			;;
	esac
	return 1
}

function _dotfiles-ps1-exit_code() {
	[[ $1 != 0 ]] && echo "\[$CLR_RED\]$1\[$CLR_NONE\] "
}

# MacOSX default PS1: '\h:\W \u\$'
function _dotfiles-ps1-setup() {
	local ec="$?"
	local host="$KDF_CANONICAL_HOST"
	local clr_user="$CLR_CYAN"
	local clr_host="$CLR_CYAN"
	local prompt="\$"
	local supportcolor


	# Fix up Wikimedia Labs hostnames
	if [ "$INSTANCENAME" != "" ]; then
		host="$INSTANCENAME"
	elif [ "$KDF_HOST_TYPE" = "KrinkleMac" ]; then
		clr_host="$CLR_MAGENTA"
		host="KrinkleMac"
	elif echo $KDF_CANONICAL_HOST | grep -q -E '\.wikimedia\.org|\.wmnet'; then
		clr_host="$CLR_GREEN"
	fi

	if [ "$LOGNAME" = "root" ]; then
		clr_user="$CLR_RED"
		prompt="#"
	fi

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=1
	fi

	if [[ -n $supportcolor ]]; then
	    PS1="\[$CLR_WHITE\][\$(date +%H:%M\ %Z)] \[$clr_user\]\u\[$CLR_WHITE\] at \[$clr_host\]$host\[$CLR_WHITE\] in \[$CLR_YELLOW\]\w\$(_dotfiles-git-ps1)\[$CLR_NONE\]\n$(_dotfiles-ps1-exit_code $ec)$prompt "
	else
	    PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w$prompt "
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

	CLR_GITST_CLS="$CLR_GREEN" # Clear state
	CLR_GITST_SC="$CLR_YELLOW" # Staged changes
	CLR_GITST_USC="$CLR_RED" # Unstaged changes
	CLR_GITST_UT="$CLR_WHITE" # Untracked files
	CLR_GITST_BR="$CLR_GREEN"

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

# Courtesy of @tstarling
function genpass() {
	tr -cd [:alnum:] < /dev/urandom | head -c10
	echo
}

function dotfiles-pull() {
	cd $KDF_BASE_DIR

	git fetch origin

	# Sanity check before potentially executing arbitrary bash commands
	git log HEAD^...origin/master --decorate --abbrev-commit --pretty=oneline --color=auto
	git diff HEAD...origin/master --stat --color=auto && git diff HEAD...origin/master --color=auto

	if _dotfiles-prompt-choice "OK to pull down now?"; then
		git reset --hard origin/master && source $KDF_BASE_DIR/index.bash
		cd -
	else
		echo "Dotfiles update aborted."
		cd -
		return 1
	fi
}
