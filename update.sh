#!/usr/bin/env bash
set -euo pipefail

# Получаем структуру
INFO_JSON=$(nix --extra-experimental-features 'nix-command flakes' develop --command python ./download-loginom.py --json)
echo "$INFO_JSON" > src.json.tmp

# Извлекаем данные
VERSION=$(jq -r '.version' src.json.tmp)
FACT_VERSION=$(jq -r '.fact_version' src.json.tmp)
LINUX_URL=$(jq -r '.linux' src.json.tmp)
WINDOWS_URL=$(jq -r '.windows' src.json.tmp)

# Скачиваем и хешируем Linux
TEMP_L=$(mktemp)
curl -L "$LINUX_URL" -o "$TEMP_L"
SHA256_LINUX_NIX=$(nix hash file --base32 "$TEMP_L")
SHA256_LINUX=$(sha256sum "$TEMP_L" | cut -d' ' -f1)
rm -f "$TEMP_L"

# Скачиваем и хешируем Windows
TEMP_W=$(mktemp)
curl -L "$WINDOWS_URL" -o "$TEMP_W"
SHA256_WINDOWS_NIX=$(nix hash file --base32 "$TEMP_W")
SHA256_WINDOWS=$(sha256sum "$TEMP_W" | cut -d' ' -f1)
rm -f "$TEMP_W"



# Формируем финальный src.json
cat > src.json <<EOF
{
  "version": "$VERSION",
  "fact_version": "$FACT_VERSION",
  "urls": {
    "linux": "$LINUX_URL",
    "windows": "$WINDOWS_URL"
  },
  "sha256_nix": {
    "linux": "$SHA256_LINUX_NIX",
    "windows": "$SHA256_WINDOWS_NIX"
  },
  "sha256": {
    "linux": "$SHA256_LINUX",
    "windows": "$SHA256_WINDOWS"
  }
}
EOF

rm -f src.json.tmp
echo "✅ Обновлено: src.json (версия $VERSION)"