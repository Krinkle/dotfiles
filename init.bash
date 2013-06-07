#!/usr/bin/env bash

function _dotfiles-init() {
	local src="$HOME/.krinkle.dotfiles"
	local backup_used
	local backup_tmp=`mktemp -d -t dotfiles`
	local backup_dest="$HOME/.dotfiles.backup"

	local file_links="ackrc jshintrc"
	local file_templates="bashrc bash_profile gitconfig"

	echo "$(tput smul)$(tput bold)Home directory$(tput sgr0)"
	echo

	for file in $file_links; do
		echo "... linking $file"
		if [ -e $HOME/.$file ] || [ -h $HOME/.$file ]
		then
			echo "... moving existing $file "
			mv $HOME/.$file $backup_tmp/.$file
			backup_used=1
		fi
		ln -s $src/$file $HOME/.$file
	done


	# These are copied instead of symlinked so that they can
	# be altered locally without affecting the repository.
	for file in $file_templates; do
		echo "... copying $file"
		if [ -e $HOME/.$file ] || [ -h $HOME/.$file ]
		then
			echo "... moving existing $file "
			mv $HOME/.$file $backup_tmp/.$file
			backup_used=1
		fi
		cp $src/templates/$file $HOME/.$file
	done

	if [[ "$backup_used" != "" ]]
	then
		rm -rf $backup_dest
		mv $backup_tmp $backup_dest
		echo
		echo "$(tput setaf 3)>>$(tput sgr0) Found existing files, moved to $backup_dest"
	fi
	rm -rf $backup_tmp

	echo "$(tput setaf 2)>>$(tput sgr0) Home directory ready"
}

_dotfiles-init

source $(dirname $0)/index.bash
source $KDF_BASE_DIR/modules/functions.sh
source $KDF_BASE_DIR/modules/setup.sh

# Host specific installation
if [[ "$KDF_HOST_INIT" != "" ]]
then
	echo
	echo "${CLR_LINE}${CLR_BOLD}Provisioning $KDF_CANONICAL_HOST$CLR_NONE"
	echo
	echo "$CLR_MAGENTA>>$CLR_NONE Recognised host as $KDF_CANONICAL_HOST"
	ret=$(_dotfiles-prompt-choice "$CLR_MAGENTA>>$CLR_NONE Run host specific privison?")
	if [[ -n $ret ]]
	then
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
