# --------------------- EXPORTS ---------------------------
export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/flutter-sdk/flutter/bin:/usr/local/android-studio/android-studio:$HOME/dotnet:$HOME/.dotnet/tools:$HOME/.opencode/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"
export DOTFILES_DIR="$HOME/.dotfiles"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export ANDROID_HOME="/home/dan/Android/Sdk"
export DOTNET_ROOT=$HOME/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export ARDUINO_CONFIG_FILE='/home/dan/.arduino15/arduino-cli.yaml'

export STEAMAPPS="$HOME/.local/share/Steam/steamapps"

export VISUAL="nvim"
export EDITOR="nvim"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=nl_NL.UTF-8
export LC_TIME=nl_NL.UTF-8

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --------------------- ANTIDOTE --------------------------

# Source antidote
source $HOME/.antidote/antidote.zsh
antidote bundle < $HOME/.zsh_plugins.txt > $HOME/.zsh_plugins.zsh
source $HOME/.zsh_plugins.zsh

# Init plugins
zsh_plugins=$HOME/.zsh_plugins

[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

fpath=(/path/to/antidote/functions $fpath)
autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

source ${zsh_plugins}.zsh

# --------------------- ALIASES ---------------------------
alias v="nvim"
alias zshconf="nvim $HOME/.zshrc"
alias tmuxconf="nvim $HOME/.tmux.conf"
alias kittyconf="nvim $HOME/.config/kitty/kitty.conf"
alias acli="arduino-cli"
alias sourcez="source ~/.zshrc"
alias dotfiles="cd ~/.dotfiles"
alias clearvimswap='rm -v ~/.local/state/nvim/swap/*'
alias zephyr="source $HOME/zephyrproject/zephyr/zephyr-env.sh"

# --------------------- EVALS -----------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(luarocks --lua-version=5.1 path)"

# --------------------- BINDS -----------------------------
# bindkey -r "^S"
# bindkey "^S" "no_op"

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# --------------------- OTHER SOURCES ---------------------
. "$HOME/.cargo/env"
. "$HOME/export-esp.sh"

# --------------------- OPTIONS ---------------------------
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
