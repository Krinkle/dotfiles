#!/usr/bin/env bash

source $KDF_BASE_DIR/modules/functions.sh

function _dotfiles-host-init {

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
		bash
		bash-completion
		colordiff
		dnsmasq
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

	echo "... Post-install for package: dnsmaq"
	test -f /usr/local/etc/dnsmasq.conf || ( echo "linking dnsmasq.conf" && ln -s $KDF_BASE_DIR/hosts/KrinkleMac/dnsmasq.conf /usr/local/etc/dnsmasq.conf )

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


	#echo "... checking dev directory tree"
	# ~/Development
	# ~/Development/Krinkle
	# ~/Development/mediawiki/core
	# ~/Development/mediawiki/extensions
	# ~/Development/wikimedia
	# ~/Development/wikimedia/integration/j, jjb, jjb-config, zuul, zuul-config, docroots
	# ~/Development/wikimedia/operations/ mw-config, apache-config, puppet
	# ~/Development/jquery/jquery, qunit, testswarm, qunit-*, *qunitjs.com
	# ~/Development/countervandalism
}

_dotfiles-host-init

source $KDF_BASE_DIR/index.bash

#
# Manual steps for Terminal workspace
#

## SSH Key
## https://help.github.com/articles/generating-ssh-keys
# cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
## Generate different keys (for GitHub, Wikimedia Labs LDAP, Toolserver etc.)
## and submit them to those organisations.
# cd $KDF_BASE_DIR; git remote rm origin; git remote add origin git@...; git pull origin master -u

## Apache
# $ brew install httpd # Be careful, /etc/ is not preserved through upgrades
## Disable built-in httpd from Mountain Lion
# $ sudo /usr/sbin/apachectl stop
# $ sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
# $ sudo launchctl remove org.apache.httpd.plist
## Add httpd from Homebrew to launchctl (https://github.com/Homebrew/homebrew-dupes/issues/140)
# $ edit /usr/local/opt/httpd/homebrew.dupes.httpd.plist `https://github.com/Homebrew/homebrew-dupes/blob/master/httpd.rb#startup_plist`
# $ sudo chown root /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo chmod 644 /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo launchctl load -w /usr/local/opt/httpd/homebrew.mxcl.httpd.plist
# $ sudo apachectl restart
# $ sudo ln -s /usr/local/var/apache2/log /var/log/httpd
#
# $ mkdir /usr/local/etc/apache2/other
# $ echo 'Include /usr/local/etc/apache2/other/*.conf' >> /usr/local/etc/apache2/httpd.conf
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/apache2/other/krinkle.conf

## MySQL
# Caveat: mysql_install_db and load
# Ignore rest of caveat, mysql_install_db command gives command
# for mysql_secure_installation wizard. Use that instead.

## DNSmasq
# Local DNS service (as /etc/hosts doesn't support wildards)
# Mac OS X System Preferences > Network > DNS: [127.0.0.1, 8.8.8.8, 8.8.8.4] # Prepend local DNSmasq

## MediaWiki
## Install
# $ mkdir ~/Development
# $ git clone ssh://krinkle@gerrit.wikimedia.org:29418/mediawiki/core.git ~/Development/mediawiki/core
# $ chmod 777 ~/Development/mediawiki/core/cache
# $ git clone ssh://krinkle@gerrit.wikimedia.org:29418/mediawiki/extensions.git ~/Development/mediawiki/extensions
## Configure
# $ sudo mkdir /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki
# $ ln -s /usr/log/mediawiki /var/log/httpd/mw
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/mw-CommonSettings.php ~/Development/mediawiki/core/CommonSettings.php
# $ edit ~/Development/mediawiki/core/.git/info/exclude # Add CommonSettings.php
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/mw-LocalSettings.php ~/Development/mediawiki/core/LocalSettings.php
# brew install lua5.1

## Mac OS X
# $ sudo defaults read /Library/Preferences/com.apple.TimeMachine SkipSystemFiles

#
# Manual steps for GUI
#

## Sublime Text 2
## http://www.sublimetext.com/2
## http://wbond.net/sublime_packages/package_control
## Install Package:
## - SublimeLinter,
## - DocBlockr
## - Soda Theme
## Preferences:

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

