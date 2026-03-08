{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}: let
  pname = "helium";
  version = "0.9.4.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "1s4yhbzcmh9wwg5mnk19m72r48px7259vy0z4yfqpb2fxid1v61p";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
      substituteInPlace $out/share/applications/helium.desktop \
        --replace-fail 'Exec=helium' 'Exec=$out/bin/helium'
      cp -r ${appimageContents}/usr/share/icons $out/share/icons
      sed -i '2i export CHROMIUM_FLAGS="--use-gl=egl $CHROMIUM_FLAGS"' $out/bin/helium
    '';
    meta = with lib; {
      homepage = "https://github.com/imputnet/helium-linux";
      description = "Helium web browser";
      platforms = ["x86_64-linux"];
      mainProgram = "helium";
    };
  }
