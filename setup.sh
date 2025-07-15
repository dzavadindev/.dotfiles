#!/bin/bash

tools=(git nvim tmux zsh kitty)
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

if ! [[ "$SHELL" =~ zsh ]]; then
	echo "Default shell is not zsh. Changing it..."
	chsh -s /bin/zsh
else
	echo "Default shell is already zsh."
fi

ln -s "${HOME}/.dotfiles/.gitconfig" "${HOME}/.gitconfig"
ln -s "${HOME}/.dotfiles/.zshrc" "${HOME}/.zshrc"
ln -s "${HOME}/.dotfiles/nvim" "${HOME}/.config/nvim"
ln -s "${HOME}/.dotfiles/.tmux.conf" "${HOME}/.tmux.conf"
ln -s "${HOME}/.dotfiles/kitty" "${HOME}/.config/kitty"
