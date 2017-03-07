# Version control
alias dogitcommit='git commit -F ~/Development/tmp/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'

alias gigisu='git lg-prefix'

alias domakejenkinscommit='git remote update origin && git co -b jenkins -t origin/master && touch jenkins.js jenkins.css jenkins.php .jenkins && git add jenkins.js jenkins.css jenkins.php .jenkins && git commit -m "Sample commit for Jenkins"'

alias doapachereset='cd /usr/local/var/log/apache2/ && sudo brew services restart httpd24'

alias diff='colordiff'

# http://ariejan.net/2011/11/08/fixing-a-slow-starting-terminal-or-iterm2-on-mac-os-x
# https://discussions.apple.com/thread/2178316?start=0&tstart=0
# http://osxdaily.com/2010/05/06/speed-up-a-slow-terminal-by-clearing-log-files/
alias dotruncateasl='sudo rm /var/log/asl/*.asl'

# http://support.apple.com/kb/ht5343
alias doflushdns='sudo killall -HUP mDNSResponder'

# https://snipt.net/Yannick/delete-recursively-a-file-ds_store-thumbsdb-desktopini-etc/
alias dormdsstore='find . -name ".DS_Store" -type f -exec rm {} \;'

alias dotfiles-push='cd $KDF_BASE_DIR; git add -p && _dotfiles-prompt-choice "OK to push now?" && git commit -m "update dotfiles" && git push origin HEAD; cd -'

# https://help.github.com/articles/generating-a-new-gpg-key/
# https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/
# https://help.github.com/articles/telling-git-about-your-gpg-key/
alias dolistgpg='gpg --list-secret-keys --keyid-format LONG'
