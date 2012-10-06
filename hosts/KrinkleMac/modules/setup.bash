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

## xdiff
# xdiff (through pecl) needs these:
# $ brew install re2c
# $ brew install libxdiff
# $ sudo pecl install xdiff
