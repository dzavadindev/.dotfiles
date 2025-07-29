#!/bin/bash

# Installing untilities **********************************

tools=(git yay nvim tmux zsh kitty sway swaybg swayimg swayidle waybar fuzzel ttf-firacode-nerd dunst greetd-tuigreet xdg-utils grim slurp)
missing=()

for tool in "${tools[@]}"; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "$tool is not installed."
    missing+=("$tool")
  fi
done

if [ ${#missing[@]} -gt 0 ]; then
  echo "Installing missing packages: ${missing[*]}"
  sudo pacman -S --needed "${missing[@]}"
else
  echo "All required tools are installed."
fi

aur=(swaylock-effects)
echo "Installing missing AUR packages"
sudo yay -S --no-confirm "${aur[@]}"

ln -s "${HOME}/.dotfiles/.electron-conf" "${HOME}/.electron-flags.conf"
ln -s "${HOME}/.dotfiles/.gitconfig" "${HOME}/.gitconfig"
ln -s "${HOME}/.dotfiles/.zshrc" "${HOME}/.zshrc"
ln -s "${HOME}/.dotfiles/.tmux.conf" "${HOME}/.tmux.conf"

ln -s "${HOME}/.dotfiles/dunst" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/nvim" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/kitty" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/sway" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/waybar" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/fuzzel" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/xdg-desktop-portal-wlr" "${XDG_CONFIG_HOME}"
ln -s "${HOME}/.dotfiles/swaylock" "${XDG_CONFIG_HOME}"

sudo rm -rf /etc/greetd
sudo ln -s "${HOME}/.dotfiles/greetd" "/etc"

# Setting up the environment **********************************

# Installing and setting the default browser
sudo chmod u+x "${HOME}/.dotfiles/install-zen.sh"
./install-zen.sh

# Setting the deafult shell to ZSH
if ! [[ "$SHELL" =~ zsh ]]; then
  echo "Default shell is not zsh. Changing it..."
  chsh -s /bin/zsh
else
  echo "Default shell is already zsh."
fi

# Creating the greeter user and enabling the login manager
sudo useradd -m -s /usr/bin/nologin greeter
sudo systemctl enable greetd
