#
# Terminal
#

# Bins: Sublime Text 2
export PATH="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin:$PATH"

# Bins: Homebrew, npm, and others
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's gem packages (e.g. jsduck)
# http://stackoverflow.com/a/14138490/319266
export PATH=$(cd $(which gem)/..; pwd):$PATH

# Bins: Homebrew's pear/pecl packages (e.g. phpunit)
export PATH=$(cd $(which php)/..; pwd):$PATH

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
# $ brew install ack
# $ brew install git // Git 1.8 or higher
# $ brew install node // nodejs 0.8 or higher, inludes npm
# $ brew install ruby // Ruby 1.9 or higher, includes gem, rake etc.
# $ brew install bash-completion // for git, ssh, etc.
# $ brew tap josegonzalez/homebrew-php
# $ brew install php54
# $ mkdir /usr/local/etc/php/5.4/conf.d
# $ npm install -g jshint
# $ npm install -g grunt-cli
# $ gem install jsduck
## Set up PHPUnit
# $ sudo pear channel-discover pear.phpunit.de
# $ sudo pear channel-discover pear.symfony.com
# $ sudo pear upgrade-all
# $ sudo pear install --alldeps phpunit/phpunit

#
# Misc.
#

## Sublime Text 2
## http://www.sublimetext.com/2
## http://wbond.net/sublime_packages/package_control
## https://github.com/buymeasoda/soda-theme/
## "color_scheme": "Packages/Color Scheme - Default/LAZY.tmTheme",
## "theme": "Soda Light.sublime-theme",


## Apache
## Enable:
## For now I prefer just using the Apache install that
## ships with Mac OS X. To enable it (if not already)
## go to System Preferences > Network > [x] Web Sharing.
## Configuration:
# $ sudo vim /etc/apache2/httpd.conf
## Include /etc/apache2/other/*.conf unconditionally
# --- <IfDefine ...>
# ---     Include /etc/apache2/other/*.conf
# +++ Include /etc/apache2/other/*.conf
# --- </IfDefine>
# $ sudo apachectl restart

## Terminal
## Ubuntu sometimes thinks the Mac Terminal doesn't support colors
## (base on through $TERM and /usr/bin/tput)
## Default $TERM in Apple's Terminal.app: xterm-256color
## Change this to (in Terminal.app Preferences): rxvt

## DNSmasq
## Local DNS service for wildcard domains.
## (since /etc/hosts doesn't support wildard domains)
# $ brew install dnsmasq
## Follow instructions by brew-install, especially:
## Editing or alias /usr/local/etc/dnsmasq.conf
## $ sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

#
# No longer used, kept for future reference:
#

## MySQL
## mysql.sock location moved
# $ sudo mkdir /var/mysql -p
# $ sudo ln -s /tmp/mysql.sock /var/mysql/mysql.sock

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
