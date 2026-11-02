# XDG base directories
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_CONFIG_DIRS:=/etc/xdg/menus}"

# move zsh config into XDG
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# basic environment
export EDITOR="nvim"
export TERMINAL="kitty"

# application directories
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# X11 related configs
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export XPROFILE="$XDG_CONFIG_HOME/x11/xprofile"
export XRESOURCES="$XDG_CONFIG_HOME/x11/xresources"

# GTK
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"

# fzf
export FZF_DEFAULT_OPTS="--style minimal --color 16 --layout=reverse --height 30% --preview='bat -p --color=always {}'"
export FZF_CTRL_R_OPTS="--style minimal --color 16 --info inline --no-sort --no-preview"

# colored man pages
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export LESS="R --use-color -Dd+r -Du+b"

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# Opencode
export PATH=/home/dan/.opencode/bin:$PATH

# Cargo bin
export PATH="$CARGO_HOME/bin:$PATH"

# GO apps
export PATH="$HOME/go/bin:$PATH"

# Discord Canary Build
export PATH="/opt/discord-canary:$PATH"

# Source cargo env
[[ -f "$CARGO_HOME/env" ]] && . "$CARGO_HOME/env"
