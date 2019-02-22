# The Dotfiles

## Install

**Read only**
```bash
git clone https://github.com/Krinkle/dotfiles.git ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init
```

**Read and write**
```bash
git clone git@github.com:Krinkle/dotfiles.git ~/.krinkle.dotfiles && ~/.krinkle.dotfiles/bin/init
```

## Screenshots

<img height="444" alt="Screenshot of the Terminal app" src="https://user-images.githubusercontent.com/156867/53701021-b59e3300-3df0-11e9-8132-d0a85e9f80c9.png">

<img height="380" alt="Screenshot of Git prompt" src="https://i.imgur.com/AGJ9uz1.png">

## FAQ

### Naming tabs?

See [**§ Terminal app (Mac)**](hosts/KrinkleMac#terminal-app) for how to configure the naming of tabs.

### j-What?

The `j` command shown above is [Autojump](https://github.com/wting/autojump). It's available on Homebrew.

I recommend [Olivier Lacan's blog post](https://olivierlacan.com/posts/cd-is-wasting-your-time/) to learn more about how it works.

<a href="https://twitter.com/TimoTijhof/status/980558438055858176"><img alt="autojump example" height="85" src="https://user-images.githubusercontent.com/156867/53701187-69ec8900-3df2-11e9-81fe-ca1676dac361.jpg"></a>

### SSH Screen?

Tabs inside GNU Screen over ssh ([config](https://github.com/Krinkle/dotfiles/blob/master/hosts/wmf/bashrc.sh#L113-L137)):

<a href="https://i.imgur.com/alHXz3c.png"><img height="240" src="https://i.imgur.com/alHXz3c.png" title="Screenshot of tabs inside gnuscreen"></a>

## Thanks

* [@cowboy](https://github.com/cowboy) ([cowboy/dotfiles](https://github.com/cowboy/dotfiles))
* [@rtomayko](https://github.com/rtomayko) ([rtomayko/dotfiles](https://github.com/rtomayko/dotfiles))
* [@catrope](https://github.com/catrope)
* [@jakemcc](https://github.com/jakemcc) ([Last command run-time in prompt](http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/))
