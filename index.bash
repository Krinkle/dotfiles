#
# Variables
#
#export KDF_BASE_DIR=~/.krinkle.dotfiles
export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export KDF_CANONICAL_HOST="$( hostname -f 2>/dev/null )"
export KDF_HOST_INIT=""
export KDF_HOST_TYPE="misc"

if [[ "$KDF_CANONICAL_HOST" =~ "krinkle-mbp002" ]]
then
	export KDF_HOST_TYPE="KrinkleMac"
	export KDF_HOST_INIT="$KDF_BASE_DIR/hosts/KrinkleMac/init.bash"
fi

#
# Includes
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source $KDF_BASE_DIR/modules/functions.sh
source $KDF_BASE_DIR/modules/setup.sh
source $KDF_BASE_DIR/modules/aliases.sh

case "$KDF_HOST_TYPE" in
	"KrinkleMac")
		source $KDF_BASE_DIR/hosts/KrinkleMac/modules/aliases.sh
		source $KDF_BASE_DIR/hosts/KrinkleMac/modules/setup.sh
		;;
esac
