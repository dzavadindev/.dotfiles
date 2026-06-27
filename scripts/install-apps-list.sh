sudo pacman -S --needed --noconfirm  steam \
bat bitwarden bashtop discord fastfetch lua lua51 luarocks fzf \
obs-studio solaar vlc ffmpeg dolphin neovim matugen \
zsh kitty hyprland ttf-firacode-nerd greetd-tuigreet \
xdg-utils flameshot blueman xdg-desktop-portal-hyprland \
xdg-desktop-portal-gtk awww hyprpolkitagent cliphist \
unzip quickshell inotify-tools gnome-keyring git-delta \
eza

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
