{
  lib,
  unzip,
  autoPatchelfHook,
  stdenv,
  fetchurl,
  xorg,
  libgbm,
  cairo,
  libudev-zero,
  libxkbcommon,
  nspr,
  nss,
  libcupsfilters,
  pango,
  at-spi2-core,
  gtk3,
  gcc-unwrapped,
  alsa-lib,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "helium";
  version = "0.8.4.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";
    sha256 = "1iza4ldb31k1338l6xrsaaz3hx2ww0b7w66a4qplvrr5xhcp1z9k";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    libgbm
    cairo
    pango
    libudev-zero
    libxkbcommon
    nspr
    nss
    libcupsfilters
    at-spi2-core
    gtk3
    gcc-unwrapped
    alsa-lib
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  sourceRoot = "helium-${version}-x86_64_linux";

  installPhase = ''
        runHook preInstall

        # Create directory structure
        mkdir -p $out/lib/helium
        mkdir -p $out/bin
        mkdir -p $out/share/applications
        mkdir -p $out/share/pixmaps

        # Copy all application files to lib
        cp -r . $out/lib/helium/

        # Make the helium binary executable
        chmod +x $out/lib/helium/helium

        # Create a proper wrapper that DOESN'T set BROWSER to itself
        makeWrapper $out/lib/helium/helium $out/bin/helium \
          --chdir $out/lib/helium \
          --unset BROWSER

        # Copy icon if it exists
        if [ -f product_logo_256.png ]; then
          cp product_logo_256.png $out/share/pixmaps/helium.png
        fi

        # Create desktop entry with %U to properly handle URLs
        cat > $out/share/applications/helium.desktop <<EOF
    [Desktop Entry]
    Version=1.0
    Name=Helium
    GenericName=Web Browser
    Comment=Browse the web with Helium
    Exec=$out/bin/helium %U
    Terminal=false
    Type=Application
    Icon=helium
    Categories=Network;WebBrowser;
    MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
    StartupNotify=true
    StartupWMClass=helium
    EOF

        runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/imputnet/helium-linux";
    description = "Helium web browser";
    platforms = platforms.linux;
    mainProgram = "helium";
  };
}
