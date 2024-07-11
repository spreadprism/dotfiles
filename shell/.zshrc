# ------------------------------------------------------------
# INFO: profiler
# ------------------------------------------------------------
zmodload zsh/zprof
# ------------------------------------------------------------
# INFO: Binaries
# ------------------------------------------------------------
BIN_DIR=$HOME/bin
export PATH="$PATH:$BIN_DIR"
EGET_PATH=$BIN_DIR/eget
if [ ! -f $EGET_PATH ]; then
  LAST_PWD=$PWD
  cd $BIN_DIR
  curl -sS https://zyedidia.github.io/eget.sh | sh
  cd $LAST_PWD
  clear
fi
# ------------------------------------------------------------
if ! command -v starship &> /dev/null; then
  eget starship/starship --to=~/bin -a="starship-x86_64-unknown-linux-gnu.tar.gz"
fi
# ------------------------------------------------------------
if ! command -v bob &> /dev/null; then
  eget MordechaiHadad/bob --to=~/bin -a="bob-linux-x86_64.zip"
fi
# ------------------------------------------------------------
if ! command -v rg &> /dev/null; then
  eget BurntSushi/ripgrep --to=~/bin
fi
# ------------------------------------------------------------
if ! command -v fzf &> /dev/null; then
  eget junegunn/fzf --to=~/bin
fi
# ------------------------------------------------------------
if ! command -v jq &> /dev/null; then
  eget jqlang/jq --to=~/bin -a="jq-linux64"
fi
# ------------------------------------------------------------
if ! command -v jqp &> /dev/null; then
  eget noahgorstein/jqp --to=~/bin
fi
# ------------------------------------------------------------
if ! command -v bat &> /dev/null; then
  eget sharkdp/bat --to=~/bin -a="bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz"
fi
# ------------------------------------------------------------
if ! command -v eza &> /dev/null; then
  eget eza-community/eza --to=~/bin -a="eza_x86_64-unknown-linux-gnu.tar.gz"
fi
# ------------------------------------------------------------
if ! command -v lazygit &> /dev/null; then
  eget jesseduffield/lazygit --to=~/bin
fi
# ------------------------------------------------------------
if ! command -v zoxide &> /dev/null; then
  eget ajeetdsouza/zoxide --to=~/bin
fi
# ------------------------------------------------------------
# INFO: Zinit
# ------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  echo "Installing zinit"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
# ------------------------------------------------------------
# INFO: Paths
# ------------------------------------------------------------
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
# ------------------------------------------------------------
if [ -d "/var/lib/flatpak/exports/bin" ]; then
  export PATH="$PATH:/var/lib/flatpak/exports/bin"
fi
# ------------------------------------------------------------
if [ -d "/opt/google-cloud-cli/" ]; then
  export CLOUDSDK_ROOT_DIR=/opt/google-cloud-cli
  export CLOUDSDK_PYTHON=$(which python)
  export CLOUDSDK_PYTHON_ARGS='-S -W ignore'
  export PATH=$CLOUDSDK_ROOT_DIR/bin:$PATH
  export GOOGLE_CLOUD_SDK_HOME=$CLOUDSDK_ROOT_DIR
fi
# ------------------------------------------------------------
if command -v pnpm &> /dev/null
then
  export PNPM_HOME="/home/avalon/.local/share/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi
# ------------------------------------------------------------
if command -v pipx &> /dev/null
then
  export PATH="$PATH:$HOME/.local/bin"
fi
# ------------------------------------------------------------
if command -v gem &> /dev/null
then
  export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin/"
fi
# ------------------------------------------------------------
if command -v go &> /dev/null
then
  export GOPATH="$HOME/.go"
  export GOBIN="$GOPATH/bin"
fi
# ------------------------------------------------------------
if command -v cargo &> /dev/null
then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
# ------------------------------------------------------------
if command -v nvim &> /dev/null
then
  export NVIM_LISTEN_ADDRESS='/tmp/nvim.socket'
fi
# ------------------------------------------------------------
# INFO: Zsh plugins
# ------------------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
# ------------------------------------------------------------
ZVM_VI_ESCAPE_BINDKEY=';;'
ZVM_VI_SURROUND_BINDKEY='s-prefix'
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_VI_HIGHLIGHT_BACKGROUND=#283457
ZVM_VI_HIGHLIGHT_FOREGROUND=#c0caf5
ZVM_VI_EDITOR='nvim'
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
# ------------------------------------------------------------
export FZF\_DEFAULT\_OPTS='--bind=shift-tab:up,tab:down'
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion)
# ------------------------------------------------------------
zinit light qoomon/zsh-lazyload # INFO: Cannot be lazyloaded
zinit ice wait lucid
zinit snippet OMZP::sudo
# ------------------------------------------------------------
if [[ $(cat /etc/*-release | grep -i '^ID=' | cut -d'=' -f2) = 'arch' ]]
then
  zinit snippet OMZP::archlinux
fi
# ------------------------------------------------------------
zinit ice wait lucid
zinit light joshskidmore/zsh-fzf-history-search
zinit ice wait lucid
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::command-not-found
zinit ice wait lucid
zinit snippet OMZP::dirhistory
# ------------------------------------------------------------
if command -v poetry &> /dev/null
then
  zinit ice wait lucid
  zi ice as"completion"
  zinit snippet OMZP::poetry
fi
# ------------------------------------------------------------
if command -v docker &> /dev/null
then
  zinit ice wait lucid
  zi ice as"completion"
  zinit snippet OMZP::docker
  zinit ice wait lucid
  zi ice as"completion"
  zinit snippet OMZP::docker-compose
fi
# ------------------------------------------------------------
if command -v kubectl &> /dev/null
then
  zinit ice wait lucid
  zi ice as"completion"
  zinit snippet OMZP::kubectl
fi
# ------------------------------------------------------------
if command -v gcloud &> /dev/null
then
  zinit ice wait lucid
  zi ice as"completion"
  zinit snippet OMZP::gcloud
fi
# ------------------------------------------------------------
# INFO: Completion
# ------------------------------------------------------------
autoload -Uz compinit && compinit
zinit cdreplay -q
eval "$(dircolors -b)" # Enables LS_COLORS
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# ------------------------------------------------------------
# INFO: Command history
# ------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
# ------------------------------------------------------------
# INFO: Utility functions
# ------------------------------------------------------------
conda_activate_current_dir () {
  env_dir=$HOME/miniconda3/envs/
  current_directory_name="${PWD##*/}"
  if [ -d "$env_dir/$current_directory_name"_env ]; then
    source ~/miniconda3/bin/activate "$current_directory_name"_env
  elif [ -d "$env_dir/$current_directory_name" ]; then
    source ~/miniconda3/bin/activate "$current_directory_name"
  fi
}
previous_dir () {
  dirhistory_back
  zle .accept-line
}
next_dir () {
  dirhistory_forward
  zle .accept-line
}
# ------------------------------------------------------------
# INFO: Widgets
# ------------------------------------------------------------
zle -N previous_dir
zle -N next_dir
# ------------------------------------------------------------
# INFO: Aliases
# ------------------------------------------------------------
alias v='nvim'
alias nvim-rocks='NVIM_APPNAME=nvim-rocks nvim'
alias vlr='NVIM_APPNAME=lazyrocks nvim'
alias zz='cd -'
alias ls='eza'
alias cat='bat'
alias lg='lazygit'
alias activate='conda_activate_current_dir'
alias deactivate='conda deactivate'
# ------------------------------------------------------------
# INFO: Keybinds
# ------------------------------------------------------------
function zvm_after_lazy_keybindings() {
  # INFO: These keybindings are set only in normal mode
  zvm_bindkey vicmd 'H' beginning-of-line
  zvm_bindkey vicmd 'L' end-of-line
}
function zvm_after_init() {
  # INFO: These keybindings are set for insert mode
  bindkey '<M-a>' autosuggest-execute
  bindkey '^O' previous_dir
  bindkey '^P' next_dir
}
# ------------------------------------------------------------
# INFO: Lazy loading
# ------------------------------------------------------------
init_conda() {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniconda3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<
}
init_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}
# ------------------------------------------------------------
lazyload nvm -- 'init_nvm'
lazyload nvim -- 'init_nvm'
lazyload conda -- 'init_conda'
# ------------------------------------------------------------
# INFO: WSL
# ------------------------------------------------------------
if [[ $(grep -i Microsoft /proc/version) ]]; then
  export IN_WSL="true"
  export BROWSER=wslview
  alias wsl='wsl.exe'
  alias explorer='explorer.exe .'
  alias pws='powershell.exe'
fi
# ------------------------------------------------------------
# INFO: Initialize
# ------------------------------------------------------------
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
# ------------------------------------------------------------
# INFO: Tmux
# ------------------------------------------------------------
__tmux_available () {
[[ -x "$(command -v tmux)" ]]
}

__tmux_running () {
  tmux run 2> /dev/null
}

__inside_tmux () {
  [[ ! -z "$TMUX" ]]
}

__interactive_shell () {
  [[ -n "$PS1" ]]
}

__tmux_session_to_attach () {
  for session_number in $(tmux ls -F "#{session_name}:#{?session_attached,attached,not-attached}" | jq -R 'split(":") | select(try(.[0] | tonumber //false)) | select(.[1] == "not-attached") | .[0] | tonumber' | sort); do
    echo $session_number
    return
  done
}

__tmux_new_session () {
  expected_number=0
  for __session_number in $(tmux ls -F "#{session_name}" | jq -R "select(try(. | tonumber // false)) | tonumber" | sort); do
    if [[ $__session_number != $expected_number ]]; then
      echo $expected_number
      return
    fi
    expected_number=$((expected_number+1))
  done
  echo $expected_number
}

if __interactive_shell && ! __inside_tmux; then
  if __tmux_running; then
    session_number=$(__tmux_session_to_attach)
    if [[ -n $session_number ]]; then
      exec tmux attach-session -t $session_number
    fi
    session_number=$(__tmux_new_session)
    echo $session_number
    exec tmux new -s $session_number -c "$PWD"
  else
    tmux new-session -d -s base
    exec tmux new -s 0 -c "$PWD"
  fi
fi
