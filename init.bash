#!/usr/bin/env bash

function _dotfiles-init() {
	local src="$HOME/.krinkle.dotfiles"
	local backup_used
	local backup_tmp=`mktemp -d -t dotfiles`
	local backup_dest="$HOME/.dotfiles.backup"

	local file_links="jshintrc"
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

# Host specific installation
if [[ "$KDF_HOST_INIT" != "" ]]
then
	echo
	echo "$(tput smul)$(tput bold)Provisioning $KDF_CANONICAL_HOST$(tput sgr0)"
	echo
	echo "$(tput setaf 5)>>$(tput sgr0) Recognised host as $KDF_CANONICAL_HOST"
	read -p "$(tput setaf 5)>>$(tput sgr0) Run host specific privison? (y/n): > " choice
	case "$choice" in
		y|Y)
			$KDF_HOST_INIT
			if [[ "$?" == "0" ]]
			then
				echo
				echo "$(tput setaf 2)>>$(tput sgr0) Host specific provision ready"
			else
				echo "$(tput setaf 1)>> ERROR$(tput sgr0): Host specific provision failed"
				exit 1
			fi
			;;
		* )
			echo "$(tput setaf 3)>>$(tput sgr0) Host specific provision aborted"
			exit 1
			;;
	esac
fi

echo
echo "$(tput setaf 2)>>$(tput sgr0) Dotfiles init ready"
