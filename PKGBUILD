# PKGBUILD.in
pkgname=loginom-community
pkgver=7.2.9
pkgrel=1
pkgdesc="Loginom Community Edition — low-code data analytics platform"
arch=('x86_64')
url="https://loginom.ru"
license=('custom:unfree')
depends=('glibc' 'gtk3' 'libgl' 'libx11' 'libxss' 'nss' 'alsa-lib' 'libxcomposite' 'libxdamage')
source=("loginom-community-7.2.9_linux.tar.gz::https://dl.loginom.ru/LoginomCE/loginom-community-7.2.9_linux.tar.gz?Expires=1761785626@URL@Signature=nXu60TXlTXdujt8v1mRc~V5zS9J1WtS0M7t7M0dE0Huq1qriELFGTah9a6h~kst0CASC~ipIRWQ2OnSqmQoTxaeuIFn2pgAT1sIMuc73ZsXJtKQ8W8ANVeY1Gj-XDazFqPsX-K7xdcgq1MNGGg6geEQ4jkT3DAYquzGfvBR8a8031J8HYTZyOVpWfeUBcsnUhVUPWp3a7W~qD8e~3OS0jtOr5~~KtIF1udKlgyps3rAKHS-cn~6LQDGNkBmVUqxy0ht8RMU4YOZPsHgRsWoaFGUX-GZxnVkz-WMMNhRaDKGe10lXXQP0SyHBJXJ7O2KIBswsc~om3VPk4dJac7n3Ow__@URL@Key-Pair-Id=APKAJLCDRQRLK2QURM3Q")
sha256sums=('af4e3725fd05e519fe135194347527ce20615d044bc1424220cdedcf0626293c')

prepare() {
  # Убедимся, что исполняемый файл имеет правильные права
  chmod +x "$srcdir/loginom-community/loginom"
}

package() {
  # Установка бинарника и файлов
  install -d "$pkgdir"/opt/loginom
  cp -r "$srcdir/loginom-community"/* "$pkgdir"/opt/loginom/

  # Символическая ссылка в PATH
  install -d "$pkgdir"/usr/bin
  ln -s /opt/loginom/loginom "$pkgdir"/usr/bin/loginom

  # Иконка
  install -d "$pkgdir"/usr/share/icons/hicolor/256x256/apps
  install -Dm644 "$pkgdir"/opt/loginom/loginom.png \
    "$pkgdir"/usr/share/icons/hicolor/256x256/apps/loginom.png

  # .desktop файл
  install -d "$pkgdir"/usr/share/applications
  cat > "$pkgdir"/usr/share/applications/loginom.desktop <<EOF
[Desktop Entry]
Name=Loginom Community
Comment=Low-code data analytics platform
Exec=/opt/loginom/loginom %U
Icon=loginom
Terminal=false
Type=Application
Categories=Science;DataVisualization;Development;
StartupWMClass=Loginom
MimeType=
Keywords=analytics;data;low-code;
EOF

  # Лицензия
  install -Dm644 "$pkgdir"/opt/loginom/LICENSE.txt \
    "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}