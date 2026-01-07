#!/bin/bash

PACKAGES=(
  tzdata
  python3
  python3-pip
  python3-venv
  cron
  wget
  unzip
  tar
  jq
)

echo "🔄 Updating package list..."
timeout 15s apt update -y || echo "⚠️ apt update skipped (timeout)"

install_package () {
  PKG=$1
  echo "📦 Installing $PKG ..."
  timeout 15s apt install -y $PKG \
    && echo "✅ $PKG installed" \
    || echo "❌ $PKG skipped (timeout or error)"
}

for pkg in "${PACKAGES[@]}"; do
  install_package "$pkg"
done

if command -v cron >/dev/null 2>&1; then
  systemctl enable cron 2>/dev/null
  systemctl start cron 2>/dev/null
fi

echo "🎉 Done."
