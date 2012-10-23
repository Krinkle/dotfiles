#
# Setup check
#

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#
# Includes
#
source ~/.krinkle.dotfiles/modules/setup.bash
source ~/.krinkle.dotfiles/modules/git-completion.bash
source ~/.krinkle.dotfiles/modules/aliases.bash
source ~/.krinkle.dotfiles/modules/functions.bash

P_CANONICAL_HOST="$HOSTNAME"

case $P_CANONICAL_HOST in
	"KrinkleMac.local" | "KrinkleMac.fritz.box" | "krinklemac.fritz.box")
		P_CANONICAL_HOST="KrinkleMac"
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/setup.bash
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/aliases.bash
		;;
esac
