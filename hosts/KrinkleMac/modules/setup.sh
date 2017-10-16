#
# Terminal
#

# Bins: Homebrew and manually installed programs
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Bins: Homebrew's gem packages (e.g. jsduck)
# http://stackoverflow.com/a/14138490/319266
export PATH=/usr/local/lib/ruby/gems/2.4.0/bin:$PATH

# Bins: Homebrew's coreutils (e.g. realpath)
export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH

# Bins: Sublime Text (subl)
export PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH

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

# Phabricator Arcanist
source /Users/krinkle/Development/wikimedia/arcanist/resources/shell/bash-completion

[[ -s /usr/local/etc/profile.d/autojump.sh ]] && . /usr/local/etc/profile.d/autojump.sh

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
