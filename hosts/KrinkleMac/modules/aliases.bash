# Actions
alias docheckcommitmsg='cat ~/Documents/COMMIT.txt'
alias dosvncommit='svn commit -F ~/Documents/COMMIT.txt'
alias dogitcommit='git commit -F ~/Documents/COMMIT.txt'
alias gogogerrit='git review -R'
alias grabfromgerrit='git review -d'
alias dotfiles-push='cd ~/.krinkle.dotfiles && git commit -a -m "sync dotfiles" && git push -f && cd -'
alias dotfiles-push-amend='cd ~/.krinkle.dotfiles && git commit -a --amend -C HEAD --reset-author && git push -f && cd -'


# Set up stuff for git clones from gerrit.wikimedia.org
# - Call git-review without arguments so it installs the neccecary hooks
#   and adds the 'gerrit' git-remote
# - Removes the 'origin' remote
# - Updates the local 'master' branch to be a remote tracking branch to gerrit/master
#   (just like git-clone would do if it was set up that way in the first place)
# NB: This hard-resets the local master branch. Because git-review has no init command
# the only way to trigger that is to do "git review" (shortcut for "git review submit")
# when there are no changes, in which case it'll initialise and then return early with 
# an error message, which is why we separate it with ";" instead of "&&" as it is the
# only step where an error status code is to be expected.
alias dogerritfixup='git fetch --all && git checkout master && git reset --hard origin/master && git review; git remote rm origin; git branch --set-upstream master gerrit/master'

# http://ariejan.net/2011/11/08/fixing-a-slow-starting-terminal-or-iterm2-on-mac-os-x
# https://discussions.apple.com/thread/2178316?start=0&tstart=0
# http://osxdaily.com/2010/05/06/speed-up-a-slow-terminal-by-clearing-log-files/
alias dotruncateasl='sudo rm /private/var/log/asl/*.asl'

# http://en.kuma-de.com/blog/2011-12-24/483
# ...
alias dormdsstore="find . -name '.DS_Store' | xargs rm"
