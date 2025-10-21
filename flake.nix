{
  description = "Loginom Community Edition for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        srcInfo = builtins.fromJSON (builtins.readFile ./src.json);
      in
      {
        packages.loginom-community = pkgs.stdenv.mkDerivation {
          pname = "loginom-community";
          version = srcInfo.version;

          src = pkgs.fetchurl {
            url = srcInfo.urls.linux;
            sha256 = srcInfo.sha256_nix.linux;
            name = "loginom-community-${srcInfo.version}_linux.tar.gz";
          };

          dontUnpack = false;

          installPhase = ''
            runHook preInstall

            mkdir -p $out/opt/loginom
            cp -r ./* $out/opt/loginom/

            mkdir -p $out/bin
            makeWrapper $out/opt/loginom/loginom $out/bin/loginom \
                --prefix LD_LIBRARY_PATH : ${with pkgs; lib.makeLibraryPath [
                  stdenv.cc.cc.lib
                  glib
                  nss
                  nspr
                  alsa-lib
                  dbus
                  atkmm
                  at-spi2-core
                  gtk3
                  libx11
                  xorg.libXcomposite
                  xorg.libXdamage
                  libxext
                  libxfixes
                  xorg.xrandr
                  libxkbcommon
                  systemd
                  expat
                ]}
          
            mkdir -p $out/share/icons/hicolor/256x256/apps
            cp $out/opt/loginom/loginom.png $out/share/icons/hicolor/256x256/apps/loginom.png

            # .desktop файл
            mkdir -p $out/share/applications
            cat > $out/share/applications/loginom.desktop <<EOF
[Desktop Entry]
Name=Loginom Community
Comment=Low-code data analytics platform
Exec=$out/opt/loginom/loginom %U
Icon=loginom
Terminal=false
Type=Application
Categories=Science;DataVisualization;Development;
StartupWMClass=Loginom
Keywords=analytics;data;low-code;
EOF

            # Лицензия
            mkdir -p $out/share/licenses/loginom-community
            cp $out/opt/loginom/LICENSE.txt $out/share/licenses/loginom-community/LICENSE

            runHook postInstall
          '';

          nativeBuildInputs = [ pkgs.makeWrapper ];

          meta = with pkgs.lib; {
            description = "Loginom Community — low-code data analytics platform";
            homepage = "https://loginom.ru";
            license = licenses.unfree;
            platforms = [ "x86_64-linux" ];
          };
        };

        defaultPackage = self.packages.${system}.loginom-community;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            python313
            playwright
            python313Packages.playwright
            python313Packages.requests
            curl
            nix
            jq
          ];
          shellHook = ''
            echo "Development shell for updating Loginom download URL" >&2
            export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
            export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true
          '';
        };
      });
}
