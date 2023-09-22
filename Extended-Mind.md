# Extended Mind: The Missing Manual

Various shell commands and conceptually related patterns I frequently
use but sometimes forget.

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
git filter-branch --env-filter 'export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"; '
```

See also: `git rebase --committer-date-is-author-date`.

## Gerrit

```
ssh -p 29418 gerrit.wikimedia.org delete-project delete "' examples/testing'" --yes-really-delete
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
