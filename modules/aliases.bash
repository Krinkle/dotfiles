# Init global settings for certain bin
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    # Self-aliases to use color by default
    alias ls='ls --color=auto'
fi

# Shortcuts
alias ll='ls -ahlF'
alias l='ll'
alias gi='git'
# Size calculation
alias dsize='du -hs'

# Actions
alias dotfiles-pull='cd ~/.krinkle.dotfiles && git fetch origin && git reset --hard origin/master && cd -'
