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
alias cd="z"

# --------------------- EVALS -----------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(luarocks --lua-version=5.1 path)"

# --------------------- OTHER SOURCES ---------------------
. "$HOME/.cargo/env"
. "$HOME/export-esp.sh"

# --------------------- OPTIONS ---------------------------
setopt AUTO_CD
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# --------------------- ANTIDOTE ---------------------
source $HOME/.antidote/antidote.zsh

zsh_plugins=$HOME/.zsh_plugins

# If ~/.zsh_plugins.txt does NOT exist, create an empty one.
[[ -f "${zsh_plugins}.txt" ]] || touch "${zsh_plugins}.txt"

fpath=("$HOME/.antidote/functions" "${fpath[@]}")

autoload -Uz antidote

if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle < "${zsh_plugins}.txt" >| "${zsh_plugins}.zsh"
fi

# Source all plugins in the end
source "${zsh_plugins}.zsh"

# --------------------- PLUGINS and CONFIG --------------------

# -------> Highlighting
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=default'

# Commands / shell words
ZSH_HIGHLIGHT_STYLES[command]='fg=#85c1dc'         # blue
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#74c7ec'         # sky
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'   # mauve
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ea76cb'           # pink
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'

# Files / paths / globbing
ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af'            # yellow
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f9e2af'

# Strings and quotes
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'  # peach
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#94e2d5' # teal
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#94e2d5'

# -------> Incremental History
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# --------------------- BINDS -----------------------------

# Ctrl+Right/Left to jump word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Incremental History 
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
