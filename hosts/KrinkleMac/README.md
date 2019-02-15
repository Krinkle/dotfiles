# KrinkleMac

Aside from the automatic provisions from [init](./init.bash), there are additional setups and workflows documented below.

## SSH Key

See <https://help.github.com/articles/generating-ssh-keys>.

## GPG key

* https://help.github.com/articles/generating-a-new-gpg-key/
* https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/
* https://help.github.com/articles/telling-git-about-your-gpg-key/

## Terminal app

#### Preferences

* Profile: Pro
* Cursor: Vertical Bar
* Blink cursor: Enabled
* Font: Menlo Regular, 12pt
* Pointer High-contrast beam: Disabled

## System Preferences

#### Mission Control

* (disabled) Automatically rearrange Spaces based on most recent use.
* See also <https://apple.stackexchange.com/a/44801/33762>


#### Keyboard -> Shortcuts -> Mission Control:

These interfere with Sublime Text selection expansion shortcuts (`Shift ctrl ↑` and `Shift ^ ↓`):

* (disabled) Mission Control - "^↑"
* (disabled) Application Windows - "^↓"

## Development

### Checkouts

```
$ mkdir -p ~/Development
$ cd ~/Development
doclonegerrit mediawiki
doclonegerrit oojs/core oojs
doclonegerrit oojs/ui oojs-ui
doclonegerrit integration/config wikimedia/integration/config
doclonegerrit operations/mediawiki-config wikimedia/operations-mediawiki-config
doclonegerrit operations/puppet wikimedia/puppet

$ cd ~/Development/mediawiki/skins
doclonegerrit mediawiki/skins/Vector

$ cd ~/Development/mediawiki/extensions
doaddwmext CategoryTree
doaddwmext Cite
doaddwmext examples
doaddwmext Interwiki
doaddwmext NavigationTiming
doaddwmext ParserFunctions
doaddwmext TemplateData
doaddwmext WikimediaEvents
```

### Apache

Reserve port 8080 for mediawiki-docker-dev (or MediaWiki-Vagrant).
Move the local Apache to port 8000, for serving `~/Development`.

```
# Change `Listen 8080` to `Listen 8000`
$ edit /usr/local/etc/httpd/httpd.conf

# Load custom config
$ mkdir /usr/local/etc/httpd/other
$ echo 'Include /usr/local/etc/httpd/other/*.conf' >> /usr/local/etc/httpd/httpd.conf
$ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/httpd/other/krinkle.conf
````

## MediaWiki-Vagrant

See <https://www.mediawiki.org/wiki/MediaWiki-Vagrant>.

## macOS Applications

#### Install via App Store

* Pixelmator
* Simplenote
* Skitch
* The Unarchiver
* Time Out
* Wunderlist

#### Install others

* Atom
* coconutBattery
* Docker
* Firefox
* FirefoxDeveloperEdition
* Google Chrome
* Google Chrome Canary
* ImageOptim
* MySQLWorkbench
* OpenOffice
* Opera
* Safari Technology Preview
* Sequel Pro
* Sublime Text
* VirtualBox
* VLC

#### Sublime Text

Plugins:

* https://packagecontrol.io/installation
* DocBlockr
* LESS
* Puppet
* SublimeLinter
* SublimeLinter-contrib-eslint
* Theme - Soda
* TrailingSpaces

#### Atom

Community Themes:

* monokai

Community Packages:

* linter-eslint
* minimap
* minimap-highlight-selected
* highlight-selected
* sort-lines
