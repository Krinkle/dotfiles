#
# Terminal
#

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's npm packages (e.g. jshint)
export PATH=/usr/local/share/npm/bin:$PATH
# They're put in /usr/local/bin as of node 0.10, disable when upgrading to node 0.10+

# Bins: Homebrew's gem packages (e.g. jsduck)
# http://stackoverflow.com/a/14138490/319266
export PATH=$(brew --prefix ruby)/bin:$PATH

# Bins: Homebrew's pear/pecl packages (e.g. phpunit)
export PATH=$(brew --prefix php54)/bin:$PATH

# Bins: Sublime Text 2 (subl)
export PATH=/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin:$PATH

# Fix gem/ruby errors about "unable to convert U+3002 from UTF-8 to US-ASCII for lib/shortener.rb, skipping"
export LC_CTYPE="en_US.UTF-8"
export LANG="en_US.UTF-8"
unset LC_ALL

export MW_INSTALL_PATH="/Users/krinkle/Development/mediawiki/core"
export MW_DB="betawiki"

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion

