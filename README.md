# zshPlug - my ZSH Plugin Manager

ZSH Plugin manager heavily based on [zap](https://github.com/zap-zsh/zap) but tweaked a bit to suit my needs.

## Install

```sh
sh <(curl -s https://raw.githubusercontent.com/Atlas34/zshPlug/master/install.sh)
```
    
## Example usage

Add the following to your `.zshrc`

```sh
# Plugin examples
use "zap-zsh/fzf"
use "zsh-users/zsh-autosuggestions"
use "zsh-users/zsh-syntax-highlighting"

# Theme Example: Powerlevel10k
use "romkatv/powerlevel10k"
```

## Commands

zshPlug provided commands for updating and cleaning up plugins

- To update plugins or zshPlug:

  ```sh
  zshPlug update
  ```

  or

  ```sh
  zshPlug -u
  ```

- To remove plugins you are no longer using:

  ```sh
  zshPlug clean
  ```

  or

  ```sh
  zshPlug -c
  ```

## Uninstall

```sh
rm -rf ~/.local/share/zshPlugin
```

Also, remove the following contained in your .zshrc


```sh
[[ -f "$HOME/.local/share/zshPlug/zshPlug.zsh" ]] && source "$HOME/.local/share/zshPlug/zshPlug.zsh"
```

## Notes

Will only work with plugins that are named conventionally, this means that the plugin file is the same name as the repository with the following extensions:

- `.plugin.zsh`
- `.zsh`
- `.zsh-theme`

For example: [vim](https://github.com/zap-zsh/vim)
