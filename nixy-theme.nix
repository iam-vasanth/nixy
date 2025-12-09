{ stdenv }:
stdenv.mkDerivation rec {
  pname = "plymouth-nixy-theme";
  version = "1.0";
  
  src = ./nixy;  # Nixy directory
  
  dontConfigure = true;
  dontBuild = true;
  
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/nixy
    cp -r * $out/share/plymouth/themes/nixy/
    substituteInPlace $out/share/plymouth/themes/nixy/*.plymouth \
      --replace '@ROOT@' "$out/share/plymouth/themes/nixy/"
    runHook postInstall
  '';
}