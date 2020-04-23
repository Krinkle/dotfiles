# Krinkle Dotfiles: Primary workstation

See the **[install](./install#blob-path)** file for the automated provisions.

Additional setups and workflows documented below.

## Screenshots

<img height="444" alt="Screenshot of the Terminal app" src="https://user-images.githubusercontent.com/156867/53701021-b59e3300-3df0-11e9-8132-d0a85e9f80c9.png">
<img height="380" alt="Screenshot of Git prompt" src="https://i.imgur.com/AGJ9uz1.png">

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
doclonegerrit integration/config wikimedia/integration-config
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

## Applications

Install via App Store:

* Affinity Photo
* Mini Calendar
* Pixelmator
* Simplenote
* Skitch
* Telegram
* The Unarchiver
* Time Out

Install (other):

* Atom
* coconutBattery
* Docker
* Firefox
* Google Chrome
* GPG Suite (GPG Keychain)
* ImageOptim
* KeeWeb
* Logitech Options
* OpenOffice
* Steam
* Sublime Text
* VLC

#### Atom

Install Community Themes:

* monokai

Install Community Packages:

* linter-eslint
* minimap
* minimap-highlight-selected
* highlight-selected
* sort-lines

Settings / Core:

* Exclude VCS Ignored Paths: **Disabled**. _(Include MediaWiki extension repos in search index)_

* Ignored Names: `.git, .hg, .svn, .DS_Store, node_modules, vendor`. _(Compensate for inclusion of VCS Ignored Paths)_

Settings / Editor:

* Show Invisibles: **Enabled**. _(Show tab marks)_

* Packages / Tree View / Hide VCS Ignored Files: **Disabled**. _(Include MediaWiki extensions in sidebar. [Thanks @viion](https://github.com/atom/atom/issues/3429#issuecomment-286593181)!)_

#### Docker for Mac

File Sharing:

* Only allow directories under `/Users/krinkle/Development` to be mounted.

Advanced:

* Increase memory to 4 GB.

#### 🌱  Fresh

Install from <https://github.com/wikimedia/fresh>.

#### Finder

Finder Preferences -> General:

* New Finder windows show: Home directory.

Finder Preferences -> Sidebar:

* (disabled) Favourites / Recents.
* (enabled) Favourites / (all others).
* (disabled) iCloud Drive.
* (disabled) Locations / My Computer.
* (disabled) Locations / CDs (includes "Remote Disc" placeholder)
* (enabled) Locations / (all others).
* (disabled) Tags.

Desktop / View:

* Sort By: Snap to Grid (enabled).

#### Firefox

Preferences -> Search:

* Default search engine: DuckDuckGo.

Preferences -> Security:

* (disabled) Ask to save logins and passwords.

Advanced Preferences (`about:config`):

* (enabled) `view_source.wrap_long_lines` _(match Chromium's default behaviour)_

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

#### Music app

View:

* (enabled) Show Status Bar.

#### Simplenote

View:

* Notes List / Note Display: Condensed.
* Notes List / Sort Order: Alphabetical.

#### Safari

View:

* (enabled) Show Status Bar

Preferences -> General:

* Safari opens with: "A new window".
* New windows: "Empty page".
* New tabs: "Empty page".
* (disabled) Open safe files after downloading.

Preferences -> AutoFill:

* (disabled) Everything.

Preferences -> Search:

* Search engine: DuckDuckGo
* (disabled) Preload Top Hit in the background.

Preferences -> Advanced:

* (enabled) Pressing Tab will highlight each item on a webpage.

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

Accessibility -> Mouse & Trackpad -> Trackpad Options:

* (enabled) Enable dragging by "three finger drag".

Date & Time -> Clock:

* (enabled) Show date.

Dock:

* (disabled) Show recent applications in Dock.

Internet Accounts:

* (enabled) Google / Contacts.

Keyboard -> Text:

* (disabled) Correct spelling automatically.
* (disabled) Use smart quotes. _(Sorry, I do I love these but, the vast majority
  of text areas it affects I may end up writing code in; Besides, any context
  in which I write "properly" already supports this own its own without OS support)_
* (disabled) Add full stop with double-space.

Keyboard -> Shortcuts -> Mission Control:

* (disabled) Mission Control - "^↑" (These interfere with Sublime Text selection expansion shortcuts, `Shift ctrl ↑` and `Shift ^ ↓`.):
* (disabled) Application Windows - "^↓"

Mission Control:

* (disabled) Automatically rearrange Spaces based on most recent use.
* See also <https://apple.stackexchange.com/a/44801/33762>

Security & Privacy:

* (enabled) Require password after sleep or screen saver.
* Require password after: "immediately".

Screen savers -> Hot Corners:

* (enabled) Top left: Desktop.
* (enabled) Top right: Mission Control.

Sharing:

* Computer Name: `krinkle-mbp#`

Spotlight -> Search results:

* (disabled) Spotlight Suggestions
* (disabled) Allow Spotlight Suggestions in Look Up

Spotlight -> Privacy:

* Prevent indexing of: `~/Development` (performance reasons).

Time Machine:

* Exclude: `~/Development`.
* Exclude: `~/Downloads`.

Trackpad -> More Gestures:

* (disabled) Swipe between pages.
* (enabled) Swipe between spaces by "swipe sideways with **four** fingers. _(Keep "three fingers" reserved for dragging.)_
* (disabled) Mission Control. _(Triggered via Hot Corners instead. Keep "three fingers" reserved for dragging.)_

Users & Groups -> Advanced Options:

* Login shell: `/usr/local/bin/bash` (via Homebrew)

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
