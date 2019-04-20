# Krinkle Dotfiles

## Install

**[Basic](hosts/basic/#readme)**
```bash
git clone https://github.com/Krinkle/dotfiles.git ~/.krinkle.dotfiles \
  && ~/.krinkle.dotfiles/hosts/basic/install
```

**[Primary](hosts/primary/#readme)**
```bash
git clone git@github.com:Krinkle/dotfiles.git ~/.krinkle.dotfiles \
  && ~/.krinkle.dotfiles/hosts/primary/install
```

## Screenshots

<img height="444" alt="Screenshot of the Terminal app" src="https://user-images.githubusercontent.com/156867/53701021-b59e3300-3df0-11e9-8132-d0a85e9f80c9.png">
<img height="380" alt="Screenshot of Git prompt" src="https://i.imgur.com/AGJ9uz1.png">

## FAQ

### Naming tabs?

See [**§ Terminal app (Mac)**](hosts/primary#terminal-app) for how to configure the naming of tabs.

### j-What?

The `j` command shown above is [Autojump](https://github.com/wting/autojump). It's available on Homebrew.

I recommend [Olivier Lacan's blog post](https://olivierlacan.com/posts/cd-is-wasting-your-time/) to learn more about how it works.

<a href="https://twitter.com/TimoTijhof/status/980558438055858176"><img alt="autojump example" height="85" src="https://user-images.githubusercontent.com/156867/53701187-69ec8900-3df2-11e9-81fe-ca1676dac361.jpg"></a>

### SSH Screen?

<img width="591" alt="Screenshot of GNU Screen" src="https://user-images.githubusercontent.com/156867/54076468-dc061780-42a3-11e9-9f56-42b57299bbc4.png">


See [`screenrc`](https://github.com/Krinkle/dotfiles/blob/e4bf32b5188c71c0d728aae0f9d80622d3ccf049/hosts/wmf/screenrc) and [`setscreentitle()`](https://github.com/Krinkle/dotfiles/blob/master/hosts/wmf/bashrc#L112-L123).

## Thanks

* [@cowboy](https://github.com/cowboy) ([dotfiles](https://github.com/cowboy/dotfiles))
* [@rtomayko](https://github.com/rtomayko) ([dotfiles](https://github.com/rtomayko/dotfiles))
* [@catrope](https://github.com/catrope)
* [@jakemcc](https://github.com/jakemcc) ([Last command run-time in prompt](http://jakemccrary.com/blog/2015/05/03/put-the-last-commands-run-time-in-your-bash-prompt/))
* [@mathiasbynens](https://github.com/mathiasbynens) ([dotfiles](https://github.com/mathiasbynens/dotfiles/blob/ef819d5fcd/.osx))
* [@ymendel](https://github.com/ymendel) ([dotfiles](https://github.com/ymendel/dotfiles/tree/0ff3906a98/osx))
