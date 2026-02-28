#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="${HOME}/.config"

# --- 1. base system update & build tools --------------------------------
sudo pacman -Syu --needed --noconfirm base-devel git

# --- 2. rustup  ---------------------------------------------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# --- 3. ensure paru is present ------------------------------------------
if ! command -v paru >/dev/null 2>&1; then
    echo ">> installing the paru AUR helper…"
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
fi

# --- 4. shell -----------------------------------------------------------
git clone --depth=1 https://github.com/mattmc3/antidote.git $HOME/.antidote

[[ $SHELL != */zsh ]] && chsh -s /bin/zsh || true

# --- 5. symlink the configs into their place ----------------------------

# Get dbdm onto the system first
echo "Installing dbdm for dotfile management . . ."

DBDM_PATH="$HOME/Applications/dbdm/"
DBDM_GIT="git@github.com:dzavadindev/dbdm.git"
JUMP_BACK=$(pwd)

mkdir -p "$DBDM_PATH"
if [ -z "$(find $DBDM_PATH -mindepth 1 -maxdepth 1)" ]; then
    git clone -j 5 "$DBDM_GIT" "$DBDM_PATH"
    cd "$DBDM_PATH"
    cargo install --path .
    cd "$JUMP_BACK"
else
    echo "dbdm is already installed";
fi

# Make the sync happen
dbdm sync

# Put some basic wallpapers in
mkdir -p "${HOME}/Pictures/Wallpapers"
cp $DOTFILES/wpp/* ${HOME}/Pictures/Wallpapers

# --- 6. install scripts -------------------------------------------------
sudo install -Dm755 "$DOTFILES/scripts/powermenu.sh" /usr/local/bin/powermenu
sudo install -Dm755 "$DOTFILES/scripts/install-zen.sh" /usr/local/bin/install-zen
sudo install -Dm755 "$DOTFILES/scripts/load_noisetorch.sh" /usr/local/bin/load-noisetorch
sudo install -Dm755 "$DOTFILES/scripts/custom_krita_launucher.sh" /usr/local/bin/custom-krita-launcher

# --- 7. install Material Symbols ----------------------------------------
mkdir -p $HOME/.local/share/fonts/MaterialDesign/
cp "$DOTFILES/fonts/MaterialSymbolsRounded.ttf" "$HOME/.local/share/fonts/MaterialDesign/"

# --- 8. install Starship ------------------------------------------------
curl -sS https://starship.rs/install.sh | sh
ln -s "$DOTFILES/starship.toml" "$XDG_CONFIG_HOME"

# --- 9. apps and stuff --------------------------------------------------
sudo pacman -S --needed --noconfirm stlink steam arduino-cli \
arduino-language-server arm-none-eabi-gdb bat bitwarden \
bashtop discord fastfetch lua lua51 luarocks \
obs-studio solaar vlc ffmpeg dolphin neovim \
zsh kitty hyprland ttf-firacode-nerd greetd-tuigreet \
xdg-utils flameshot blueman xdg-desktop-portal-hyprland \
xdg-desktop-portal-gtk swww hyprpolkitagent cliphist unzip quickshell \

paru -S --needed --noconfirm opentabletdriver

QPWGRAPH_PATH="$HOME/Applications/qpwgraph/"
QPWGRAPH_GIT="git@github.com:rncbc/qpwgraph.git"
JUMP_BACK=$(pwd)

mkdir -p "$QPWGRAPH_PATH"
if [ -z "$(find $QPWGRAPH_PATH -mindepth 1 -maxdepth 1)" ]; then
    git clone -j 5 "$QPWGRAPH_GIT" "$QPWGRAPH_PATH"
    cd "$QPWGRAPH_PATH"
    cmake -B build
    cmake --build build --parallel 5
    sudo cmake --install build
    cd "$JUMP_BACK"
else
    echo "qpgraph is already installed";
fi

# --- 10. opencode  ------------------------------------------------------
curl -fsSL https://opencode.ai/install | bash

# --- 11. greetd ---------------------------------------------------------
if ! id greeter &>/dev/null; then
    sudo useradd -m -s /usr/bin/nologin greeter
fi
sudo rm -rf /etc/greetd/config.toml

sudo ln -sfn "$DOTFILES/greetd/config.toml" /etc/greetd
sudo systemctl try-reload-or-restart --now display-manager

# --- 12. NetworkManager ------------------------------------------------
sudo rm -rf /etc/NetworkManager/NetworkManager.conf
sudo ln -sfn "$DOTFILES/NetworkManager/NetworkManager.conf" /etc/NetworkManager/
sudo systemctl restart NetworkManager

sudo chmod +x "$DOTFILES/NetworkManager/dispatcher.d/90-captive-portal-browser.sh"
sudo ln -sfn "$DOTFILES/NetworkManager/dispatcher.d/90-captive-portal-browser.sh" /etc/NetworkManager/dispatcher.d/

# -----------------------------------------------------------------------

echo -e "\n✅  Setup complete. :)"
