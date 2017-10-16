#
# Set up
#
# Load order:
# - modules/functions.sh
# - modules/aliases.sh
# - (set KDF_ vars)
# - If interactive:
#   - hosts/$HOST_TYPE/modules/functions.sh
#   - hosts/$HOST_TYPE/modules/aliases.sh
#   - hosts/$HOST_TYPE/modules/setup.sh
#   - modules/setup.sh

# Effectively the same as: `export KDF_BASE_DIR=~/.krinkle.dotfiles`
export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $KDF_BASE_DIR/modules/functions.sh
source $KDF_BASE_DIR/modules/aliases.sh

#
# Variables
#

export KDF_CANONICAL_HOST="$( hostname -f 2>/dev/null )"
export KDF_HOST_INIT=""
export KDF_HOST_TYPE="misc"

if [[ "$UNAME" == "SunOS" && -z "$KDF_CANONICAL_HOST" ]]
then
	# Solaris doesn't support `hostname -f` to get fqdn
	# fallback to plain `hostname`, already set in $HOSTNAME.
	export KDF_CANONICAL_HOST="$HOSTNAME"
fi

if [[ "$KDF_CANONICAL_HOST" =~ 'krinkle-mbp' ]]
then
	export KDF_HOST_TYPE="KrinkleMac"
	export KDF_HOST_INIT="$KDF_BASE_DIR/hosts/KrinkleMac/init.bash"
fi

#
# Includes
#

# If not running interactively, stop here
[ -z "$PS1" ] && return

if [ -n "$KDF_HOST_TYPE" ]
then
	files="functions aliases setup"
	for f in $files; do
		[[ -s $KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/modules/$f.sh ]] && . $KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/modules/$f.sh
	done
fi

source $KDF_BASE_DIR/modules/setup.sh
