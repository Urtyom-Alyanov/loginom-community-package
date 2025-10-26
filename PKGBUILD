# PKGBUILD.in
pkgname=loginom-community
pkgver=7.2.9
pkgrel=1
pkgdesc="Loginom Community Edition — low-code data analytics platform"
arch=('x86_64')
url="https://loginom.ru"
license=('custom:unfree')
depends=('glibc' 'gtk3' 'libgl' 'libx11' 'libxss' 'nss' 'alsa-lib' 'libxcomposite' 'libxdamage')
source=("loginom-community-7.2.9_linux.tar.gz::https://dl.loginom.ru/LoginomCE/loginom-community-7.2.9_linux.tar.gz?Expires=1761699108@URL@Signature=FyvXQeeLBpVSTmo0MmF54twQKPeV7nCaVlMpG5WlD0DcxsNzXXLRduHRCPzcxwsbvo5nYDwJoz5YgQ~xasd7jZ-fLGvmsQXLFaA6SY5vA-UDLnbo2IeTF18Qk7IFsNqwfiTSGmlzX2GAiWxG6JPKJi-WiAUU78rC8vM~C4YTXG7ArD7iCLVkpyJwpRHQex9aDOkn2xArwx3a0BsSE6cq0AzjWvW-gN3358d~No8ZE~PBnioQ5rj6pCvbwXEfVwu6jVd1l3bfVNCwUAjjT9igWZDGVt-tabD9sustGBv6ZLFVA0~SWuYZVXBEu700VXlaRlASSHjVGcH~BK8EScRZNg__@URL@Key-Pair-Id=APKAJLCDRQRLK2QURM3Q")
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