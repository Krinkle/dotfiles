#!/usr/bin/env bash

# Load the 'functions', 'aliases' and 'setup' modules.
source $(dirname $0)/index.bash

function _dotfiles-init() {
	local src="$HOME/.krinkle.dotfiles"
	local backup_dest="$HOME/.dotfiles.backup"

	local file_links="ackrc jshintrc"
	local file_templates="bashrc bash_profile gitconfig"

	echo "$(tput smul)$(tput bold)Home directory$(tput sgr0)"
	echo

	for file in $file_links; do
		_dotfiles-ensure-link "$HOME/.$file" "$src/$file"
	done


	# These are copied instead of symlinked so that they can
	# be altered locally without affecting the repository.
	for file in $file_templates; do
		_dotfiles-ensure-copy "$src/templates/$file" "$HOME/.$file"
	done

	echo "$(tput setaf 2)>>$(tput sgr0) Home directory ready"
}

_dotfiles-init

# Host specific installation
if [[ "$KDF_HOST_INIT" != "" ]]
then
	echo
	echo "${CLR_LINE}${CLR_BOLD}Provisioning $KDF_CANONICAL_HOST$CLR_NONE"
	echo
	echo "$CLR_MAGENTA>>$CLR_NONE Recognised host as $KDF_HOST_TYPE"
	if _dotfiles-prompt-choice "$CLR_MAGENTA>>$CLR_NONE Run host specific provision?"; then
		$KDF_HOST_INIT
		code="$?"
		if [[ "$code" == "0" ]]
		then
			echo
			echo "$CLR_GREEN>>$CLR_NONE Host specific provision ready"
		elif [[ "$code" == "2" ]]
		then
			echo "$CLR_YELLOW>>$CLR_NONE Host specific provision aborted"
			exit 1
		else
			echo "$CLR_RED>> ERROR$CLR_NONE: Host specific provision failed"
			exit 1
		fi
	else
		echo "$CLR_CYAN>>$CLR_NONE Host specific provision skipped"
	fi
fi

echo
echo "$(tput setaf 2)>>$(tput sgr0) Dotfiles init ready"
