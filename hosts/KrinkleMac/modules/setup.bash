#
# Terminal
#

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's npm packages (e.g. jshint)
export PATH=/usr/local/share/npm/bin:$PATH

# Bins: Homebrew's gem packages (e.g. jsduck)
# http://stackoverflow.com/a/14138490/319266
if [ -x /usr/local/bin/gem ]; then
	export PATH=$(cd /usr/local/bin/gem/..; pwd):$PATH
fi

# Bins: Homebrew's pear/pecl packages (e.g. phpunit)
# Only if installed in local, else it would destroy PATH by putting /usr/bin in front
if [ -x /usr/local/bin/pear ]; then
	export PATH=$(cd /usr/local/bin/pear/..; pwd):$PATH
fi

# Fix gem/ruby errors about "unable to convert U+3002 from UTF-8 to US-ASCII for lib/shortener.rb, skipping"
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
unset LC_ALL

export MW_INSTALL_PATH='/Users/krinkle/Development/mediawiki/core'
export MW_DB='betawiki'

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion


#
# Installation (Terminal / Environment)
#

## Set up "Command Line Tools for Xcode" (without Xcode)
## This provides 'make' among other things, required by Homebrew.
## http://connect.apple.com

## Set up Homebrew
## http://mxcl.github.com/homebrew/
# $ brew doctor
# $ brew tap homebrew/dupes && brew tap josegonzalez/homebrew-php

## Git
# $ brew install git
# $ cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/gitconfig ~/.gitconfig

## SSH Key
## https://help.github.com/articles/generating-ssh-keys
# cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/sshconfig ~/.ssh/config
## Generate different keys (for GitHub, Wikimedia Labs LDAP, Toolserver etc.)
## and submit them to those organisations.
# cd ~/.krinkle.dotfiles; git remote rm origin; git remote add origin git@...; git pull origin master -u

## Apache
# $ brew install httpd
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

## PHP
# $ brew install php54
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
# $ brew install mysql
# Caveat: mysql_install_db and load
# Ignore rest of caveat, mysql_install_db command gives command
# for mysql_secure_installation wizard. Use that instead. 

## phpMyAdmin
# $ brew install phpmyadmin

## Misc
# $ brew install node ruby // Includes npm, gem, rake
# $ brew install phantomjs ack bash-completion
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
