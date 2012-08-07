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
