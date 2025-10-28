# PKGBUILD.in
pkgname=loginom-community
pkgver=7.2.9
pkgrel=1
pkgdesc="Loginom Community Edition — low-code data analytics platform"
arch=('x86_64')
url="https://loginom.ru"
license=('custom:unfree')
depends=('glibc' 'gtk3' 'libgl' 'libx11' 'libxss' 'nss' 'alsa-lib' 'libxcomposite' 'libxdamage')
source=("loginom-community-7.2.9_linux.tar.gz::https://dl.loginom.ru/LoginomCE/loginom-community-7.2.9_linux.tar.gz?Expires=1761871564@URL@Signature=e6KD0Ex8adatwOETiz0In7kDIiEmZH52vfEwmfuch3pke6lOb5bO3LZFJp1QBmxLaR~ImQ6W8av33gLaI0wwEvN4ZBWlRpheTFeC0r9t-IoWcmPRcmo1F1EXlfBDuolks1RieuFCzlAtgupS66YhMp5jofyiSgoRxO6TKdYDkBiNcBiRiILVuEuNLbJvxK1xX-vb-H6dKQHzbru6D-CnSlYXOvDcIsTXubw-R7RQu04weFYVIq-ue3WaZaStbUPKoCbXImsyhKgBx7JYLhgjLjeJryIOt7kO7SpDCIbSXKv1ZGFnP-NrUiTW2Ot9TS3lh1UXhNIUOYPk4Ym5e0VJyQ__@URL@Key-Pair-Id=APKAJLCDRQRLK2QURM3Q")
sha256sums=('af4e3725fd05e519fe135194347527ce20615d044bc1424220cdedcf0626293c')

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
