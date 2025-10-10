#!/bin/bash

set -e

ZEN_URL="https://github.com/zen-browser/desktop/releases/latest/download/zen.linux-x86_64.tar.xz"
INSTALL_DIR="$HOME/zen-browser"
DESKTOP_FILE="$HOME/.local/share/applications/zen-browser.desktop"
EXEC_PATH="$INSTALL_DIR/zen"
ZEN_ICON_URL="https://github.com/zen-browser/branding/blob/main/Official/SVG/Zen-Dark-Coral.svg"

echo "[+] Downloading Zen Browser..."
mkdir -p "$INSTALL_DIR"
curl -L "$ZEN_URL" | tar -xJ -C "$INSTALL_DIR" --strip-components=1
curl -L "$ZEN_ICON_URL" --output "$INSTALL_DIR/icons/icon.svg"

echo "[+] Creating desktop entry..."

mkdir -p "$HOME/.local/share/applications"

cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=Zen Browser
Exec=$EXEC_PATH %U
Icon=$INSTALL_DIR/icons/icon.svg
Type=Application
StartupNotify=true
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/about;x-scheme-handler/unknown;
EOF

chmod +x "$DESKTOP_FILE"

echo "[+] Updating desktop database..."
update-desktop-database "$HOME/.local/share/applications/"

echo "[+] Setting Zen Browser as default handler for http/https..."
xdg-mime default zen-browser.desktop x-scheme-handler/http
xdg-mime default zen-browser.desktop x-scheme-handler/https

echo "[✓] Zen Browser installed and set as default."
