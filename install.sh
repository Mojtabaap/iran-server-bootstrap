#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

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
apt update -y || echo "⚠️ apt update failed"

install_package () {
  PKG=$1
  echo "📦 Installing $PKG ..."
  apt install -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" \
    $PKG \
    && echo "✅ $PKG installed" \
    || echo "❌ $PKG skipped (error)"
}

for pkg in "${PACKAGES[@]}"; do
  install_package "$pkg"
done

if command -v cron >/dev/null 2>&1; then
  systemctl enable cron 2>/dev/null
  systemctl start cron 2>/dev/null
fi

echo "🎉 All done!"
