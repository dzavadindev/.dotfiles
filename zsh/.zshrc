# External config
# -----------------------------
[[ -f "$XDG_CONFIG_HOME/shell/vars"    ]] && source "$XDG_CONFIG_HOME/shell/vars"
[[ -f "$XDG_CONFIG_HOME/shell/aliases" ]] && source "$XDG_CONFIG_HOME/shell/aliases"

# Zsh init
# -----------------------------
zmodload zsh/complist

autoload -Uz compinit colors
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

compinit
colors

# Prompt / tools
# -----------------------------
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(luarocks --lua-version=5.1 path)"

# History
# -----------------------------
HISTDIR="$XDG_CACHE_HOME/zsh"
mkdir -p "$HISTDIR"

HISTFILE="$HISTDIR/history"
HISTSIZE=1000000
SAVEHIST=1000000

# Shell behavior
# -----------------------------
setopt SHARE_HISTORY        # share command history between all running zsh sessions
setopt EXTENDED_HISTORY     # record timestamps and command duration in history
setopt HIST_IGNORE_DUPS     # do not record a command if it is identical to the previous one
setopt HIST_IGNORE_ALL_DUPS # remove older duplicates when a command is added again
setopt HIST_IGNORE_SPACE    # commands starting with a space are not saved to history
setopt HIST_FIND_NO_DUPS    # skip duplicate entries when searching history
setopt HIST_REDUCE_BLANKS   # remove extra whitespace before saving commands to history

setopt AUTO_CD              # typing a directory name automatically runs 'cd'
setopt AUTO_MENU            # pressing TAB twice starts a completion menu
setopt AUTO_PARAM_SLASH     # add a trailing '/' when completing directories
setopt NO_CASE_GLOB         # filename globbing is case-insensitive
setopt NO_CASE_MATCH        # pattern matching in conditions is case-insensitive
setopt GLOB_DOTS            # include hidden files (dotfiles) in glob matches
setopt EXTENDED_GLOB        # enable advanced globbing operators like ^ ~ and #
setopt INTERACTIVE_COMMENTS # allow '#' comments in interactive commands

unsetopt PROMPT_SP          # do not auto-remove trailing spaces before the prompt

stty stop undef             # prevent Ctrl-S from freezing terminal

# Completion
# -----------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;239;38;5;223'

# fzf
# -----------------------------
source <(fzf --zsh)

# Keybinds
# -----------------------------
bindkey $'^[[1;5D' backward-word
bindkey $'^[[1;5C' forward-word

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

bindkey '^r' fzf-history-widget

# Syntax highlighting
# -----------------------------
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=default'

# commands / shell words
ZSH_HIGHLIGHT_STYLES[command]='fg=#85c1dc'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#74c7ec'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ea76cb'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a6e3a1'

# files / paths / globbing
ZSH_HIGHLIGHT_STYLES[path]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f9e2af'

# options / quoted args
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#94e2d5'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#94e2d5'
