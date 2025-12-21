{
  description = "Nixy Plymouth Theme";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        pname = "nixy-plymouth-theme";
        version = "1.0";

        src = ./nixy;

        dontBuild = true;

        installPhase = ''
          # Create the standard Plymouth theme directory
          mkdir -p $out/share/plymouth/themes/nixy

          # Copy all files from src (the nixy/ folder) into the theme directory
          cp -r * $out/share/plymouth/themes/nixy/

          # Patch any /usr/ references in .plymouth files to point to the store path
          find $out/share/plymouth/themes/ -name "*.plymouth" -exec \
            sed -i "s|/usr/|$out/|g" {} \;
        '';
      };
  };
}