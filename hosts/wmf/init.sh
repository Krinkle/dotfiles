# The wmf host handling is a standalone module
# That does not make use of the global modules and templates

cd $HOME
rm -f .bash_profile .bashrc .gitconfig
ln -s .krinkle.dotfiles/hosts/wmf/bash_profile.sh .bash_profile
ln -s .krinkle.dotfiles/hosts/wmf/bashrc.sh .bashrc
ln -s .krinkle.dotfiles/hosts/wmf/gitconfig .gitconfig
