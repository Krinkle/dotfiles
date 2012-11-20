#
# Setup check
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
# Variables
#

P_CANONICAL_HOST="$HOSTNAME"

case "$P_CANONICAL_HOST" in
	"KrinkleMac.local" | "KrinkleMac.fritz.box" | "krinklemac.fritz.box" | "krink_10252.nstrein")
		P_CANONICAL_HOST="KrinkleMac"
		;;
esac

#
# Includes
#
source ~/.krinkle.dotfiles/modules/setup.bash
source ~/.krinkle.dotfiles/modules/aliases.bash
source ~/.krinkle.dotfiles/modules/functions.bash

case "$P_CANONICAL_HOST" in
	"KrinkleMac")
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/setup.bash
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/aliases.bash
		;;
esac
