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

	echo "... ensure of Homebrew packages"
	brew tap homebrew/dupes
	brew tap homebrew/versions
	brew tap homebrew/homebrew-php
	formulas=(
		ack
		autojump
		bash
		bash-completion
		colordiff
		coreutils
		git
		hh
		jq
		mysql
		node
		phantomjs
		php56
		phpmyadmin
		pwgen
		#ruby: JSDuck 5.3.4 has issues with Ruby 2.1.2
		ruby20
		watch
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
	brew cleanup

	echo "... ensure npm packages"
	npm install -g grunt-cli jshint jscs

	echo "... ensure RubyGems packages"
	gem install jsduck

	echo "... ensure pip packages"
	sudo easy_install pip
	sudo pip install -U setuptools # http://stackoverflow.com/a/26259756/319266 - always good, though added for OS X <= 10.7
	sudo pip install git-review

	echo "... post-install: php"
	mkdir /usr/local/etc/php/5.6/conf.d
	sudo chmod 777 /var/log/php
	sudo chmod 777 /var/lib/php5
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


	# echo "... checking dev directory tree"
	# ~/Development
	# ~/Development/tmp
	# $ git clone ssh://gerrit.wikimedia.org:29418/SRC
	# ~/Development/mediawiki/core
	# ~/Development/mediawiki/skins/ Vector
	# ~/Development/mediawiki/extensions/
	# ~/Development/oojs
	# ~/Development/oojs-ui
	# ~/Development/unicodejs
	# ~/Development/wikimedia
	# ~/Development/wikimedia/integration/ config, jenkins-job-builder, docroot
	# ~/Development/wikimedia/operations/ mediawiki-config, puppet
}

_dotfiles-host-init

source $KDF_BASE_DIR/index.bash

#
# SSH Key
#
# https://help.github.com/articles/generating-ssh-keys
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
#
# Generate different keys (for GitHub, Wikimedia Labs LDAP etc.)
# and submit them to those organisations.
# $ cd $KDF_BASE_DIR
# $ git remote rm origin
# $ git remote add origin git@...
# $ git pull origin master -u


#
# Terminal
#
# On "Ubuntu 12.04.2 LTS" (.wmnet) tput gives 'tput: unknown terminal "screen.rxvt"'
#
# Preferences > Advanced > Emulation > Declare as: xterm

#
# Sytem
#
# Preferences > Mission Control
# * Closing an app can refocus an app in a different space
#   http://apple.stackexchange.com/a/44801
#   [_] When switching to an application, switch to a space with open windows for the application


#
# Apache
#
# $ brew install homebrew/apache/httpd24
#
# Disable built-in httpd from Mountain Lion
# $ sudo /usr/sbin/apachectl stop
# $ sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
# $ sudo launchctl remove org.apache.httpd.plist
#
# Add httpd from Homebrew to launchctl and start it (follow Caveats from brew-install).
# $ sudo ln -s /usr/local/var/log/apache2 /var/log/httpd
#
# $ mkdir /usr/local/etc/apache2/2.4/other
# $ echo 'Include /usr/local/etc/apache2/2.4/other/*.conf' >> /usr/local/etc/apache2/2.4/httpd.conf
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/apache2/2.4/other/krinkle.conf
#
# Change Listen 8080 to 80. Out config already adds Listen 80, but the point here
# is to free up port 8080 for other applications.
# $ sudo edit /usr/local/etc/apache2/2.4/httpd.conf
#
# $ doapachereset
#
# $ sudo nano /etc/hosts <<<TEXT
#
# 127.0.0.1 krinkle.dev
# 127.0.0.1 krinkle.com
# 127.0.0.1 example.dev
# 127.0.0.1 drive.krinkle.dev
# 127.0.0.1 wiki.krinkle.dev
# 127.0.0.1 wikipedia.krinkle.dev
# 127.0.0.1 alpha.wikipedia.krinkle.dev
# 127.0.0.1 beta.wikipedia.krinkle.dev
#
# # MediaWiki-Vagrant
# 10.11.12.13 mediawiki.dev
#
# TEXT;

#
# MySQL
#
# (brew-install)
# $ mysqladmin -u root password

#
# MediaWiki
#
# Install
# $ chmod 777 ~/Development/mediawiki/core/cache
#
# Configure
# $ sudo mkdir /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki
# $ ln -s /var/log/mediawiki /var/log/httpd/mw
# $ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/mw-CommonSettings.php ~/Development/mediawiki/core/CommonSettings.php
# $ edit ~/Development/mediawiki/core/.git/info/exclude # Add CommonSettings.php
# $ cp $KDF_BASE_DIR/hosts/KrinkleMac/templates/mw-LocalSettings.php ~/Development/mediawiki/core/LocalSettings.php
#
# Database:
# $ open 'http://localhost/phpmyadmin'
# Create alphawiki, betawiki
# $ php .../mediawiki/core/maintenance/install.php ... alphawiki ...
# $ php .../mediawiki/core/maintenance/install.php ... betawiki ...

#
# MediaWiki-Vagrant
#
# Configure
# $ cd ~/Development/mediawiki/vagrant/puppet/hieradata
# $ ln $KDF_BASE_DIR/hosts/KrinkleMac/mediawiki-vagrant.yaml vagrant-managed.yaml

#
# GUI Applications
#
## Applications
# Install via App Store:
# - Aperture
# - CloudApp
# - Simplenote
# - The Unarchiver
# - Wunderlist
# Install:
# - coconutBattery
# - Firefox
# - FirefoxAurora
# - Google Chrome
# - Google Chrome Canary
# - Image Optim
# - LimeChat
# - MySQLWorkbench
# - OpenOffice
# - Opera
# - Sequel Pro
# - Sublime Text 3
# - VLC
#
## Sublime Text 3
# Plugins:
# - https://packagecontrol.io/installation
# - DocBlockr
# - LESS
# - SublimeLinter
# - SublimeLinter-jscs
# - SublimeLinter-jshint
# - Theme Soda
# - TrailingSpaces
# - rsub
#
## rsub
# - http://www.danieldemmel.me/blog/2012/09/02/setting-up-rmate-with-sublime-text-for-remote-file-editing-over-ssh/
# - http://pogidude.com/2013/how-to-edit-a-remote-file-over-ssh-using-sublime-text-and-rmate/
# - http://aurora.github.io/rmate/
#
# 1. Install rsub in Sublime Text 3 via Package Control
# 2. Add `RemoteForward 52698 localhost:52698` to a host in sshconfig
# 3. On remote server, install command rmate:
#    curl https://raw.githubusercontent.com/aurora/rmate/ea116b5ef619cb8/rmate > ~/bin/rmate
#
# To edit:
# 1. ssh example.org
# 2. rmate foo.txt
#    (sends signal over tunnel to plugin in sublime)
# 3. File opens in local editor and saves back through the tunnel
#    when you save as usual!
#
### LimeChat
## Plugins:
## - https://github.com/Krinkle/limechat-theme-colloquy
#

#
# Bash programs
#
# - dotcs-hangouts-log-reader
#
