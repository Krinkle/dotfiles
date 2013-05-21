#
# Variables
#
export KDF_BASE_DIR=~/.krinkle.dotfiles
#export KDF_BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export KDF_CANONICAL_HOST="$HOSTNAME"
export KDF_HOST_INIT=""

case "$KDF_CANONICAL_HOST" in
	"KrinkleMac.local" |\
	"krinklemac" | "krinklemac.home" | "krinklemac.fritz.box" |\
	"GrizzMac.local")
		export KDF_CANONICAL_HOST="KrinkleMac"
		export KDF_HOST_INIT="$KDF_BASE_DIR/hosts/KrinkleMac/init.bash"
		;;
esac

#
# Includes
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

source $KDF_BASE_DIR/modules/aliases.sh
source $KDF_BASE_DIR/modules/functions.sh
source $KDF_BASE_DIR/modules/setup.sh

case "$KDF_CANONICAL_HOST" in
	"KrinkleMac")
		source $KDF_BASE_DIR/hosts/KrinkleMac/modules/aliases.sh
		source $KDF_BASE_DIR/hosts/KrinkleMac/modules/setup.sh
		;;
esac
