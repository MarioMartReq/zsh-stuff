# Mario's random drawer for oh-my-zsh

Here I maintain a collection of all the random stuff I use with ZSH.

```bash
┌─(~/git-personal/zsh-stuff)──────────────────────────────────(zucchini-nano-0032:monitoring 🤔 Fri Feb 11 16:48:54 WET 2022)─┐
└─( on main ✭)──> git commit -m "Oasis version updated for #28 store"
```

## [.zshrc](.zshrc) file

Main file for ZSH. It is not optmized by any means (it might require some changes to work in a different computer).

## [mario.zsh-theme](mario.zsh-theme) file

Mario's custom ZSH theme. It is a fork from Jonathan theme, but contains some modifications:

- It displays info about the kubernetes context and namespace.
- Complete date with time zone.
- An emoji that can be changed 😌.

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
