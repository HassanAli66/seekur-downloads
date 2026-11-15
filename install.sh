#!/usr/bin/env bash
# Seekur installer for Ubuntu 22.04 / 24.04.
#
#   curl -fsSL https://<download-site>/install.sh | sudo bash
#   sudo ./packaging/linux/install.sh --from-source .      # from a checkout of this repository
#
# Installs to /opt/seekur, keeps data in /var/lib/seekur, runs as the "seekur" user under systemd,
# and restarts automatically after crashes and power cuts.
set -euo pipefail

PREFIX=/opt/seekur
DATA=/var/lib/seekur
PORT="${SEEKUR_PORT:-8080}"
LICENSING_URL="${SEEKUR_LICENSING_URL:-https://seekur.vercel.app}"
LICENCE_PUBLIC_KEY="${SEEKUR_LICENCE_PUBLIC_KEY:-uY-Zqd6gPr4I5lrBGDWjcgzTxnBpGyZZOBiwB9eqMww}"
case "$LICENSING_URL" in @*) LICENSING_URL="https://licence.seekur.example" ;; esac
case "$LICENCE_PUBLIC_KEY" in @*) LICENCE_PUBLIC_KEY="" ;; esac
SOURCE=""
PACKAGE="${SEEKUR_PACKAGE:-}"   # local seekur-linux.tar.gz (tests); otherwise downloaded
RELEASE_URL="${SEEKUR_RELEASE_URL:-https://github.com/HassanAli66/seekur-downloads/releases/download/v0.1.0-beta.2}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from-source) SOURCE="$(cd "$2" && pwd)"; shift 2 ;;
    --licensing-url) LICENSING_URL="$2"; shift 2 ;;
    *) echo "Unknown option $1"; exit 1 ;;
  esac
done

say() { printf '\n\033[1;35m▸\033[0m %s\n' "$*"; }
fail() { printf '\n\033[1;31m✗ %s\033[0m\n' "$*"; exit 1; }

[[ $EUID -eq 0 ]] || fail "Run with sudo."
. /etc/os-release
[[ "${ID:-}" == "ubuntu" ]] || echo "Warning: tested on Ubuntu; continuing on ${PRETTY_NAME:-unknown}."

say "Installing system packages"
apt-get update -qq
apt-get install -y -qq python3 python3-venv python3-pip ffmpeg curl ca-certificates >/dev/null

say "Creating the seekur user and folders"
id seekur >/dev/null 2>&1 || useradd --system --home "$DATA" --shell /usr/sbin/nologin seekur
mkdir -p "$PREFIX" "$DATA"
chown -R seekur:seekur "$DATA"

say "Installing Seekur"
python3 -m venv "$PREFIX/venv"
"$PREFIX/venv/bin/pip" install -q --upgrade pip
if [[ -z "$SOURCE" ]]; then
  WORK="$(mktemp -d)"
  if [[ -n "$PACKAGE" ]]; then cp "$PACKAGE" "$WORK/seekur-linux.tar.gz"
  else curl -fsSL "$RELEASE_URL/seekur-linux.tar.gz" -o "$WORK/seekur-linux.tar.gz"; fi
  tar -xzf "$WORK/seekur-linux.tar.gz" -C "$WORK"
  SOURCE="$WORK/seekur"
  WEB="$SOURCE/web"
else
  WEB="$SOURCE/apps/web/dist"
fi
[[ -d "$WEB" ]] || fail "Dashboard not built: (cd apps/web && npm install && npm run build)"
"$PREFIX/venv/bin/pip" install -q "$SOURCE/packages/core" opencv-python-headless onnxruntime tqdm
"$PREFIX/venv/bin/pip" install -q --no-deps rtmlib   # its own requirements pull a second, larger OpenCV
rm -rf "$PREFIX/web" && cp -r "$WEB" "$PREFIX/web"

if command -v nvidia-smi >/dev/null 2>&1; then
  say "NVIDIA driver found — enabling GPU acceleration"
  "$PREFIX/venv/bin/pip" install -q onnxruntime-gpu || echo "GPU runtime unavailable; using CPU."
fi

IP="$(hostname -I 2>/dev/null | awk '{print $1}')"
cat > /etc/seekur.env <<EOF
SEEKUR_DATA_DIR=$DATA
SEEKUR_PORT=$PORT
SEEKUR_PUBLIC_URL=http://${IP:-localhost}:$PORT
SEEKUR_LICENSING_URL=$LICENSING_URL
SEEKUR_LICENCE_PUBLIC_KEY=$LICENCE_PUBLIC_KEY
SEEKUR_WEB_DIST=$PREFIX/web
SEEKUR_MODELS_DIR=$DATA/models
EOF

say "Registering background services"
for svc in api worker; do
  cat > "/etc/systemd/system/seekur-$svc.service" <<EOF
[Unit]
Description=Seekur $svc
After=network-online.target
Wants=network-online.target
$( [[ $svc == worker ]] && echo "After=seekur-api.service" )

[Service]
User=seekur
EnvironmentFile=/etc/seekur.env
WorkingDirectory=$DATA
ExecStart=$PREFIX/venv/bin/seekur-$svc
Restart=always
RestartSec=3
WatchdogSec=0

[Install]
WantedBy=multi-user.target
EOF
done
systemctl daemon-reload
systemctl enable --now seekur-api seekur-worker >/dev/null

say "Checking this computer"
sudo -u seekur env SEEKUR_DATA_DIR=$DATA "$PREFIX/venv/bin/seekur" hardware || true

for _ in $(seq 1 30); do curl -fs "http://127.0.0.1:$PORT/api/status" >/dev/null && break; sleep 1; done

printf '\n\033[1;32m✓ Seekur is running.\033[0m\n'
printf '  Open \033[1mhttp://%s:%s\033[0m from any computer or phone on this network to finish setup.\n\n' "${IP:-localhost}" "$PORT"
