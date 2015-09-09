#
# Terminal
#

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's gem packages (e.g. jsduck)
# http://stackoverflow.com/a/14138490/319266
export PATH=/usr/local/opt/ruby20/bin:$PATH

# Bins: Homebrew's pear/pecl packages (e.g. phpunit)
export PATH=/usr/local/opt/php56/bin:$PATH

# Bins: Homebrew's coreutils (e.g. realpath)
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# Bins: Sublime Text (subl)
export PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH

# Bins: Tmp installs
export PATH=$KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/bin:$PATH

# MediaWiki
export MW_INSTALL_PATH="/Users/krinkle/Development/mediawiki/core"
export MW_DB="alphawiki"
export MW_SERVER="http://alpha.wikipedia.krinkle.dev"
export MW_SCRIPT_PATH="/w"

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion

[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh

__git_complete g _git
__git_complete gi _git
__git_complete gir _git
__git_complete got _git
__git_complete gt _git
__git_complete qgit _git
