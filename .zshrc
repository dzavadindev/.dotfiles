export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/flutter-sdk/flutter/bin:/usr/local/android-studio/android-studio:$HOME/dotnet:$HOME/.dotnet/tools
export POSH_THEMES_PATH="$HOME/.oh-my-posh/themes"
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export ANDROID_HOME="/home/dan/Android/Sdk"
export DOTNET_ROOT=$HOME/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export STEAMAPPS="$HOME/.local/share/Steam/steamapps"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=nl_NL.UTF-8
export LC_TIME=nl_NL.UTF-8

CASE_SENSITIVE="true"

zstyle ':omz:update' frequency 13

COMPLETION_WAITING_DOTS="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(git fzf)

source $ZSH/oh-my-zsh.sh

alias v="nvim"

alias zshconf="nvim $HOME/.zshrc"
alias tmuxconf="nvim $HOME/.tmux.conf"
alias kittyconf="nvim $HOME/.config/kitty/kitty.conf"

alias sourcez="source ~/.zshrc"
alias dotfiles="cd ~/.dotfiles"

alias clearvimswap='rm -v ~/.local/state/nvim/swap/*'

eval "$(oh-my-posh init zsh --config "$POSH_THEMES_PATH/theme.omp.json")"

bindkey -r "^S"
bindkey "^S" "no_op"
