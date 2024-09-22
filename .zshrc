# Init commands with input (y/n, password etc) before here
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# consts
HDD_PATH="/mnt/hdd/data"
export HDD_PATH

# exports
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
# --- fzf
export FZF_BASE="/usr/bin/fzf"
# --- protontricks
export PROTON_VERSION="Proton 9.0"
# --- dotnet
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools


#env vars
ZSH_THEME="powerlevel10k/powerlevel10k"
HIST_STAMPS="dd/mm/yyyy"

#plgins
plugins=(git fzf)

DISABLE_FZF_AUTO_COMPLETION=false
DISABLE_FZF_KEY_BINDINGS=false

source $ZSH/oh-my-zsh.sh

# preffered editor
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
else
   export EDITOR='vim'
fi

# aliases
alias nv="nvim"
alias zshconf="nvim ~/.zshrc"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias cmdhelp="$HOME/.local/bin/bat $HDD_PATH/command-tools.md"
alias chcmdhelp="nvim $HDD_PATH/command-tools.md"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias dotfiles=/usr/bin/git --git-dir=/home/dan/.dotfiles --work-tree=/home/dan
