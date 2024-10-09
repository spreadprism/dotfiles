# dotfiles

## bootstrap
### Bash
```sh
curl -sS https://raw.githubusercontent.com/spreadprism/dotfiles/main/scripts/nexus.sh | bash && exec bash
```
### Zsh
```sh
curl -sS https://raw.githubusercontent.com/spreadprism/dotfiles/main/scripts/nexus.sh | bash -s -- --zsh && exec zsh
```
## Activate development profile
1. Need to auth with gh (SSH)
2. Run this command
```sh
git clone git@github.com:spreadprism/nvim.git ./profiles/development/.config/nvim && stow development
```
