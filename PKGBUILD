# PKGBUILD.in
pkgname=loginom-community
pkgver=7.3.0
pkgrel=1
pkgdesc="Loginom Community Edition — low-code data analytics platform"
arch=('x86_64')
url="https://loginom.ru"
license=('custom:unfree')
depends=('glibc' 'gtk3' 'libgl' 'libx11' 'libxss' 'nss' 'alsa-lib' 'libxcomposite' 'libxdamage')
source=("loginom-community-7.3.0_linux.tar.gz::https://storage.yandexcloud.net/private-loginom-ru/LoginomCE/loginom-community-7.3.0-rc_linux.tar.gz?X-Amz-Algorithm=AWS4-HMAC-SHA256@URL@X-Amz-Credential=YCAJEUdCH7bkAv88YafPx0UvQ%2F20251107%2Fru-central1%2Fs3%2Faws4_request@URL@X-Amz-Date=20251107T004846Z@URL@X-Amz-Expires=259200@URL@X-Amz-SignedHeaders=host@URL@response-content-disposition=attachment@URL@X-Amz-Signature=a7289ac6d799d0219d005bde520f1202372c4fa071c97230889260bbfc06b9c7")
sha256sums=('a802fbe5864dc418d03efdefa06225eb2b27ad2ddf3b6fbad6cfc29b2a672835')

prepare() {
  # Убедимся, что исполняемый файл имеет правильные права
  chmod +x "$srcdir/loginom-community/loginom"
}

package() {
 # Установка бинарника и файлов
  install -d "$pkgdir"/opt/loginom-community
  cp -r "$srcdir/loginom-community"/* "$pkgdir"/opt/loginom-community/

  # Символическая ссылка в PATH
  install -d "$pkgdir"/usr/bin
  ln -s /opt/loginom-community/loginom "$pkgdir"/usr/bin/loginom-community

  # Иконки (для MIME-типа и приложения)
  install -d "$pkgdir"/usr/share/icons/hicolor/256x256/apps
  install -Dm644 "$pkgdir"/opt/loginom-community/loginom.png \
    "$pkgdir"/usr/share/icons/hicolor/256x256/apps/loginom.png

  install -d "$pkgdir"/usr/share/icons/hicolor/128x128/mimetypes
  install -Dm644 "$pkgdir"/opt/loginom-community/loginom-lgp.png \
    "$pkgdir"/usr/share/icons/hicolor/128x128/mimetypes/loginom-lgp.png

  # MIME-тип
  install -d "$pkgdir"/usr/share/mime/packages
  cat > "$pkgdir"/usr/share/mime/packages/application-x-loginom-lgp.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-loginom-lgp">
    <comment>Loginom Package</comment>
    <glob pattern="*.lgp"/>
    <icon name="loginom-lgp"/>
  </mime-type>
</mime-info>
EOF

  # .desktop файл
  install -d "$pkgdir"/usr/share/applications
  cat > "$pkgdir"/usr/share/applications/loginom.desktop <<EOF
[Desktop Entry]
Name=Loginom Community
Comment=Low-code data analytics platform
Exec=/opt/loginom-community/loginom %f
Icon=loginom
Terminal=false
Type=Application
Categories=Science;DataVisualization;Development;
StartupWMClass=Loginom
MimeType=application/x-loginom-lgp;
Keywords=analytics;data;low-code;lgp;
EOF

  # Лицензия
  install -Dm644 "$pkgdir"/opt/loginom-community/LICENSE.txt \
    "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}
