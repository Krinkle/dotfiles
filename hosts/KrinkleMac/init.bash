#!/usr/bin/env bash

source $KDF_BASE_DIR/modules/functions.sh

function _dotfiles-host-init {

	# Homebrew
	echo "... check Homebrew"
	if [ -z "$(which brew)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Homebrew first"
		open http://brew.sh
		exit 1
	fi

	echo "... update Homebrew"
	brew update
	echo "... exec 'brew doctor'"
	brew doctor
	if [[ $? != 0 ]]
	then
		if ! _dotfiles-prompt-choice "Check out those warnings. Continue?"; then
			exit 2
		fi
	fi

	echo "... ensure Homebrew packages"
	brew tap homebrew/homebrew-php
	formulas=(
		ack
		autojump
		bash
		bash-completion
		colordiff
		composer
		coreutils
		git
		# https://www.mediawiki.org/wiki/Gerrit/git-review#OS_X
		git-review
		gnupg2
		hh
		jq
		node
		pwgen
		ruby
		watch
		wget
		httpd
	)
	for f in "${formulas[@]}"; do
		brew upgrade $f || brew install $f
		if [[ $? != 0 ]]
		then
			echo "$CLR_RED>> ERROR$CLR_NONE: Failed to install '$f'"
			exit 1
		fi
	done
	# After 'httpd' above
	brew upgrade php@7.2 --with-httpd || brew install php@7.2 --with-httpd
	if [[ $? != 0 ]]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Failed to install 'php'"
		exit 1
	fi

	brew cleanup

	echo "... ensure npm packages"
	npm install -g fast-cli

	echo "... ensure RubyGems packages"
	gem install jsduck

	echo "... ensure PHP PECL packages"
	pecl install apcu xdebug apcu_bc

	echo "... post-install: php"
	test -f /usr/local/etc/php/7.2/conf.d/krinkle.ini || ( echo "linking php.ini" && ln -s $KDF_BASE_DIR/hosts/KrinkleMac/php.ini /usr/local/etc/php/7.2/conf.d/krinkle.ini )

	echo "... post-install: git"
	_dotfiles-ensure-link ~/.gitconfig $KDF_BASE_DIR/hosts/KrinkleMac/gitconfig

	echo "... post-install: ssh"
	_dotfiles-ensure-link ~/.ssh/config $KDF_BASE_DIR/hosts/KrinkleMac/sshconfig

	echo "... check Sublime Text"
	if [ -z "$(which subl)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Sublime Text"
		open http://www.sublimetext.com/3
		exit 1
	fi

	echo "... post-install: Sublime Text"
	tmpPath=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/SublimePreferences.json
	_dotfiles-ensure-link "$tmpPath" "$tmpDest"

	tmpPath=$HOME/.config
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/config
	_dotfiles-ensure-link "$tmpPath" "$tmpDest"
}

_dotfiles-host-init

source $KDF_BASE_DIR/index.bash

#
# SSH Key
#
# https://help.github.com/articles/generating-ssh-keys

#
# GPG key
#
# https://help.github.com/articles/generating-a-new-gpg-key/
# https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/
# https://help.github.com/articles/telling-git-about-your-gpg-key/

#
# Terminal
#
# Preferences
# - Profile: Pro
# - Cursor: Vertical Bar
# - Blink cursor: Enabled
# - Font: Menlo Regular 12pt
# - Pointer High-contrast beam: Disabled

#
# System Preferences
#
# Mission Control
# http://apple.stackexchange.com/a/44801
# * (disabled) Automatically rearrange Spaces based on most recent use
#
# Keyboard -> Shortcuts -> Mission Control
# These interfere with Sublime selection expansion shortcuts (Shift^↑ and Shift^↓)
# * (disabled) Mission Control - "^↑"
# * (disabled) Application Windows - "^↓"

#
# Development
#
# ## Code
#
# $ mkdir -p ~/Development
# $ cd ~/Development
# $ doclonegerrit mediawiki
# $ doclonegerrit oojs/core oojs
# $ doclonegerrit oojs/ui oojs-ui
# $ doclonegerrit integration/config wikimedia/integration/config
# $ doclonegerrit operations/mediawiki-config wikimedia/operations/mediawiki-config
# $ doclonegerrit operations/puppet wikimedia/operations/puppet
#
# ## Apache
#
#
# # Change `Listen 8080` to `Listen 8000`
# $ edit /usr/local/etc/httpd/httpd.conf
#
# # Load custom config
# $ mkdir /usr/local/etc/httpd/other
# $ echo 'Include /usr/local/etc/httpd/other/*.conf' >> /usr/local/etc/httpd/httpd.conf
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/httpd/other/krinkle.conf
#
#
# ## MediaWiki-Vagrant
#
# https://www.mediawiki.org/wiki/MediaWiki-Vagrant
#
# ## Sequel Pro
#
# Type: SSH
# Name: MediaWiki-Vagrant
# [
# 	MySQL Host: 127.0.0.1
# 	Username: root
# 	Password: vagrant
# ]
# [
# 	SSH Host: 127.0.0.1
# 	SSH Port: 2222
# 	SSH User: vagrant
# 	SSH Key: ~/.vagrant.d/insecure_private_key
# ]

#
# GUI Applications
#
## Applications
# Install via App Store:
# - OmniFocus
# - Pixelmator
# - Simplenote
# - The Unarchiver
# Install:
# - Atom
# - coconutBattery
# - Docker
# - Firefox
# - FirefoxDeveloperEdition
# - Google Chrome
# - Google Chrome Canary
# - ImageOptim
# - MySQLWorkbench
# - OpenOffice
# - Opera
# - Safari Technology Preview
# - Sequel Pro
# - Sublime Textd
# - VirtualBox
# - VLC
#
## Sublime Text
# Plugins:
# - https://packagecontrol.io/installation
# - DocBlockr
# - LESS
# - Puppet
# - SublimeLinter
# - SublimeLinter-contrib-eslint
# - Theme - Soda
# - TrailingSpaces
#
## Atom
# Community Packages:
# - minimap
# - highlight-selected
# - minimap-highlight-selected
# Community Themes:
# - monokai
#
