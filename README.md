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
git submodule update --init --recursive
```
3. Stow the profile
```sh
stow development
```
