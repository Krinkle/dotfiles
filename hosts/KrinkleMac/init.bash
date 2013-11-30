#!/usr/bin/env bash

source $KDF_BASE_DIR/modules/functions.sh

function _dotfiles-host-init {

	# Homwbrew
	echo "... checking Homebrew"
	if [ -z "$(which brew)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Homebrew first"
		open http://brew.sh
		exit 1
	fi

	echo "... updating Homebrew"
	brew update
	echo "... exec 'brew doctor'"
	brew doctor
	if [[ $? != 0 ]]
	then
		if ! _dotfiles-prompt-choice "Check out those warnings. Continue?"; then
			exit 2
		fi
	fi

	echo "... ensuring presence of Homebrew packages"
	brew tap homebrew/dupes
	brew tap homebrew/versions
	brew tap josegonzalez/homebrew-php
	formulas=(
		ack
		autojump
		bash
		bash-completion
		colordiff
		git
		jq
		mysql
		node
		phantomjs
		php54
		phpmyadmin
		ruby
		wget
	)
	for f in "${formulas[@]}"; do
		brew upgrade $f || brew install $f
		if [[ $? != 0 ]]
		then
			echo "$CLR_RED>> ERROR$CLR_NONE: Problems installing package '$f'"
			exit 1
		fi
	done

	echo "... ensuring presence of NPM packages"
	npm install -g jshint grunt-cli bower csslint

	echo "... ensuring presence of RubyGems packages"
	gem install jsduck --version '= 4.10.4'

	echo "... updating PEAR"
	sudo pear channel-discover pear.phpunit.de
	sudo pear channel-discover pear.symfony.com
	sudo pear upgrade-all
	echo "... ensuring presence of PEAR packages"
	sudo pear install --alldeps phpunit/phpunit

	echo "... Post-install for package: php"
	mkdir -p /usr/local/etc/php/5.4/conf.d
	sudo mkdir -p /var/log/php && sudo chmod 777 /var/log/php
	sudo mkdir -p /var/lib/php5 && sudo chmod 777 /var/lib/php5
	test -f /usr/local/etc/php/5.4/conf.d/krinkle.ini || ( echo "linking php.ini" && ln -s $KDF_BASE_DIR/hosts/KrinkleMac/php.ini /usr/local/etc/php/5.4/conf.d/krinkle.ini )

	echo "... Post-install for package: git"
	# Only change if not a symlink, or a symlink to the wrong place
	tmpPath=~/.gitconfig
	tmpDest=$KDF_BASE_DIR/hosts/KrinkleMac/templates/gitconfig
	if [[ ! -L $tmpPath || "$(readlink $tmpPath)" != $tmpDest ]]
	then
		test ! -f $tmpPath || rm $tmpPath
		echo "linking .gitconfig"
		ln -s $tmpDest $tmpPath
	fi

	echo "... checking Sublime Text 2"
	if [ -z "$(which subl)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Sublime Text 2"
		open http://www.sublimetext.com/2
		exit 1
	fi

	echo "... Post-install for application: Sublime Text 2"
	tmpPath=~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/Preferences.sublime-settings
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


	# echo "... checking dev directory tree"
	# ~/Development
	# ~/Development/Krinkle
	# ~/Development/mediawiki/core
	# ~/Development/mediawiki/extensions
	# ~/Development/wikimedia
	# ~/Development/wikimedia/integration/j, jjb, jjb-config, zuul-config, docroot
	# ~/Development/wikimedia/operations/ mediawiki-config, puppet
	# ~/Development/jquery/jquery, qunit, testswarm
}

_dotfiles-host-init

source $KDF_BASE_DIR/index.bash

#
# SSH Key
#
# https://help.github.com/articles/generating-ssh-keys
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
#
# Generate different keys (for GitHub, Wikimedia Labs LDAP, Toolserver etc.)
# and submit them to those organisations.
# $ cd $KDF_BASE_DIR
# $ git remote rm origin
# $ git remote add origin git@...
# $ git pull origin master -u

#
# Apache
#
# $ brew install httpd # Be careful, /etc/ is not preserved through upgrades
#
# Disable built-in httpd from Mountain Lion
# $ sudo /usr/sbin/apachectl stop
# $ sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
# $ sudo launchctl remove org.apache.httpd.plist
#
# Add httpd from Homebrew to launchctl and start it (follow Caveats from brew-install).
# $ sudo ln -s /usr/local/var/apache2/log /var/log/httpd
#
# $ mkdir /usr/local/etc/apache2/other
# $ echo 'Include /usr/local/etc/apache2/other/*.conf' >> /usr/local/etc/apache2/httpd.conf
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/apache2/other/krinkle.conf
# $ doapachereset
#
# $ sudo nano /etc/hosts <<<TEXT
#
# 127.0.0.1 krinkle.dev
# 127.0.0.1 wikipedia.dev
# 127.0.0.1 alpha.wikipedia.krinkle.dev
# 127.0.0.1 beta.wikipedia.krinkle.dev
#
# TEXT;

#
# MySQL
#
# (brew-install)
# $ mysqladmin -u root password *******

#
# MediaWiki
#
# Install
# $ mkdir ~/Development
# $ git clone gerrit.wikimedia/mediawiki/core.git ~/Development/mediawiki/core
# $ chmod 777 ~/Development/mediawiki/core/cache
# $ git clone gerrit.wikimedia/mediawiki/extensions.git ~/Development/mediawiki/extensions
#
# Configure
# $ sudo mkdir /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki
# $ ln -s /var/log/mediawiki /var/log/httpd/mw
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/mw-CommonSettings.php ~/Development/mediawiki/core/CommonSettings.php
# $ edit ~/Development/mediawiki/core/.git/info/exclude # Add CommonSettings.php
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/mw-LocalSettings.php ~/Development/mediawiki/core/LocalSettings.php
# $ brew install lua
#
# Database:
# $ open 'http://localhost/phpmyadmin'
# Create alphawiki, betawiki

#
# GUI Applications
#
## Applications
# Install:
# - Aperture
# - Cloud
# - coconutBattery
# - Firefox
# - FirefoxAurora
# - GarageBand
# - Google Chrome
# - Google Chrome Canary
# - Image Optim
# - Keynote
# - LimeChat
# - MySQLWorkbench
# - OpenOffice
# - Opera
# - Pages
# - Sequel Pro
# - Sublime Text 2
# - The Unarchiver
# - VirtualBox
# - VLC
# - Xcode
#
## Sublime Text 2
# Plugins:
# - http://wbond.net/sublime_packages/package_control
# - DocBlockr
# - LESS
# - Puppet
# - SublimeLinter
# - Theme Soda
# - TrailingSpaces
#
### LimeChat
## Plugins:
## - https://github.com/Krinkle/limechat-theme-colloquy
#
