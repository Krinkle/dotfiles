# Extended Mind: The Missing Manual

Various shell commands and patterns I use infrequently and sometimes forget.

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

## kafkacat, kcat

```
$ kafkacat -C -b kafka-jumbo1013.eqiad.wmnet:9092 -o -10000000 -e -t webrequest_frontend_text
```

```
$ kafkacat -C -b kafka-jumbo1013.eqiad.wmnet:9092 -L
```

```
$ kafkacat -C -b kafka-jumbo1013.eqiad.wmnet:9092 -o -1000000 -t eqiad.mediawiki.web_ui_actions
```

## MySQL

```
GRANT USAGE ON *.* TO 'the_user'@'%' IDENTIFIED BY 'the_pass' WITH MAX_USER_CONNECTIONS 100;

GRANT INSERT, SELECT, ALTER, CREATE, DELETE, UPDATE ON `the_database`.* TO 'the_admin_user'@'%';

GRANT INSERT, SELECT ON `the_database`.* TO 'the_user'@'%';
```

## php-src development

* `brew install libiconv`, keg-only system override. Even when in PATH, LDFLAGS, and CPPFLAGS, it is not automatically discovered. https://github.com/php/php-src/pull/19475
* `brew install icu4c`, key-only system override, for `--enable-intl`. Discovered via PKG_CONFIG_PATH.

```
./configure --enable-debug --without-iconv --enable-intl --enable-mbregex --enable-mbstring --with-libedit && make -j8
```

## Python

Test an SSL certificate

```sh
$ cat serve.py
```

```py
# Require: Python 3.12+
from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl

httpd = HTTPServer(('localhost', 4443), BaseHTTPRequestHandler)
context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
context.load_cert_chain(certfile='example/example_org.pem', keyfile='example/example_org.key')
httpd.socket = context.wrap_socket(httpd.socket, server_side=True)
httpd.serve_forever()
```

```sh
$ python3 serve.py
```

```sh
$ cat /etc/hosts
# …
krinkle.example.org 127.0.0.1
```

```sh
$ curl -v https://krinkle.example.org:4443

$ open https://krinkle.example.org:4443
```

## spark3-sql

https://wikitech.wikimedia.org/wiki/Data_Platform/Systems/Spark#Use_PySpark_to_run_SQL_on_Hive_tables

```
$ spark3-sql --master yarn --executor-memory 8G --executor-cores 4 --driver-memory 2G --conf spark.dynamicAllocation.maxExecutors=64
```

## ssh

Easily remove a host key (fingerprint) from a known host, if the change is expected
and legitimate.

```
Add correct host key in ~/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in ~/.ssh/known_hosts:19
Host key for bastion.wmflabs.org has changed and you have requested strict checking.
Host key verification failed.
```

```
$ ssh-keygen -R bastion.wmflabs.org

# Host bastion.wmflabs.org found: line 16
# Host bastion.wmflabs.org found: line 17
# Host bastion.wmflabs.org found: line 18
# Host bastion.wmflabs.org found: line 19
~/.ssh/known_hosts updated.
Original contents retained as ~/.ssh/known_hosts.old
```

## tty

Rewrite multiple lines in terminal output.

The simplest way is carriage return `\r` to overwrite the current line, which works fine if the replacement is of equal or longer length (or you pad with spaces), or if rendering a progress bar of constant width or equal to the current terminal width (TTY columns).

More advanced method, which has the benefit of remaining friendly to line wrapping and without direclty depending on terminal width:

[Leedehai wrote 2 Dec 2019](https://stackoverflow.com/a/59147732/319266):
```python
#!/usr/bin/env python

import sys
import time
from collections import deque

queue = deque([], 3)
i = 0
while True:
    time.sleep(0.5)
    if i <= 20:
        s = "update %d" % i
        i += 1
    else:
        s = None
    for _ in range(len(queue)):
        sys.stdout.write("\x1b[1A\x1b[2K") # move up cursor and delete whole line
    if s != None:
        queue.append(s)
    else:
        queue.popleft()
    if len(queue) == 0:
        break
    for i in range(len(queue)):
        sys.stdout.write(queue[i] + "\n") # reprint the lines
```

[Darkman wrote 27 Feb 2022](https://stackoverflow.com/a/71286261/319266):
```bash
# clear the previous line
printf '\033[1A\033[K'
# clear the last 10 lines
for i in {1..10}; do printf '\033[1A\033[K'; done
```

## varnishlog

https://varnish-cache.org/docs/7.0/
https://varnish-cache.org/docs/7.0/reference/varnishlog.html
https://gerrit.wikimedia.org/r/q/project:operations/debs/varnish4


```
sudo varnishlog -c -n frontend -g request -i ReqHeader -q "ReqUrl ~ '/wiki/'"

sudo varnishlog -c -n frontend -g raw -I ReqHeader:accept-language
sudo varnishlog -c -n frontend -g raw -q "ReqHeader eq 'Host: test.wikipedia.org'"

sudo varnishlog -c -n frontend -i ReqUrl,ReqHeader -q "ReqUrl ~ '/wiki/'"
sudo varnishlog -c -n frontend -i ReqUrl,ReqHeader,RespHeader -q "ReqHeader eq 'Host: test.wikipedia.org'"
```

https://gerrit.wikimedia.org/g/operations/puppet/+/HEAD/conftool-data/node/esams.yaml
https://config-master.wikimedia.org/pybal/esams/text
https://config-master.wikimedia.org/pybal/esams/upload

## vim

```
/	Find in file
n	Find next match
N	Find previous match
```

## watch

```
$ watch --help
…
  -d, --differences       highlight changes between updates
  -e, --errexit           exit if command has a non-zero exit
  -g, --chgexit           exit when output from command changes
  -q, --equexit <cycles>  exit when output from command does not change
```

Lop until the output is not "Already up to date".

```
watch -g git pull
```
