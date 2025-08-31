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
    rustup neovim tmux zsh kitty hyprland fuzzel ttf-firacode-nerd
    dunst greetd-tuigreet xdg-utils grim slurp flameshot blueman gtk-launch
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swww
    hyprpolkitagent cliphist
)

missing=($(comm -23 <(printf '%s\n' "${pac_pkgs[@]}" | sort) \
    <(pacman -Qq | sort)))
if ((${#missing[@]})); then
    echo ">> installing pacman packages: ${missing[*]}"
    sudo pacman -S --needed --noconfirm "${missing[@]}"
fi

yay -S --needed --noconfirm bzmenu quickshell

# --- 4. greetd ---------------------------------------------------------
if ! id greeter &>/dev/null; then
    sudo useradd -m -s /usr/bin/nologin greeter
fi
sudo ln -sfn "$DOTFILES/greetd" /etc/greetd
sudo systemctl enable --now greetd.service

# --- 5. shell ----------------------------------------------------------
[[ $SHELL != */zsh ]] && chsh -s /bin/zsh || true

# --- 6. symlink the configs into their place ---------------------------
$DOTFILES
ln -s "$DOTFILES/.gitconfig" "${HOME}/.gitconfig"
ln -s "$DOTFILES/.zshrc" "${HOME}/.zshrc"
ln -s "$DOTFILES/.tmux.conf" "${HOME}/.tmux.conf"

ln -s "$DOTFILES/dunst" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/fuzzel" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/hyprland" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/kitty" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/nvim" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/quickshell" "${XDG_CONFIG_HOME}"
ln -s "$DOTFILES/flameshot" "${XDG_CONFIG_HOME}"

mkdir -p "${HOME}/Pictures/Wallpapers"
cp "$DOTFILES/wpp/*" "${HOME}/Pictures/Wallpapers"

# --- 7. install scripts ------------------------------------------------
install -Dm755 "$DOTFILES/scripts/powermenu.sh" /usr/local/bin/powermenu
install -Dm755 "$DOTFILES/scripts/bluetooth-menu.sh" /usr/local/bin/bluetooth-menu
install -Dm755 "$DOTFILES/scripts/install-zen.sh" /usr/local/bin/install-zen

# --- 8. install Material Symbols ---------------------------------------
cp "$DOTFILES/fonts/MaterialSymbolsRounded.ttf" "$HOME/.local/share/fonts/MaterialDesign/"

echo -e "\n✅  Setup complete. Log out to start Hyprland with greetd."
