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

### Checkouts

```
mkdir -p ~/Development

cd ~/Development
doclonegerrit mediawiki/core mediawiki
doclonegerrit oojs/core
doclonegerrit oojs/ui
doclonegerrit integration/config wikimedia/integration-config
doclonegerrit operations/mediawiki-config wikimedia/operations-mediawiki-config
doclonegerrit operations/puppet wikimedia/puppet
doclonegerrit operations/debs/wmf-sre-laptop wmf-sre-laptop

doclonegerrit cdb
doclonegerrit jquery-client
doclonegerrit mediawiki/libs/less.php less.php
doclonegerrit mediawiki/libs/node-cssjanus node-cssjanus
doclonegerrit mediawiki/libs/php-cssjanus php-cssjanus
doclonegerrit RelPath
doclonegerrit RunningStat
doclonegerrit WrappedString
doclonegerrit mediawiki/libs/Minify
doclonegerrit mediawiki/libs/ScopedCallback
doclonegerrit mediawiki/libs/Timestamp
doclonegerrit mediawiki/libs/WaitConditionLoop
doclonegerrit mediawiki/php/excimer

cd ~/Development/mediawiki/skins
doclonegerrit mediawiki/skins/Vector
doclonegerrit mediawiki/skins/MonoBook

cd ~/Development/mediawiki/extensions
doaddwmext AbuseFilter
doaddwmext CategoryTree
doaddwmext Cite
doaddwmext CiteThisPage
doaddwmext CodeEditor
doaddwmext EventLogging
doaddwmext EventStreamConfig
doaddwmext examples
doaddwmext Gadgets
doaddwmext Interwiki
doaddwmext NavigationTiming
doaddwmext ParserFunctions
doaddwmext TemplateData
doaddwmext WikimediaEvents

# Copy and ignore
ln $KDF_BASE_DIR/hosts/primary/mw-LocalSettings.php ~/Development/mediawiki/LocalSettings.mine.php
echo LocalSettings.mine.php >> .git/info/exclude
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

* 1Password
* Carbon Copy Cloner
* coconutBattery
* Firefox
* Google Chrome
* GPG Suite (GPG Keychain)
* ImageOptim
* KeeWeb
* Little Snitch
* Logitech Options
* NetNewsWire (+Feedbin)
* OpenOffice
* PhpStorm
* Podman Desktop
* Proton VPN
* Sublime Text
* VLC

### 1Password

OpenJS Foundation:

* username + password + "Recovery Kit.pdf" (server + key)

### Carbon Copy Cloner

Settings / Dashboard:

* (disabled) Show CCC's icon in the menu bar.

Tasks:

* Import Tasks... from backed up `.ccctask` file.

### Podman Desktop

* (enabled) docker-compose binary system wide
* Podman machine: 4 CPU, 4 GB mem, 40 GB disk

### 🌱 Fresh

Install from <https://gerrit.wikimedia.org/g/fresh>.

### Finder

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

### Firefox

Preferences -> Search:

* Default search engine: DuckDuckGo.

Preferences -> Home:

* (enabled) Web search
* (disabled) Shortcuts
* (disabled) Recommended by Pocket
* (disabled) Recent activity

Preferences -> Security:

* (disabled) Ask to save logins and passwords.

Advanced Preferences (`about:config`):

* (enabled) `view_source.wrap_long_lines` _(match Chromium's default behaviour)_
* (change from 3 to 1) `mousewheel.with_meta.action` _(avoid unexpected page zoom action when scrollwheel is still spinning and holding down cmd key for something else; [source](https://support.mozilla.org/en-US/questions/953341))_
* (disabled) `browser.urlbar.trimURLs`  _(This was enabled in 2025 but is buggy and causes copy to clipboard to fail seemingly at random with a missing protocol; [Credit to Alice](https://mk.nyaa.place/notes/aabif6f9q5jm03g5))_

Toolbar:

* (Remove from Toolbar) Pocket

Sync:

* (enabled) Bookmarks.

Plugins:

* Wayback Machine
* WikimediaDebug

### Gmail

Settings -> General:

* (enabled) Keyboard shortcuts on. _This allows quick keyboard-based processing of issue tracker and code review messages. By pressing `#` (Shift-3)._

Settings -> Advanced:

* (enabled) Custom keyboard shortcuts. _Google hasn't considered non-American keyboards. As such, the shortcut for `Delete` is non-functional on British English keyboards. Neither Shift-3 (£), nor Shift-Alt-3 (#) works. But you can make it work by adding `£` as custom second shortcut for `Delete`. After enabling this feature, you have to save settings and reload the page before it works. Then, under "Setttings -> Keyboard Shortcuts" add `£` in the second column for "Delete", and again, save and reload before it works. Happy deleting!_

### GPG Suite

System Preferences / GPG Suite / Settings:

* (disabled) Store in macOS Keychain.

### KeeWeb

Settings / General / Function:

* (enabled) Automatically save and sync periodically.
* (enabled) Clear cipboard after copy: In a minute.
* (enabled) Minimize the app instead of close.

Settings / General / Auto lock:

* (enabled) When the computer is locked or put to sleep.

### Little Snitch

Preferences:

* Preselected Options / Rule Lifetime: For 10 minutes.
* (enabled) Confirm with Return or Escape

### Logitech Options

MX Master / Mouse:

* Scroll wheel button: None.
* Middle button ("Manual switch"): Look Up.
* Thumb wheel: Horizontal scroll.
* Thumb forward: Click.
* Thumb back: Right click.
* Thumb pad button: None.

MX Master / Point & Scroll:

* Scroll direction: Standard.
* Smooth scrolling: Disabled.
* SmartShift: Disabled.
* Scroll wheel mode: Free spin.

Logitech Options "Plus" regressions:

* "Look Up" missing.
  * Workaround: keyboard shortcut "ctrl-cmd-D" ([Reddit source](https://old.reddit.com/r/logitech/comments/tfyu5i/look_up_action_disappeared_in_logi_options_beta/))
* "Click" mapping no longer holds (e.g. for dragging in drag-and-drop, or to move/resize a window), when mapping "Thumb forward" to "Click" (via Advanced click).
  * Workaround: N/A. Use regular mouse buttons, and pray you don't get RSI.
  * Reports:
    [Reddit 1](https://old.reddit.com/r/logitech/comments/14y3nxr/mx_master_2s_side_buttons_no_click_and_hold/),
    [Reddit 2](https://old.reddit.com/r/logitech/comments/z3jjyc/bring_back_left_click_for_buttons_in_options/),
    [Reddit 3](https://old.reddit.com/r/logitech/comments/wiyowd/altshiftctrl_click_functions_on_mx3/),
    [Logi 1](https://support.logi.com/hc/en-gb/community/posts/9037143525655-Logi-Option-advanced-click-can-t-be-holded),
    [Logi 2](https://support.logi.com/hc/en-us/community/posts/360032668873-Click-and-Hold),
    [Logi 3](https://support.logi.com/hc/en-us/community/posts/360032391954-Logitech-Options-Advanced-Click),
    [Logi 4](https://support.logi.com/hc/en-gb/community/posts/360044026454-No-Advanced-Middle-Click-for-Mac-OS-Logi-Options).

### Messages app

Preferences:

* (disabled) Play sound effects.
* Keep messages: One Year (default: Forever).

### Music app

View:

* (enabled) Show Status Bar.

Settings > General:

* (disabled) Show "Apple Music".
* (disabled) Notifications "When song changes".

### PhpStorm

License:

* Import offline activation key.
* Or recover via JetBrains account
* Or obtain via <https://office.wikimedia.org/wiki/JetBrains> (restricted)

### Simplenote

View:

* Notes List / Note Display: Condensed.
* Notes List / Sort Order: Alphabetical.

### Safari

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

### Skitch

Preferences:

* (disabled) Auto-expand canvas.

### Sublime Text

* Install Package Control (via cmd-P).

Plugins:

* EditorConfig
* Less
* Puppet
* Theme - Soda
* TrailingSpaces

### System Preferences

Apple ID:
* (enabled) Messages
* (enabled) FaceTime
* (enabled) iCloud > Find My Mac
* (disabled) Everything else, including:
  * Optimise Mac Storage
  * Photos
  * Keychain
  * Access iCloud Data on the Web

Trackpad:

* (enabled) Tap to click
* (disabled) Mission Control
* (disabled) App Expose
* (disabled) Launchpad
* (disabled) Show Desktop

Accessibility -> Mouse & Trackpad -> Trackpad Options:

* (enabled) Enable dragging by "three finger drag".

Date & Time -> Clock:

* (enabled) Show date.

Dock:

* (disabled) Show recent applications in Dock.

Internet Accounts:

* (enabled) Fastmail / Contacts.

Keyboard -> Text:

* (disabled) Correct spelling automatically.
* (disabled) Use smart quotes. _(Sorry, I do I love these but, the vast majority
  of text areas it affects I may end up writing code in; Besides, any context
  in which I write "properly" already supports this own its own without OS support)_
* (disabled) Add full stop with double-space.

Keyboard -> Shortcuts -> Mission Control:

* (disabled) Mission Control - "^↑" (These interfere with Sublime Text selection expansion shortcuts, `Shift ctrl ↑` and `Shift ^ ↓`.):
* (disabled) Application Windows - "^↓"

Desktop & Dock -> Mission Control:

* (disabled) Automatically rearrange Spaces based on most recent use.
* (enabled) When switching to an application, switch to a Space with open windows for the application.
  See also <https://apple.stackexchange.com/a/44801/33762>.

Desktop & Dock -> Hot Corners:

* (enabled) Top left: Desktop.
* (enabled) Top right: Mission Control.

Lock Screen:

* Turn display off on battery after: 20 minutes.
* Turn display off on power adapter after: 1 hour.
* (enabled) Require password after screen saver or display is turned off. After: "immediately".

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

### Terminal app

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

### Thunderbird

Accounts:

* Set up Fastmail.

Accounts -> Folders -> Archive options:

* When archiving messages, place them in: A single folder (default: Yearly archived folders).

Accounts -> Junk:

* (disable) Enable adaptive junk mail controls.

Settings > Composition:

* (disabled) Automatically add outgoing email addresses to my address book.

Settings -> Chat:

* (disabled) Let my contacts know that I am idle.
* (disabled) Send typing notifications.

Add-ons Manager / Extensions:

* [tbkeys-lite](https://addons.thunderbird.net/en-US/thunderbird/addon/tbkeys-lite/) ([source](https://github.com/wshanks/tbkeys))
  * `"#": "cmd:cmd_delete"`

Advanced Preferences:

* Change default sort order from Asc (1) to Desc (2).
  https://superuser.com/a/13551/164493
  `mailnews.default_sort_order=2`

* Make "Get new messages" do what it says. Change from `false` to `true`.
  https://superuser.com/a/108756/164493
  `mail.server.default.check_all_folders_for_new`

### VLC

VLC 3.0.18 (macOS 13.4 Ventura) fails to render subtitle text in
HiDPI (Retina) resolution. https://code.videolan.org/videolan/vlc/-/issues/27793

Workaround:
* Settings > Show All > Video > Output modules: "Mac OS X OpenGL video output"
