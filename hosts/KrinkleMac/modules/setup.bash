#
# Terminal
#

# Bins from Apple Developer Tools (Xcode)
export PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:$PATH

# Bins from git-osx-installer
export PATH=/usr/local/git/bin:$PATH

# Bins from me, npm -g or Homebrew
export PATH=/usr/local/bin:$PATH


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


## Set up PEAR, PECL
## http://akrabat.com/php/setting-up-php-mysql-on-os-x-10-7-lion/
# $ cd /usr/lib/php
# $ sudo php install-pear-nozlib.phar
# # See php.ini
# $ sudo pear channel-update pear.php.net
# $ sudo pecl channel-update pecl.php.net
# $ sudo pear upgrade-all
#
# PHPUnit:
# $ sudo pear channel-discover pear.phpunit.de
# $ sudo pear channel-discover components.ez.no
# $ sudo pear channel-discover pear.symfony-project.com
# $ sudo pear install phpunit/PHPUnit
# $ sudo pear install phpunit/phpcpd
# $ sudo pear install PHP_CodeSniffer
#
# PECL also needs autoconf
# $ brew install autoconf
# $ brew install re2c

## xdiff (at least 1.5.1)
# xdiff (through pecl) needs these:
# $ brew install re2c
# $ brew install libxdiff
# At this moment 1.4.1 is latest stable, so use beta
# See http://pecl.php.net/package/xdiff
# $ sudo pecl install xdiff
# $ sudo pecl upgrade xdiff-beta

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
