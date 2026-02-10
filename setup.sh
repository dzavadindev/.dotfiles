#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="${HOME}/.config"

# --- 1. base system update & build tools ------------------------------
sudo pacman -Syu --needed --noconfirm base-devel git

# --- 2. ensure paru is present -----------------------------------------
if ! command -v paru >/dev/null 2>&1; then
    echo ">> installing the paru AUR helper…"
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
fi

sudo pacman -S --needed --noconfirm \
neovim tmux zsh kitty hyprland fuzzel ttf-firacode-nerd \
greetd-tuigreet xdg-utils grim slurp flameshot blueman \
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
swww hyprpolkitagent cliphist unzip quickshell \

paru -S --needed --noconfirm opentabletdriver

# --- 4. shell ----------------------------------------------------------
[[ $SHELL != */zsh ]] && chsh -s /bin/zsh || true

# --- 5. symlink the configs into their place ---------------------------
# TODO: This D E M O L I S H E S everything :D 
# But there must be a better way. For some reason all dotfiles 
# managers are weird. DotBot looks the most adequate of 
# them all. Maybe i'll just write my own tbh.
rm -rf "${HOME}/.gitconfig"
rm -rf "${HOME}/.zshrc"
rm -rf "${HOME}/.tmux.conf"
rm -rf "${XDG_CONFIG_HOME}/starship.toml"

rm -rf "${XDG_CONFIG_HOME}/opencode"
rm -rf "${XDG_CONFIG_HOME}/fuzzel"
rm -rf "${XDG_CONFIG_HOME}/hypr"
rm -rf "${XDG_CONFIG_HOME}/kitty"
rm -rf "${XDG_CONFIG_HOME}/nvim"
rm -rf "${XDG_CONFIG_HOME}/flameshot"
rm -rf "${XDG_CONFIG_HOME}/quickshell"
rm -rf "${XDG_CONFIG_HOME}/hamr"
rm -rf "${XDG_CONFIG_HOME}/qtengine"

# Put repo config files in
ln -sfn "$DOTFILES/.gitconfig" "${HOME}/.gitconfig"
ln -sfn "$DOTFILES/.zshrc" "${HOME}/.zshrc"
ln -sfn "$DOTFILES/.tmux.conf" "${HOME}/.tmux.conf"
ln -sfn "$DOTFILES/.zephyrrc" "${HOME}/.zephyrrc"
ln -sfn "$DOTFILES/starship.toml" "${HOME}/starship.toml"

ln -sfn "$DOTFILES/opencode" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/fuzzel" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/hypr" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/kitty" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/nvim" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/flameshot" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/quickshell" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/hamr" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/qtengine" "${XDG_CONFIG_HOME}"

mkdir -p "${HOME}/Pictures/Wallpapers"
cp $DOTFILES/wpp/* ${HOME}/Pictures/Wallpapers

# --- 6. install scripts ------------------------------------------------
sudo install -Dm755 "$DOTFILES/scripts/powermenu.sh" /usr/local/bin/powermenu
sudo install -Dm755 "$DOTFILES/scripts/install-zen.sh" /usr/local/bin/install-zen
sudo install -Dm755 "$DOTFILES/scripts/load_noisetorch.sh" /usr/local/bin/load-noisetorch
sudo install -Dm755 "$DOTFILES/scripts/custom_krita_launucher.sh" /usr/local/bin/custom-krita-launcher

# --- 7. install Material Symbols ---------------------------------------
mkdir -p $HOME/.local/share/fonts/MaterialDesign/
cp "$DOTFILES/fonts/MaterialSymbolsRounded.ttf" "$HOME/.local/share/fonts/MaterialDesign/"

# --- 8. install Starship ---------------------------------------------
curl -sS https://starship.rs/install.sh | sh
ln -s "$DOTFILES/starship.toml" "$XDG_CONFIG_HOME"

# --- 9. apps and stuff ----------------------------------------------
sudo pacman -S --needed --noconfirm stlink steam arduino-cli arduino-language-server arm-none-eabi-gdb bat bitwarden bashtop discord fastfetch lua lua51 luarocks obs-studio solaar vlc ffmpeg dolphin

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

sudo systemctl enable --now bluetooth.service

# --- 11. rustup  -------------------------------------------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# --- 12. opencode  -------------------------------------------------------
curl -fsSL https://opencode.ai/install | bash

# --- 13. greetd ---------------------------------------------------------
if ! id greeter &>/dev/null; then
    sudo useradd -m -s /usr/bin/nologin greeter
fi
sudo rm -rf /etc/greetd/config.toml

sudo ln -sfn "$DOTFILES/greetd/config.toml" /etc/greetd
sudo systemctl try-reload-or-restart --now display-manager

# --- 14. NetworkManager ---------------------------------------------------------
sudo rm -rf /etc/NetworkManager/NetworkManager.conf
sudo ln -sfn "$DOTFILES/NetworkManager/NetworkManager.conf" /etc/NetworkManager/
sudo systemctl restart NetworkManager

sudo chmod +x "$DOTFILES/NetworkManager/dispatcher.d/90-captive-portal-browser.sh"
sudo ln -sfn "$DOTFILES/NetworkManager/dispatcher.d/90-captive-portal-browser.sh" /etc/NetworkManager/dispatcher.d/

# -----------------------------------------------------------------------
echo -e "\n✅  Setup complete. :)"
