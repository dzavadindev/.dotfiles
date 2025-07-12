export PATH=$PATH:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/flutter-sdk/flutter/bin:/usr/local/android-studio/android-studio:$HOME/dotnet:$HOME/.dotnet/tools
export POSH_THEMES_PATH="$HOME/.oh-my-posh/themes"
export ZSH="$HOME/.oh-my-zsh"

export ANDROID_HOME="/home/dan/Android/Sdk"
export DOTNET_ROOT=$HOME/dotnet
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export STEAMAPPS="$HOME/.local/share/Steam/steamapps"

export XDG_CONFIG_HOME="$HOME/.config"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_NUMERIC=nl_NL.UTF-8
export LC_TIME=nl_NL.UTF-8

CASE_SENSITIVE="true"

zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias zshconfig="vim $HOME/.zshrc"
alias docker="sudo docker"
alias v="nvim"
alias dotfiles="cd ~/.dotfiles"
alias sourcez="source ~/.zshrc"

# eval "$(oh-my-posh init zsh --config "$POSH_THEMES_PATH/amro.omp.json")"
eval "$(oh-my-posh init zsh --config "$POSH_THEMES_PATH/honukai.omp.json")"
