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
    dunst greetd-tuigreet xdg-utils grim slurp flameshot blueman
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk swww
    hyprpolkitagent cliphist unzip
)

missing=($(comm -23 <(printf '%s\n' "${pac_pkgs[@]}" | sort) \
    <(pacman -Qq | sort)))
if ((${#missing[@]})); then
    echo ">> installing pacman packages: ${missing[*]}"
    sudo pacman -S --needed --noconfirm "${missing[@]}"
fi

yay -S --needed --noconfirm quickshell

# --- 4. shell ----------------------------------------------------------
[[ $SHELL != */zsh ]] && chsh -s /bin/zsh || true

<<<<<<< HEAD
# --- 5. symlink the configs into their place ---------------------------
rm -rf "${HOME}/.gitconfig"
rm -rf "${HOME}/.zshrc"
rm -rf "${HOME}/.tmux.conf"
=======
# --- 6. symlink the configs into their place ---------------------------
rm -f "${HOME}/.gitconfig"
rm -f "${HOME}/.zshrc"
rm -f "${HOME}/.tmux.conf"
>>>>>>> 4a4d928887c1381b798cc365f43fd0aaa45006eb

rm -f "${XDG_CONFIG_HOME}/starship.toml"
rm -rf "${XDG_CONFIG_HOME}/dunst"
rm -rf "${XDG_CONFIG_HOME}/fuzzel"
rm -rf "${XDG_CONFIG_HOME}/hypr"
rm -rf "${XDG_CONFIG_HOME}/kitty"
rm -rf "${XDG_CONFIG_HOME}/nvim"
rm -rf "${XDG_CONFIG_HOME}/flameshot"
rm -rf "${XDG_CONFIG_HOME}/quickshell"

ln -sfn "$DOTFILES/.gitconfig" "${HOME}/.gitconfig"
ln -sfn "$DOTFILES/.zshrc" "${HOME}/.zshrc"
ln -sfn "$DOTFILES/.tmux.conf" "${HOME}/.tmux.conf"

ln -sfn "$DOTFILES/dunst" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/fuzzel" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/hypr" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/kitty" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/nvim" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/flameshot" "${XDG_CONFIG_HOME}"
ln -sfn "$DOTFILES/quickshell" "${XDG_CONFIG_HOME}"

mkdir -p "${HOME}/Pictures/Wallpapers"
cp $DOTFILES/wpp/* ${HOME}/Pictures/Wallpapers

# --- 6. install scripts ------------------------------------------------
sudo install -Dm755 "$DOTFILES/scripts/powermenu.sh" /usr/local/bin/powermenu
sudo install -Dm755 "$DOTFILES/scripts/bluetooth-menu.sh" /usr/local/bin/bluetooth-menu
sudo install -Dm755 "$DOTFILES/scripts/install-zen.sh" /usr/local/bin/install-zen

# --- 7. install Material Symbols ---------------------------------------
mkdir -p $HOME/.local/share/fonts/MaterialDesign/
cp "$DOTFILES/fonts/MaterialSymbolsRounded.ttf" "$HOME/.local/share/fonts/MaterialDesign/"

<<<<<<< HEAD
# --- 8. install Oh My Posh ---------------------------------------------
curl -s https://ohmyposh.dev/install.sh | bash -s
mkdir -p $HOME/.oh-my-posh/themes
cp $DOTFILES/oh-my-posh/custom_theme.omp.json $HOME/.oh-my-posh/themes
=======
# --- 9. install Starship ---------------------------------------------
curl -sS https://starship.rs/install.sh | sh
ln -s "$DOTFILES/starship.toml" "$XDG_CONFIG_HOME"
>>>>>>> 4a4d928887c1381b798cc365f43fd0aaa45006eb

echo -e "\n✅  Setup complete. Log out to start Hyprland with greetd."

# --- 9. greetd ---------------------------------------------------------
if ! id greeter &>/dev/null; then
    sudo useradd -m -s /usr/bin/nologin greeter
fi
sudo rm -rf /etc/greetd
sudo ln -sfn "$DOTFILES/greetd" /etc
sudo systemctl disable display-manager
sudo systemctl enable --now greetd.service

# --- 10. rustup  -------------------------------------------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
