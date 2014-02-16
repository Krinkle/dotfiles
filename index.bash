# If not running interactively, don't do anything
[ -z "$PS1" ] && return


#
# Set up
#

#export KDF_BASE_DIR=~/.krinkle.dotfiles
export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $KDF_BASE_DIR/modules/setup.sh

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

source $KDF_BASE_DIR/modules/functions.sh
source $KDF_BASE_DIR/modules/aliases.sh

if [ -n "$KDF_HOST_TYPE" ]
then
	files="aliases setup"
	for f in $files; do
		[[ -s $KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/modules/$f.sh ]] && . $KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/modules/$f.sh
	done
fi
