#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="${HOME}/.config"

# --- 1. base system update & build tools ------------------------------
sudo pacman -Syu --needed --noconfirm base-devel git

# --- 2. ensure yay is present -----------------------------------------
if ! command -v yay >/dev/null 2>&1; then
    echo ">> installing the yay AUR helper…"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
fi

# --- 3. install repo & Wayland toolchain ------------------------------
pac_pkgs=(
    neovim tmux zsh kitty hyprland fuzzel ttf-firacode-nerd
    greetd-tuigreet xdg-utils grim slurp flameshot blueman
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swww
    hyprpolkitagent cliphist unzip quickshell
)

missing=($(comm -23 <(printf '%s\n' "${pac_pkgs[@]}" | sort) \
    <(pacman -Qq | sort)))
if ((${#missing[@]})); then
    echo ">> installing pacman packages: ${missing[*]}"
    sudo pacman -S --needed --noconfirm "${missing[@]}"
fi

yay -S --needed --noconfirm opentabletdriver

# --- 4. shell ----------------------------------------------------------
[[ $SHELL != */zsh ]] && chsh -s /bin/zsh || true

# Together with OMZ
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# --- 5. symlink the configs into their place ---------------------------
rm -rf "${HOME}/.gitconfig"
rm -rf "${HOME}/.zshrc"
rm -rf "${HOME}/.tmux.conf"

rm -rf "${XDG_CONFIG_HOME}/starship.toml"
rm -rf "${XDG_CONFIG_HOME}/fuzzel"
rm -rf "${XDG_CONFIG_HOME}/hypr"
rm -rf "${XDG_CONFIG_HOME}/kitty"
rm -rf "${XDG_CONFIG_HOME}/nvim"
rm -rf "${XDG_CONFIG_HOME}/flameshot"
rm -rf "${XDG_CONFIG_HOME}/quickshell"
rm -rf "${XDG_CONFIG_HOME}/yazi"
rm -rf "${XDG_CONFIG_HOME}/hamr"

ln -sfn "$DOTFILES/.gitconfig" "${HOME}/.gitconfig"
ln -sfn "$DOTFILES/.zshrc" "${HOME}/.zshrc"
ln -sfn "$DOTFILES/.tmux.conf" "${HOME}/.tmux.conf"
ln -sfn "$DOTFILES/.zephyrrc" "${HOME}/.zephyrrc"

ln -sfn "$DOTFILES/yazi" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/fuzzel" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/hypr" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/kitty" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/nvim" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/flameshot" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/quickshell" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/hamr" "${XDG_CONFIG_HOME}"

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
sudo pacman -S --needed --noconfirm stlink steam arduino-cli arduino-language-server arm-none-eabi-gdb bat bitwarden bashtop discord fastfetch lua lua51 luarocks obs-studio solaar vlc ffmpeg jq poppler fd ripgrep fzf zoxide resvg imagemagick dolphin

# TODO: install pipewire graph GUI here ......

sudo systemctl enable --now bluetooth.service

# --- 11. rustup  -------------------------------------------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# --- 12. greetd ---------------------------------------------------------
if ! id greeter &>/dev/null; then
    sudo useradd -m -s /usr/bin/nologin greeter
fi
sudo rm -rf /etc/greetd

sudo ln -sfn "$DOTFILES/greetd" /etc
if systemctl is-active --quiet display-server; then
	sudo systemctl disable --now display-manager
fi

sudo systemctl enable --now greetd.service

echo -e "\n✅  Setup complete. Log out to start Hyprland with greetd."
