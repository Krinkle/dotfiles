# Actions
alias docheckcommitmsg='cat ~/Documents/COMMIT.txt'
alias dosvncommit='svn commit -F ~/Documents/COMMIT.txt'
alias dogitcommit='git commit -F ~/Documents/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'
alias dotfiles-push='cd ~/.krinkle.dotfiles && git commit -a --amend -C HEAD && git push -f && cd -'

# http://ariejan.net/2011/11/08/fixing-a-slow-starting-terminal-or-iterm2-on-mac-os-x
# https://discussions.apple.com/thread/2178316?start=0&tstart=0
# http://osxdaily.com/2010/05/06/speed-up-a-slow-terminal-by-clearing-log-files/
alias dotruncateasl='sudo rm /private/var/log/asl/*.asl'

# http://en.kuma-de.com/blog/2011-12-24/483
# ...
alias dormdsstore="find . -name '.DS_Store' | xargs rm"
