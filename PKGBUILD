# Maintainer: artemos <urtyomalyanov@gmail.com>
pkgname=loginom-community
pkgver=7.3.1
pkgrel=1
pkgdesc="Loginom Community Edition — low-code data analytics platform"
arch=('x86_64')
url="https://loginom.ru"
license=('custom:unfree')
depends=('acl' 'alsa-lib' 'at-spi2-core' 'avahi' 'brotli' 'bzip2' 'cairo' 'curl' 'dbus' 'double-conversion' 'duktape' 'e2fsprogs' 'expat' 'fontconfig' 'freetype2' 'fribidi' 'gcc-libs' 'gdk-pixbuf2' 'glib2' 'glibc' 'glycin' 'gmp' 'gnutls' 'graphite' 'gtk3' 'harfbuzz' 'icu' 'json-glib' 'karchive5' 'kauth5' 'kbookmarks5' 'kcodecs5' 'kcompletion5' 'kconfig5' 'kconfigwidgets5' 'kcoreaddons5' 'kcrash5' 'kdbusaddons5' 'keyutils' 'kglobalaccel5' 'kguiaddons5' 'ki18n5' 'kiconthemes5' 'kio5' 'kitemviews5' 'kjobwidgets5' 'krb5' 'kservice5' 'kwidgetsaddons5' 'kwindowsystem5' 'kxmlgui5' 'lcms2' 'leancrypto' 'libcap' 'libcloudproviders' 'libcups' 'libdatrie' 'libdrm' 'libepoxy' 'libffi' 'libglvnd' 'libidn2' 'libimobiledevice' 'libimobiledevice-glue' 'libnghttp2' 'libnghttp3' 'libp11-kit' 'libplist' 'libpng' 'libproxy' 'libpsl' 'libseccomp' 'libssh2' 'libtasn1' 'libthai' 'libunistring' 'libusbmuxd' 'libx11' 'libxau' 'libxcb' 'libxcomposite' 'libxcursor' 'libxdamage' 'libxdmcp' 'libxext' 'libxfixes' 'libxi' 'libxinerama' 'libxkbcommon' 'libxml2' 'libxrandr' 'libxrender' 'md4c' 'mesa' 'nettle' 'nspr' 'nss' 'openssl' 'pango' 'pcre2' 'pixman' 'qt5-base' 'qt5-svg' 'qt5-wayland' 'qt5-x11extras' 'solid5' 'sqlite' 'systemd-libs' 'tinysparql' 'util-linux-libs' 'wayland' 'xcb-util-keysyms' 'xz' 'zlib-ng-compat' 'zstd')
source=("loginom-community-7.3.1_linux.tar.gz::https://storage.yandexcloud.net/private-loginom-ru/LoginomCELinux/7.x/7.3/loginom-community-7.3.1_linux.tar.gz?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YCAJEUdCH7bkAv88YafPx0UvQ%2F20260226%2Fru-central1%2Fs3%2Faws4_request&X-Amz-Date=20260226T005713Z&X-Amz-Expires=259200&X-Amz-SignedHeaders=host&response-content-disposition=attachment&X-Amz-Signature=3a34d83554fb217b584492db092ad67442d1fdf75087a094358fdc729672314e")
sha256sums=('4041608b0d40d282d31d5c26129a1df9c67c6f8045e1b3b9e4aafcac9796327e')

prepare() {
  # Убедимся, что исполняемый файл имеет правильные права
  chmod +x "$srcdir/loginom-community/loginom"
}

package() {
 # Установка бинарника и файлов
  install -d "$pkgdir"/opt/loginom-community
  cp -r "$srcdir/loginom-community"/* "$pkgdir"/opt/loginom-community/
  rm "$pkgdir"/opt/loginom-community/install-shortcut.sh

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
