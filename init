#!/bin/bash

#
# Variables
#
dir="$HOME/.krinkle.dotfiles"
backup_dir="$HOME/.dotfiles.backup"

files="gitconfig jshintrc bashrc bash_profile"


#
# Backup & install
#
echo "...creating back up directory: $backup_dir"
mkdir -p $backup_dir

for file in $files; do
	echo "... * $file"
	( test -e $HOME/.$file || test -h $HOME/.$file ) && echo "Moving existing .$file to $backup_dir" && mv $HOME/.$file $backup_dir
	ln -s $dir/$file $HOME/.$file
done
