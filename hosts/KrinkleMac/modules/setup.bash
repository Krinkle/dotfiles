#
# Terminal
#

# Bins: Command Line Tools for Xcode
export PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:$PATH

# Bins: Sublime Text 2
export PATH="/Applications/Sublime Text 2.app/Contents/SharedSupport/bin:$PATH"

# Bins: Homebrew, npm, and others
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

# Bins: Ruby Gems (via Homebrew)
# http://stackoverflow.com/a/14138490/319266
export PATH=$(cd $(which gem)/..; pwd):$PATH

# Fix gem/ruby errors about "unable to convert U+3002 from UTF-8 to US-ASCII for lib/shortener.rb, skipping"
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8
unset LC_ALL

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion


#
# Install
#

## Set up Homebrew
## http://mxcl.github.com/homebrew/
## Then:
# $ brew install git // 1.8+
# $ brew install node // 0.8+, also: npm
# $ brew install ruby // 1.9+, also: gem, rake etc.
# $ brew install bash-completion
# $ npm install -g jshint
# $ npm install -g grunt-cli
# $ gem install jsduck

## Set up PEAR, PECL
## http://akrabat.com/php/setting-up-php-mysql-on-os-x-10-7-lion/
# $ cd /usr/lib/php
# $ sudo php install-pear-nozlib.phar
# # See php.ini
# $ sudo pear channel-update pear.php.net
# $ sudo pecl channel-update pecl.php.net
# $ sudo pear upgrade-all
#
# PECL also needs autoconf
# $ brew install autoconf
# $ brew install re2c
## Then:
# $ sudo pear channel-discover pear.phpunit.de
# $ sudo pear channel-discover components.ez.no
# $ sudo pear channel-discover pear.symfony-project.com
# $ sudo pear install phpunit/PHPUnit
# $ sudo pear install phpunit/phpcpd
# $ sudo pear install PHP_CodeSniffer

## xdiff // 1.5.1+
# xdiff (through pecl) needs these:
# $ brew install re2c
# $ brew install libxdiff
# At this moment 1.4.1 is latest stable, so use beta
# See http://pecl.php.net/package/xdiff
# $ sudo pecl install xdiff
# $ sudo pecl upgrade xdiff-beta

## Travis CI
## http://about.travis-ci.org/docs/user/getting-started/
# $ sudo gem install travis-lint


#
# Misc.
#

## As of Lion, php5_module is no longer enabled by default
## in Apache.
# $ sudo vim
# --- #LoadModule php5_module libexec/apache2/libphp5.so
# +++ LoadModule php5_module libexec/apache2/libphp5.so
# $ sudo apachectl restart

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

## Ubuntu sometimes thinks the Mac Terminal doesn't support colors
## (through TERM and /usr/bin/tput)
## Default TERM in Apple's Terminal.app: xterm-256color
## Changed to (in Preferences): rxvt

## Basic local DNS service for wildcard *.foo.dev domains
## (since /etc/hosts doesn't support wildard domains)
# $ brew uninstall dnsmasq
## After editing dnsmasq.conf, reload deamon:
# $ sudo launchctl unload -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
# $ sudo launchctl load -w /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
# $ dscacheutil -flushcache
