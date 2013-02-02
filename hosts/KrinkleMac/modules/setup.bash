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

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion


#
# Install
#

## Set up "Command Line Toos for Xcode" (without Xcode)
## This provides 'make' among other things, required by Homebrew.
## https://developer.apple.com/downloads

## Set up Homebrew
## http://mxcl.github.com/homebrew/

## Packages:
# $ brew install git
# $ brew install node ruby // Includes npm, gem, rake
# $ brew install ack bash-completion
# $ brew tap homebrew/dupes && brew tap josegonzalez/homebrew-php
# $ brew install httpd mysql php54 phpmyadmin
# $ mkdir /usr/local/opt/httpd/var/apache2/log
# $ mkdir /usr/local/opt/httpd/var/apache2/run
# $ mkdir -p /usr/local/var/mysql # MySQL working directory
# $ mkdir /usr/local/etc/php/5.4/conf.d
# $ brew install zlib gettext # Needed for httpd/php54/libphp5.so
# $ npm install -g jshint
# $ npm install -g grunt-cli
# $ gem install jsduck
## Set up PHPUnit
# $ sudo pear channel-discover pear.phpunit.de
# $ sudo pear channel-discover pear.symfony.com
# $ sudo pear upgrade-all
# $ sudo pear install --alldeps phpunit/phpunit

#
# Web server
#

## MediaWiki
# $ mkdir ~/Developer
# $ git clone mediawiki/core.git ~/Developer/mediawiki/core
# $ git clone mediawiki/extensions.git ~/Developer/mediawiki/extensions
# $ sudo mkdir -p /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki

## DNSmasq: Local DNS service (as /etc/hosts doesn't support wildards)
# $ brew install dnsmasq
## Follow instructions by brew-install, especially: edit /usr/local/etc/dnsmasq.conf
## $ sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

## PHP
# $ sudo mkdir -p /var/log/php && sudo chmod 777 /var/log/php
# $ sudo mkdir -p /tmp/php54 && sudo chmod 777 /tmp/php54

## Apache conf loader
# $ mkdir /usr/local/opt/httpd/etc/apache2/other
# $ echo 'Include etc/apache2/other/*.conf' >> /usr/local/opt/httpd/etc/apache2/httpd.conf


#
# Dotfiles
#

# $ cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/gitconfig ~/.gitconfig
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/dnsmasq.conf /usr/local/etc/dnsmasq.conf
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/php.ini /usr/local/etc/php/5.4/conf.d/krinkle.ini
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/httpd.conf /usr/local/opt/httpd/etc/apache2/other/krinkle.conf

# $ mkdir ~/Development
# $ git clone mediawiki/core.git ~/Development/mediawiki/core
# $ chmod 777 ~/Development/mediawiki/core/cache
# $ git clone mediawiki/extensions.git ~/Development/mediawiki/extensions

# $ sudo mkdir /var/log/mediawiki && sudo chmod 777 /var/log/mediawiki
# $ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/mw-CommonSettings.php ~/Development/mediawiki/CommonSettings.php
# $ cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/mw-LocalSettings.php ~/Development/mediawiki/core/LocalSettings.php


#
# Misc.
#

## Sublime Text 2
## http://www.sublimetext.com/2
## http://wbond.net/sublime_packages/package_control
## https://github.com/buymeasoda/soda-theme/
## "color_scheme": "Packages/Color Scheme - Default/LAZY.tmTheme",
## "theme": "Soda Light.sublime-theme",

## Terminal
## Ubuntu sometimes thinks the Mac Terminal doesn't support colors
## (base on through $TERM and /usr/bin/tput)
## Default $TERM in Apple's Terminal.app: xterm-256color
## Change this to (in Terminal.app Preferences): rxvt


#
# No longer used, kept for future reference:
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
