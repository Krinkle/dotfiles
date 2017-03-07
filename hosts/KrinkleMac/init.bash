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
	brew tap homebrew/dupes
	brew tap homebrew/versions
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
	)
	for f in "${formulas[@]}"; do
		brew upgrade $f || brew install $f
		if [[ $? != 0 ]]
		then
			echo "$CLR_RED>> ERROR$CLR_NONE: Failed to install '$f'"
			exit 1
		fi
	done
	# https://github.com/Homebrew/homebrew-php/issues/3714
	brew upgrade php56 --with-apache || brew install php56 --with-apache
	if [[ $? != 0 ]]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Failed to install 'php56'"
		exit 1
	fi
	brew cleanup

	echo "... ensure npm packages"
	npm install -g grunt-cli jshint jscs speed-test

	echo "... ensure RubyGems packages"
	gem install jsduck

	echo "... post-install: php"
	mkdir -p /usr/local/etc/php/5.6/conf.d
	test -f /usr/local/etc/php/5.6/conf.d/krinkle.ini || ( echo "linking php.ini" && ln -s $KDF_BASE_DIR/hosts/KrinkleMac/php.ini /usr/local/etc/php/5.6/conf.d/krinkle.ini )

	echo "... post-install: git"
	# Only change if not a symlink, or a symlink to the wrong place
	tmpPath=~/.gitconfig
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/templates/gitconfig
	if [[ ! -L $tmpPath || "$(readlink $tmpPath)" != $tmpDest ]]
	then
		test ! -f $tmpPath || rm $tmpPath
		echo "linking .gitconfig"
		ln -s $tmpDest $tmpPath
	fi

	echo "... check Sublime Text"
	if [ -z "$(which subl)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Sublime Text"
		open http://www.sublimetext.com/3
		exit 1
	fi

	echo "... post-install: Sublime Text"
	tmpPath=~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/SublimePreferences.json
	if [[ ! -L "$tmpPath" || $(readlink "$tmpPath") != $tmpDest ]]
	then
		test ! -f "$tmpPath" || rm "$tmpPath"
		echo "linking SublimePreferences.json"
		ln -s "$tmpDest" "$tmpPath"
	fi

	tmpPath=~/.config
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/config
	if [[ ! -L $tmpPath || "$(readlink $tmpPath)" != $tmpDest ]]
	then
		test ! -f $tmpPath || rm $tmpPath
		echo "linking .config"
		ln -s $tmpDest $tmpPath
	fi
}

_dotfiles-host-init

source $KDF_BASE_DIR/index.bash

#
# SSH Key
#
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
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
# $ doclonegerrit mediawiki/vagrant mediawiki-vagrant
# $ doclonegerrit oojs/core oojs
# $ doclonegerrit oojs/ui oojs-ui
# $ doclonegerrit unicodejs
# $ doclonegerrit integration/config wikimedia/integration/config
# $ doclonegerrit operations/mediawiki-config wikimedia/operations/mediawiki-config
# $ doclonegerrit operations/puppet wikimedia/operations/puppet/
#
# ## Apache
#
# # HOTFIX: https://github.com/Homebrew/homebrew-apache/issues/75
# $ ln -s /usr/local/Cellar/apr/1.5.2_1 /usr/local/Cellar/apr/1.5.2
#
# $ brew install homebrew/apache/httpd24 --with-privileged-ports
# ==> Caveats:
#     - `sudo brew services start homebrew/apache/httpd24`
#
# $ mkdir /usr/local/etc/apache2/2.4/other
# $ echo 'Include /usr/local/etc/apache2/2.4/other/*.conf' >> /usr/local/etc/apache2/2.4/httpd.conf
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/apache2/2.4/other/krinkle.conf
# $ sudo brew services restart httpd24
#
# ## https://www.mediawiki.org/wiki/MediaWiki-Vagrant
#
# - VirtualBox
# - Vagrant
# - Run:
# $ cd mediawiki-vagrant
# $ ./setup.sh
# $ vagrant up
# $ sudo nano /etc/hosts <<<TEXT
#
# # For offline use
# 127.0.0.1 dev.wiki.local.wmftest.net
#
# TEXT;
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
# - coconutBattery
# - Firefox
# - FirefoxAurora
# - Flux
# - Google Chrome
# - Google Chrome Canary
# - ImageOptim
# - LimeChat
# - MySQLWorkbench
# - OpenOffice
# - Opera
# - Safari Technology Preview
# - Sequel Pro
# - Sublime Text 3
# - Vagrant
# - VirtualBox
# - VLC
# Misc:
# - Network Link Conditioner
#    http://nshipster.com/network-link-conditioner/
#    https://developer.apple.com/download/more/?q=Additional%20Tools
#    pgk/Hardware/Network Link Conditioner.prefPane
#
## Sublime Text 3
# Plugins:
# - https://packagecontrol.io/installation
# - DocBlockr
# - LESS
# - Puppet
# - SublimeLinter
# - SublimeLinter-jscs
# - SublimeLinter-jshint
# - Theme Soda
# - TrailingSpaces
#
