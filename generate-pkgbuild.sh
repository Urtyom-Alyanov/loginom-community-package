#!/usr/bin/env bash
set -euo pipefail

# Проверяем наличие jq
if ! command -v jq &> /dev/null; then
  echo "❌ Требуется jq. Установите: sudo pacman -S jq"
  exit 1
fi

# Читаем src.json
SRC_JSON="./src.json"

if [ ! -f "$SRC_JSON" ]; then
  echo "❌ Файл $SRC_JSON не найден. Сначала запустите ./update.sh"
  exit 1
fi

VERSION=$(jq -r '.version' "$SRC_JSON")
URL=$(jq -r '.urls.linux' "$SRC_JSON")
SHA256=$(jq -r '.sha256.linux' "$SRC_JSON")

# Проверяем, что значения не пустые
if [[ -z "$VERSION" || -z "$URL" || -z "$SHA256" ]]; then
  echo "❌ Некорректные данные в src.json"
  exit 1
fi

# Подставляем в шаблон
sed \
  -e "s|@VERSION@|$VERSION|g" \
  -e "s|@URL@|$URL|g" \
  -e "s|@SHA256@|$SHA256|g" \
  PKGBUILD.in > PKGBUILD

echo "✅ PKGBUILD сгенерирован для версии $VERSION"