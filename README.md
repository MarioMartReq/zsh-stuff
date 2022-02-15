# Mario's random drawer for oh-my-zsh

Here I maintain a collection of the random stuff I use with ZSH.

```bash
┌─(~/git-personal/zsh-stuff)──────────────────────────(☸️  personal-cluster:monitoring 🐍 base 📅 Mon Feb 14 14:53:30 -01 2022)─┐
└─( on main)──> changetheme
Current theme:
ZSH_THEME="mario"
Changing to: robbyrussell
+ kubectl completion zsh
+ kubectl completion zsh

➜  zsh-stuff git:(main) ✗ git clone git@github.com:MarioMartReq/zsh-stuff.git
```

## [.zshrc](.zshrc) file

Main file for ZSH. It is not optmized by any means (it might require some changes to work in a different computer).

- Plugins:
  - git
  - vscode
  - kubectl
  - kubectx (custom)
  - zsh-syntax-highlighting (custom)
  - zsh-autosuggestions (custom)
- Aliases:
  - `changetheme`: goes from the custom theme to "bobbyrussell", a much simpler one.

## [mario.zsh-theme](mario.zsh-theme) file

Mario's custom ZSH theme. It is a fork from Jonathan theme, but contains some modifications:

- It displays info about the **kubernetes context and namespace** (thanks to [kube-ps1](https://github.com/jonmosco/kube-ps1)).
- It also shows which **conda env** is currently active.
- Complete date with time zone.
- Some emojis to separate the different info sections 😌.

To copy it into the `zsh`themes folder, run:

```bash
cp mario.mario.zsh-theme ~/.oh-my-zsh/themes/mario.zsh-theme
```

## Custom plugin commands for easy install.

```bash
brew update
brew install kube-ps1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone --recursive https://github.com/unixorn/kubectx-zshplugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/kubectx
cd ~/.oh-my-zsh/custom/plugins/kubectx/
git submodule
init git submodule update
```
