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

case $HOSTNAME in
	KrinkleMac.local)
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/setup.bash
		source ~/.krinkle.dotfiles/hosts/KrinkleMac/modules/aliases.bash
		;;
esac
