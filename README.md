# Krinkle: The Dotfiles

## Install

```bash
$ cd ~
# read-only checkout clone
$ git clone git://github.com/Krinkle/dotfiles.git .krinkle.dotfiles
```

Then depending on where it should go add the following to one or more of <sup>[[1]](http://hacktux.com/bash/bashrc/bash_profile)</sup>:
* `.bash_profile`
* `.bashrc`
* `.profile`

## Set up

```bash
# Overwrite
echo 'source ~/.krinkle.dotfiles/index-login.bash' > .bash_profile
echo 'source ~/.krinkle.dotfiles/index-nonlogin.bash' > .bashrc

# Add
echo 'source ~/.krinkle.dotfiles/index-login.bash' >> .bash_profile
echo 'source ~/.krinkle.dotfiles/index-nonlogin.bash' >> .bashrc

# Other dotfiles (overwrite)
ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/.gitconfig ~/.gitconfig
sudo cp ~/.krinkle.dotfiles/hosts/KrinkleMac/php.ini /etc/php.ini
```