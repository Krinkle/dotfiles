# KrinkleMac

Aside from the automatic provisions from [init](./init.bash), there are additional setups and workflows documented below.

## SSH Key

See <https://help.github.com/articles/generating-ssh-keys>.

## GPG key

* https://help.github.com/articles/generating-a-new-gpg-key/
* https://help.github.com/articles/adding-a-new-gpg-key-to-your-github-account/
* https://help.github.com/articles/telling-git-about-your-gpg-key/

## Development

#### Checkouts

```
mkdir -p ~/Development
cd ~/Development
git clone https://github.com/addshore/mediawiki-docker-dev.git
doclonegerrit mediawiki/core mediawiki
doclonegerrit oojs/core oojs
doclonegerrit oojs/ui oojs-ui
doclonegerrit integration/config wikimedia/integration/config
doclonegerrit operations/mediawiki-config wikimedia/operations-mediawiki-config
doclonegerrit operations/puppet wikimedia/puppet

cd ~/Development/mediawiki/skins
doclonegerrit mediawiki/skins/Vector

cd ~/Development/mediawiki/extensions
doaddwmext AbuseFilter
doaddwmext CategoryTree
doaddwmext Cite
doaddwmext CodeEditor
doaddwmext EventLogging
doaddwmext examples
doaddwmext Gadgets
doaddwmext Interwiki
doaddwmext NavigationTiming
doaddwmext ParserFunctions
doaddwmext TemplateData
doaddwmext WikimediaEvents
```

#### Apache

Reserve port 8080 for mediawiki-docker-dev (or MediaWiki-Vagrant).
Move the local Apache to port 8000, for serving `~/Development`.

```
# Change `Listen 8080` to `Listen 8000`
$ edit /usr/local/etc/httpd/httpd.conf

# Load custom config
$ mkdir /usr/local/etc/httpd/other
$ echo 'Include /usr/local/etc/httpd/other/*.conf' >> /usr/local/etc/httpd/httpd.conf
$ ln -s $KDF_BASE_DIR/hosts/KrinkleMac/httpd.conf /usr/local/etc/httpd/other/krinkle.conf
```

## Applications

Install via App Store:

* Pixelmator
* Simplenote
* Skitch
* The Unarchiver
* Time Out
* Wunderlist

Install (other):

* Atom
* coconutBattery
* Docker
* Firefox
* FirefoxDeveloperEdition
* GPG Suite
* Google Chrome
* Google Chrome Canary
* ImageOptim
* KeeWeb
* Logitech Options
* MySQLWorkbench
* OpenOffice
* Opera
* Safari Technology Preview
* Sequel Pro
* Sublime Text
* VLC

#### Atom

Community Themes:

* monokai

Community Packages:

* linter-eslint
* minimap
* minimap-highlight-selected
* highlight-selected
* sort-lines

#### Docker for Mac

File Sharing:

* Only allow directories under `/Users` to be mounted.

Advanced:

* Increase memory to 4 GB.

#### Gmail

Settings -> General:

* (enabled) Keyboard shortcuts on. _This allows quick keyboard-based processing of issue tracker and code review messages. By pressing `#` (Shift-3)._

Settings -> Advanced:

* (enabled) Custom keyboard shortcuts. _Google hasn't considered non-American keyboards. As such, the shortcut for `Delete` is non-functional on British English keyboards. Neither Shift-3 (£), nor Shift-Alt-3 (#) works. But you can make it work by adding `£` as custom second shortcut for `Delete`. After enabling this feature, you have to save settings and reload the page before it works. Then, under "Setttings -> Keyboard Shortcuts" add `£` in the second column for "Delete", and again, save and reload before it works. Happy deleting!_

#### GPG Suite

System Preferences / GPG Suite / Settings:

* (disabled) Store in macOS Keychain.

#### Messages app

Preferences:

* (disabled) Play sound effects.

#### Skitch

Preferences:

* (disabled) Auto-expand canvas.

#### Sublime Text

Plugins:

* https://packagecontrol.io/installation
* LESS
* Puppet
* Theme - Soda
* TrailingSpaces

#### System Preferences

Mission Control:

* (disabled) Automatically rearrange Spaces based on most recent use.
* See also <https://apple.stackexchange.com/a/44801/33762>

Keyboard -> Text:

* (disabled) Correct spelling automatically.
* (disabled) Use smart quotes. _(Sorry, I do I love these but, the vast majority
  of text areas it affects I may end up writing code in; Besides, any context
  in which I write "properly" already supports this own its own without OS support)_

Keyboard -> Shortcuts -> Mission Control:

* (disabled) Mission Control - "^↑" (These interfere with Sublime Text selection expansion shortcuts, `Shift ctrl ↑` and `Shift ^ ↓`.):
* (disabled) Application Windows - "^↓"

Date & Time -> Clock:

* (enabled) Show date.

Screen savers -> Hot Corners:

* (enabled) Top left: Desktop.
* (enabled) Top right: Mission Control.

Trackpad -> More Gestures:

* (disabled) Swipe between pages.
* (enabled) Swipe between spaces by "swipe sideways with **four** fingers. _(Keep "three fingers" reserved for dragging.)_
* (disabled) Mission Control. _(Triggered via Hot Corners instead. Keep "three fingers" reserved for dragging.)_

Accessibility -> Mouse & Trackpad -> Trackpad Options:

* (enabled) Enable dragging by "three finger drag".

#### Terminal app

Preferences -> Profiles:

* Pro

Preferences -> Profiles -> Text:

* Font: Menlo Regular 12pt.
* Cursor: Vertical Bar
* (enabled) Blink cursor

Preferences -> Profiles -> Window:

* (enabled) **Working directory**
* (enabled) **Working directory path**
* (enabled) **Active process name**
* (disabled) Arguments

Preferences -> Profiles -> Tab:

* (enabled) **Working directory**
* (disabled) Working directory path
* (disabled) Active process name
* (disabled) Arguments
