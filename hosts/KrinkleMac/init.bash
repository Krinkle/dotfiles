#!/usr/bin/env bash

source $KDF_BASE_DIR/modules/functions.sh

function _dotfiles-host-init() {

	# Homwbrew
	echo "... checking Homebrew"
	if [ -z "$(which brew)" ]
	then
		echo "$CLR_RED>> ERROR$CLR_NONE: Install Homebrew first"
		open http://mxcl.github.io/homebrew/
		exit 1
	fi

	echo "... updating Homebrew"
	brew update
	echo "... exec 'brew doctor'"
	brew doctor
	if [[ $? != 0 ]]
	then
		ret=$(_dotfiles-prompt-choice "Check out those warnings. Continue?")
		if [[ -z ret ]]
		then
			exit 1
		fi
	fi

	echo "... ensuring presence of packages"
	brew tap homebrew/dupes
	brew tap josegonzalez/homebrew-php
	formulas="git php54 mysql phpmyadmin node ruby phantomjs ack bash-completion wget"
	for f in $formulas; do
		brew upgrade $f || brew install $f
		if [[ $? != 0 ]]
		then
			echo "$(tput setaf 1)>> ERROR$(tput sgr0): Problems installing package '$f'"
			exit 1
		fi
	done
	# cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/gitconfig ~/.gitconfig
}

_dotfiles-host-init

#
# Installation (Terminal / Environment)
#
#

## SSH Key
## https://help.github.com/articles/generating-ssh-keys
# cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
## Generate different keys (for GitHub, Wikimedia Labs LDAP, Toolserver etc.)
## and submit them to those organisations.
# cd ~/.krinkle.dotfiles; git remote rm origin; git remote add origin git@...; git pull origin master -u

## Apache
# $ brew install httpd # Be careful, /etc/ is not preserved through upgrades
### https://github.com/Homebrew/homebrew-dupes/issues/119
# $ mkdir /usr/local/opt/httpd/var/apache2/log
# $ mkdir /usr/local/opt/httpd/var/apache2/run
## Disable built-in httpd from Mountain Lion
# $ sudo /usr/sbin/apachectl stop
# $ sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
# $ sudo launchctl remove org.apache.httpd.plist
## Add httpd from Homebrew to launchctl (https://github.com/Homebrew/homebrew-dupes/issues/140)
# $ edit /user/local/opt/httpd/homebrew.mxcl.httpd.plist `https://github.com/Homebrew/homebrew-dupes/blob/master/httpd.rb#startup_plist`
# $ sudo chown root /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo chmod 644 /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo launchctl load -w /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo /usr/local/sbin/apachectl restart
# $ sudo ln -s /usr/local/opt/httpd/var/apache2/log /var/log/httpd

## PHP
# $ mkdir /usr/local/etc/php/5.4/conf.d
# $ sudo mkdir -p /var/log/php && sudo chmod 777 /var/log/php
# $ sudo mkdir -p /var/php && sudo chmod 777 /var/php
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/php.ini /usr/local/etc/php/5.4/conf.d/krinkle.ini

## Apache
## (continued, after PHP)
# $ mkdir /usr/local/opt/httpd/etc/apache2/other
# $ echo 'Include etc/apache2/other/*.conf' >> /usr/local/opt/httpd/etc/apache2/httpd.conf
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/httpd.conf /usr/local/opt/httpd/etc/apache2/other/krinkle.conf

## MySQL
# Caveat: mysql_install_db and load
# Ignore rest of caveat, mysql_install_db command gives command
# for mysql_secure_installation wizard. Use that instead.

## Misc
# $ npm install -g jshint
# $ npm install -g grunt-cli
# $ gem install jsduck

## PHPUnit
# $ sudo pear channel-discover pear.phpunit.de
# $ sudo pear channel-discover pear.symfony.com
# $ sudo pear upgrade-all
# $ sudo pear install --alldeps phpunit/phpunit

## MediaWiki
## Install
# $ mkdir ~/Development
# $ git clone ssh://krinkle@gerrit.wikimedia.org:29418/mediawiki/core.git ~/Development/mediawiki/core
# $ chmod 777 ~/Development/mediawiki/core/cache
# $ git clone ssh://krinkle@gerrit.wikimedia.org:29418/mediawiki/extensions.git ~/Development/mediawiki/extensions
## Configure
# $ sudo mkdir /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/mw-CommonSettings.php ~/Development/mediawiki/core/CommonSettings.php
# $ edit ~/Development/mediawiki/core/.git/info/exclude # Add CommonSettings.php
# $ cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/mw-LocalSettings.php ~/Development/mediawiki/core/LocalSettings.php

## DNSmasq: Local DNS service (as /etc/hosts doesn't support wildards)
# $ brew install dnsmasq
## Follow instructions by brew-install. Be sure to symlink conf file before loading
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/dnsmasq.conf /usr/local/etc/dnsmasq.conf
# Network Preferences -> DNS: [127.0.0.1, 8.8.8.8, 8.8.8.4] # Local DNSmasq, then Google DNS


#
# Installation (GUI)
#

## Sublime Text 2
## http://www.sublimetext.com/2
## http://wbond.net/sublime_packages/package_control
## Install Package:
## - SublimeLinter,
## - DocBlockr
## - Soda Theme
## Preferences:
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/SublimePreferences.json ~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User/Preferences.sublime-settings

## LimeChat
## http://limechat.net/mac/
## https://github.com/Krinkle/limechat-theme-colloquy

## Terminal
## When connecting over SSH, Linux sometimes thinks the Mac Terminal doesn't
## support colors (base on through $TERM and /usr/bin/tput)
## Default $TERM in Apple's Terminal.app: xterm-256color
## Change this (in Terminal.app's Preferences) to: rxvt


#
# Archive
#

## Setting up tunnels in BrowserStack needs Java.
## Somehow it stopped working with Java 6, so install Java 7.
## But Java 7 doesn't go well with Google Chrome, so execute the following
## to disable Java 7 and re-enable the Apple-provided Java 6.
## I have no idea why it works with this, since why wouldn't it work before
## installing Java 7 with "just" Java 6.
## (which should be similar to installing 7, disabling it and re-enabling 6)
## http://support.apple.com/kb/HT5559
# $ sudo mkdir -p /Library/Internet\ Plug-Ins/disabled
# $ sudo mv /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin /Library/Internet\ Plug-Ins/disabled
# $ sudo ln -sf /System/Library/Java/Support/Deploy.bundle/Contents/Resources/JavaPlugin2_NPAPI.plugin /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
# $ sudo ln -sf /System/Library/Frameworks/JavaVM.framework/Commands/javaws /usr/bin/javaws

