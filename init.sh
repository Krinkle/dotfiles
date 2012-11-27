#!/bin/bash

#
# Variables
#
dir="$HOME/.krinkle.dotfiles"
backup_dir="$HOME/.dotfiles.backup"

files_ref="jshintrc"
files_tpl="bashrc bash_profile gitconfig"

#
# Backup & install
#
echo "...creating back up directory: $backup_dir"
mkdir -p $backup_dir

for file in $files_ref; do
	echo "... * $file"
	( test -e $HOME/.$file || test -h $HOME/.$file ) && echo "Moving existing .$file to $backup_dir" && mv $HOME/.$file $backup_dir
	ln -s $dir/$file $HOME/.$file
done


# These are copied instead of symlinked so that they can
# be extended locally. These are the kind of files that can
# have includes, so the template is just a basic file that
# includes something from the dotfiles. That way it is maintained
# by dotfiles while also allowing local overrides.
for file in $files_tpl; do
	echo "... * $file"
	( test -e $HOME/.$file || test -h $HOME/.$file ) && echo "Moving existing .$file to $backup_dir" && mv $HOME/.$file $backup_dir
	cp $dir/templates/$file $HOME/.$file
done
