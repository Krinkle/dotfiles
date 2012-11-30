# Krinkle: The Dotfiles

## Install

```bash
$ git clone git://github.com/Krinkle/dotfiles.git ~/.krinkle.dotfiles
$ ~/.krinkle.dotfiles/init.sh
```

### KrinkleMac
```bash
$ cp ~/.krinkle.dotfiles/hosts/KrinkleMac/templates/gitconfig ~/.gitconfig
$ sudo ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/php.ini /etc/php.ini
$ sudo ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/apache-krinkle.dev.conf /etc/apache2/other/krinkle.conf
$ ln -s ~/.krinkle.dotfiles/hosts/KrinkleMac/dnsmasq.conf /usr/local/etc/dnsmasq.conf
```
