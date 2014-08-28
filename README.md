# Krinkle: The Dotfiles

## Install

### Read only
```bash
git clone git://github.com/Krinkle/dotfiles.git ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init
```

### Read+Write access
```bash
git clone git@github.com:Krinkle/dotfiles.git ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init
```

### Read only (WMF)
```bash
# Bastion
git clone git://github.com/Krinkle/dotfiles.git ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init-wmf

# Elsewhere
git clone krinkle@fenari:.krinkle.dotfiles ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init-wmf
```

## Screenshots

![Screenshot of main view and navigation](http://i.imgur.com/YAIdnsy.png)

![Screenshot of git interaction](http://i.imgur.com/AGJ9uz1.png)

## FAQ

### Naming tabs?

You can name your tabs using the Inspector (`⌘ + I`) whilst in a Terminal tab:

<a href="http://i.imgur.com/qAAwPxL.png"><img src="http://i.imgur.com/qAAwPxL.png" height="333" title="Screenshot of Tab Inspector in Terminal.app"></a>

### SSH Screen?

Tabs inside GNU Screen over ssh ([config](https://github.com/Krinkle/dotfiles/blob/master/hosts/wmf/bashrc.sh#L113-L137)):

<a href="http://i.imgur.com/alHXz3c.png"><img src="http://i.imgur.com/alHXz3c.png" title="Screenshot of tabs inside gnuscreen"></a>

## Thanks

* [@cowboy](https://github.com/cowboy) ([cowboy/dotfiles](https://github.com/cowboy/dotfiles))
* [@rtomayko](https://github.com/rtomayko) ([rtomayko/dotfiles](https://github.com/rtomayko/dotfiles))
* [@catrope](https://github.com/catrope)
