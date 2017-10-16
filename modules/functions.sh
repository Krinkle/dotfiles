function _dotfiles-prompt-choice() {
	read -p "$1 (y/n): > " choice
	case "$choice" in
		y|Y)
			return 0
			;;
	esac
	return 1
}

function _dotfiles-ps1-time() {
	local text=""
	if [[ "$KDF_timer_show" != "0" ]]; then
		text="${KDF_timer_show}s "
	fi
	echo "$text"

}

function _dotfiles-ensure-link {
	if [ -z $2 ]; then
		echo "usage: ${FUNCNAME[0]} <link-path> <link-dest>"
		return 1
	fi
	local path=$1
	local dest=$2
	local name="$(basename $dest)"
	local backup_dest="$HOME/.dotfiles.backup"
	local suffix
	# Do nothing if the path is already a link to the same destination.
	if [[ ! -L $path || "$(readlink $path)" != $dest ]]; then
		if [[ -e $path ]]; then
			if [[ -L $path ]]; then
				# Remove existing link with different destination.
				rm "$path"
			else
				# Create backup of existing non-link (file or directory).
				echo "... moving existing $name to ~/.dotfiles.backup"
				suffix=".$(date +%Y-%m-%dT%H%I%S).$RANDOM.bak"
				mv "$path" "$backup_dest/${name}${suffix}"
			fi
		fi
		echo "... linking $name"
		ln -s "$dest" "$path"
	fi
}

function _dotfiles-ensure-copy {
	if [ -z $2 ]; then
		echo "usage: ${FUNCNAME[0]} <src> <dest>"
		return 1
	fi
	local src=$1
	local dest=$2
	local name="$(basename $src)"
	local backup_dest="$HOME/.dotfiles.backup"
	local suffix
	if [[ -e $dest ]]; then
		if [[ -L $dest ]]; then
			# Remove link (without backup)
			rm "$dest"
		else
			# Create backup of non-link (file or directory).
			echo "... moving existing $name to ~/.dotfiles.backup"
			suffix=".$(date +%Y-%m-%dT%H%I%S).$RANDOM.bak"
			mv "$dest" "$backup_dest/${name}${suffix}"
		fi
	fi
	echo "... copying $name"
	cp "$src" "$dest"
}

# MacOSX default PS1: '\h:\W \u\$'
function _dotfiles-ps1-setup() {
	local ec="$?"
	local host="$KDF_CANONICAL_HOST"
	local clr_user="$CLR_CYAN"
	local clr_host="$CLR_CYAN"
	local prompt="\$"
	local supportcolor

	if [ "$KDF_HOST_TYPE" = "KrinkleMac" ]; then
		clr_host="$CLR_MAGENTA"
		host="KrinkleMac"
	elif echo $KDF_CANONICAL_HOST | grep -q -E '\.wikimedia\.org|\.wmnet'; then
		clr_host="$CLR_GREEN"
	fi

	if [ "$LOGNAME" = "root" ]; then
		clr_user="$CLR_RED"
		prompt="#"
	fi

	if [[ $ec != 0 ]]; then
		prompt="\[$CLR_RED\]$ec\[$CLR_NONE\] $prompt"
	fi

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		supportcolor=1
	fi

	if [[ -n $supportcolor ]]; then
		PS1="\[$CLR_WHITE\][\$(date +%H:%M\ %Z)] \[$clr_user\]\u\[$CLR_WHITE\] at \[$clr_host\]$host\[$CLR_WHITE\] in \[$CLR_YELLOW\]\w\$(_dotfiles-git-ps1)\[$CLR_NONE\]\n\$(_dotfiles-ps1-time)$prompt "
	else
		PS1="[\$(date +%H:%M\ %Z)] \u@$host:\w$prompt "
	fi
}

#
# Last command run-time measuring
#
# http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/
#
# Installation:
# > trap '_dotfiles-timer-start' DEBUG
# > PROMPT_COMMAND="$PROMPT_COMMAND; _dotfiles-timer-stop"
# > PS1='[${KDF_timer_show}s] [\w]$ "

function _dotfiles-timer-start() {
	export KDF_timer=${KDF_timer:-$SECONDS}
}

function _dotfiles-timer-stop() {
	export KDF_timer_show=$(($SECONDS - $KDF_timer))
	unset KDF_timer
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
	echo -n "${CLR_GITST_BR} ($branch$indicator${CLR_GITST_BR})"
}

# Courtesy of @tstarling
function genpass() {
	tr -cd [:alnum:] < /dev/urandom | head -c10
	echo
}

# Source:
# http://coopology.com/2013/10/using-ps-to-output-human-readable-memory-usage-for-each-process-using-awk/
# Example usage:
# $ ps u | awk_ps_format
function awk_ps_format() {
	awk '{
for ( x=1 ; x<=4 ; x++ ) { printf("%s\t",$x) }
for ( x=5 ; x<=6 ; x++ ) {  if (NR>1) { printf("%13.2fMb\t",hr=$x/1024) }
else { printf("\t%s\t",$x)  }
}
for ( x=7 ; x<=10 ; x++ ) { printf("%s\t",$x) }
for ( x=11 ; x<=NF ; x++ ) { printf("%s ",$x) }
print ""
}'
}

# Example usage:
# $ ps_filter mycommand
function ps_filter() {
	local pattern="$1"
	local res=`ps aux`
	echo "$res" | awk_ps_format | head -1
	echo "$res" | awk_ps_format | grep "$pattern" | grep -vE 'nohup|grep'
}

# Abstraction for essentially the following:
# $ sudo tail -n100 -f /var/log/syslog | grep --line-buffered CVNBot.exe | sed 's/#012/\n\t/g'
# Explanation:
#
# - Read last N lines from syslog.
# - Follow in real-time.
# - Filter for a specific pattern.
# - Ensure grep flushes each line so that sed can filter.
# - Use sed to expand the single-line compressed traces from log4net.
#
# Usage:
# $ syslog_filter [-n N=100] <pattern>
function syslog_filter() {
	if [ -z $1 ]; then
		echo "usage: ${FUNCNAME[0]} [-n NUM] <pattern>"
		return 1
	fi

	local lines=100
	if [[ "$1" == "-n" ]]; then
		lines="$2"
		shift
		shift
	fi

	sudo tail -n"$lines" -f /var/log/syslog | grep --line-buffered "$1" | sed 's/#012/\n\t/g'
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
