# Actions
alias docheckcommitmsg='cat ~/Development/tmp/COMMIT.txt'
alias dosvncommit='svn commit -F ~/Development/tmp/COMMIT.txt'
alias dogitcommit='git commit -F ~/Development/tmp/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'
alias dotfiles-push='cd ~/.krinkle.dotfiles && git commit -a -m "sync dotfiles" && git push -f && cd -'
alias dotfiles-push-amend='cd ~/.krinkle.dotfiles && git commit -a --amend -c HEAD --reset-author && git push -f && cd -'

# Set up stuff for git repositories from gerrit.wikimedia.org
alias dogerritfixup='git review -s && git remote rm origin 2> /dev/null; git remote update && git branch --set-upstream-to gerrit/master master'

# http://ariejan.net/2011/11/08/fixing-a-slow-starting-terminal-or-iterm2-on-mac-os-x
# https://discussions.apple.com/thread/2178316?start=0&tstart=0
# http://osxdaily.com/2010/05/06/speed-up-a-slow-terminal-by-clearing-log-files/
alias dotruncateasl='sudo rm /var/log/asl/*.asl'

# https://snipt.net/Yannick/delete-recursively-a-file-ds_store-thumbsdb-desktopini-etc/
alias dormdsstore='find . -name ".DS_Store" -type f -exec rm {} \;'

alias doapachereset='cd /usr/local/opt/httpd/var/apache2/log && rm -f *_log && sudo apachectl restart && l'

# Mirror media repositories
# $ wget-magic-noindex "http://..."
# $ wget-magic-filter ".png" "http://..."
alias wget-magic-noindex='wget -m --no-parent --reject "index.html*"'
alias wget-magic-filter='wget -m --no-parent -A'
alias wget-magic-mkv='wget-magic-filter "*.mkv"'
