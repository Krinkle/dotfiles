#
# Terminal
#

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's ruby
export PATH=/usr/local/opt/ruby/bin:$PATH

# Bins: Homebrew's coreutils (e.g. realpath)
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# Bins: Homebrew's PHP
export PATH=/usr/local/opt/php@7.1/bin:$PATH

# Bins: Sublime Text (subl)
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

# Bins: Composer global
export PATH=$HOME/.composer/vendor/bin:$PATH

# Bins: Misc dotfiles utilities
export PATH=$KDF_BASE_DIR/hosts/$KDF_HOST_TYPE/bin:$PATH

# Bins: Git contrib: diff-highlight
export PATH=/usr/local/opt/git/share/git-core/contrib/diff-highlight:$PATH

# Bins: Jenkins Job Builder
# http://docs.openstack.org/infra/jenkins-job-builder/installation.html
# https://www.mediawiki.org/wiki/Continuous_integration/Jenkins_job_builder
alias jenkins-jobs=/Users/krinkle/Development/wikimedia/integration/jenkins-job-builder/.venv/bin/jenkins-jobs

# Local etc (symlinked to data of `brew install bash-completion`)
source /usr/local/etc/bash_completion

[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh

__git_complete g _git
__git_complete gi _git
__git_complete gir _git

#
# GnuPG
#
export GPG_TTY=$(tty)

#
# MediaWiki
#

export MW_SERVER='http://default.web.mw.localhost:8080'
export MW_SCRIPT_PATH='/mediawiki'
export MEDIAWIKI_USER='Admin'
export MEDIAWIKI_PASSWORD='adminpass'
