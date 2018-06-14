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
	brew upgrade php@7.1 || brew install php@7.1
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
	test -f /usr/local/etc/php/7.1/conf.d/krinkle.ini || ( echo "linking php.ini" && ln -s $KDF_BASE_DIR/hosts/KrinkleMac/php.ini /usr/local/etc/php/7.1/conf.d/krinkle.ini )

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
