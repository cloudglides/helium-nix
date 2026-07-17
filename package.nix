{
  lib,
  fetchurl,
  appimageTools,
}: let
  pname = "helium";
  version = "0.14.6.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-qdM1Qysx5OOBwzr6A6tyPIfZcHxn2YkIPedGelvbk7I=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install desktop file
      install -Dm444 ${appimageContents}/helium.desktop \
        $out/share/applications/helium.desktop

      # Fix executable path
      substituteInPlace $out/share/applications/helium.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      # Install icons if present
      if [ -d ${appimageContents}/usr/share/icons ]; then
        cp -r ${appimageContents}/usr/share/icons $out/share/
      fi

      # Chromium EGL fix
      sed -i '2i export CHROMIUM_FLAGS="--use-gl=egl $CHROMIUM_FLAGS"' \
        $out/bin/${pname}
    '';

    meta = with lib; {
      description = "Helium web browser";
      homepage = "https://github.com/imputnet/helium-linux";
      platforms = ["x86_64-linux"];
      mainProgram = "helium";
    };
  }
