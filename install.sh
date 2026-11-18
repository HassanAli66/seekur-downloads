#!/usr/bin/env bash
# Installs Seekur 0.2.0-beta.1 for the current user (no sudo needed).
#   curl -fsSL https://hassanali66.github.io/seekur-downloads/install.sh | bash
# or, after downloading seekur-linux.tar.gz next to this script:  bash install.sh
set -euo pipefail
URL="https://github.com/HassanAli66/seekur-downloads/releases/download/v0.2.0-beta.1/seekur-linux.tar.gz"
DEST="$HOME/.local/share/seekur-app"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || pwd)"
PKG="${SEEKUR_PACKAGE:-$HERE/seekur-linux.tar.gz}"
T="$(mktemp -d)"; trap 'rm -rf "$T"' EXIT
if [[ ! -f "$PKG" ]]; then echo "Downloading Seekur 0.2.0-beta.1…"; curl -fSL --progress-bar -o "$T/seekur.tar.gz" "$URL"; PKG="$T/seekur.tar.gz"; fi
echo "Installing to $DEST"
pkill -f "$DEST/Seekur" 2>/dev/null || true
rm -rf "$DEST"; mkdir -p "$DEST"
tar -xzf "$PKG" -C "$T"; cp -a "$T/seekur/." "$DEST/"
mkdir -p "$HOME/.local/share/applications" "$HOME/.config/autostart" "$HOME/.local/bin"
sed -e "s|@EXEC@|$DEST/Seekur|" -e "s|@ICON@|$DEST/seekur.png|" "$DEST/seekur.desktop" > "$HOME/.local/share/applications/seekur.desktop"
sed -e "s|@EXEC@|$DEST/Seekur --minimized|" -e "s|@ICON@|$DEST/seekur.png|" "$DEST/seekur.desktop" > "$HOME/.config/autostart/seekur.desktop"
ln -sf "$DEST/Seekur" "$HOME/.local/bin/seekur"
"$DEST/Seekur" --version >/dev/null && echo "Seekur $(cat "$DEST/VERSION") is installed. Open it from your apps menu, or run: seekur"
echo "It starts by itself when you sign in. To uninstall: rm -rf $DEST ~/.local/share/applications/seekur.desktop ~/.config/autostart/seekur.desktop ~/.local/bin/seekur"
