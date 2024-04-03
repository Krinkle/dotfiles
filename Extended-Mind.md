# Extended Mind: The Missing Manual

Various shell commands and conceptually related patterns I frequently
use but sometimes forget.

## apt

What Debian package installs a given command?

* iproute2: ip, `ip -4 route list`.
* iputils-ping: ping.
* net-tools: ifconfig, netstat.

## aspell

aspell does not crawl directories or take multiple files, nor does it work easily with xargs. For loops! Note `|| break` in order to be able to stop it with aspell 0.60.9+ ([bug](https://github.com/GNUAspell/aspell/issues/598)).

```
for _filename in $(git ls-files '*.md'); do aspell --mode=markdown --encoding=utf-8 --lang=en check "$_filename" || break; done;
```

## chown

Fix permissions recursively for files not owned by a given user or group:

```
find . -not -group MY_GROUP  -print0 | xargs -0 -r chgrp --no-dereference MY_GROUP


find . -not -user MY_USER  -print0 | xargs -0 -r chown --no-dereference MY_USER
```

Inspired by [wikimedia/operations-puppet.git:/mediawiki/fix-staging-perms.sh](https://gerrit.wikimedia.org/g/operations/puppet/+/b1721a0871515a55f5d9eefdba1447ec30da1bc1/modules/profile/files/mediawiki/deployment/fix-staging-perms.sh).

## ffmpeg

* http://ffmpeg.org/ffmpeg.html#Main-options
* http://ffmpeg.org/ffmpeg-utils.html#Time-duration
* `[-][HH:]MM:SS[.m...]`

```
ffmpeg -i movie.mp4 -ss 00:00:03. -t 00:00:08 -async 1 cut.mp4
```

<https://stackoverflow.com/a/47512301/319266>

```
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 30 -b:v 0 -b:a 128k -c:a libopus output.webm
```

<https://trac.ffmpeg.org/wiki/Encode/VP9#twopass>

```
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 1 -an -f null /dev/null && \
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 0 -crf 30 -pass 2 -c:a libopus output.webm
```

## git

Reduce a branch down in preparation for merging or splitting off a library into its own repository. 
```
git filter-branch --prune-empty --tree-filter 'rm -rf .gitignore README.md docs/'
```

Remove yourself as, otherwise retroactively injected, committer of all changes by mapping committer to author.
```
git filter-branch --env-filter 'export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL";'
```
See also:
```
git rebase --committer-date-is-author-date
```

Only some the last few commits:
```
git filter-branch [--some-options-here] d84af39036...HEAD
```

## Gerrit

```
ssh -p 29418 gerrit.wikimedia.org delete-project delete "' examples/testing'" --yes-really-delete
```

Add "Reviewed-on:" footer to commit messages during repository extraction or splitting, <https://phabricator.wikimedia.org/T273247#6794951>.
```
cd new-library

export FIRST_GERRIT_COMMIT_SHA1=

git rebase $FIRST_GERRIT_COMMIT_SHA1 -i --committer-date-is-author-date --exec 'K_GERRITID=$(git log -1 --format=%b | grep "Change-Id:" | head -n1 || true) && test -n "$K_GERRITID" && K_REVIEWLINE=$(GIT_DIR=/Users/krinkle/Development/mediawiki/.git git log --notes=review --grep="$K_GERRITID" -1 --format=%N | grep "Reviewed-on:" || true) && test -n "$K_REVIEWLINE" && K_OLDMSG=$(git log --format=%B -n 1) && git commit --amend -m "$(printf "$K_OLDMSG\n$K_REVIEWLINE\n")"'


git rebase --root -i --committer-date-is-author-date --exec 'K_GERRITID=$(git log -1 --format=%b | grep "Change-Id:" | head -n1 || true) && test -n "$K_GERRITID" && K_REVIEWLINE=$(git log origin/master --notes=review --grep="$K_GERRITID" -1 --format=%N | grep "Reviewed-on:" || true) && test -n "$K_REVIEWLINE" && K_OLDMSG=$(git log --format=%B -n 1) && git commit --amend -m "$(printf "$K_OLDMSG\n$K_REVIEWLINE\n")"'

```

## MySQL

```
GRANT USAGE ON *.* TO 'the_user'@'%' IDENTIFIED BY 'the_pass' WITH MAX_USER_CONNECTIONS 100;

GRANT INSERT, SELECT, ALTER, CREATE, DELETE, UPDATE ON `the_database`.* TO 'the_admin_user'@'%';

GRANT INSERT, SELECT ON `the_database`.* TO 'the_user'@'%';
```

## vim

```
/	Find in file
n	Find next match
N	Find previous match
```
