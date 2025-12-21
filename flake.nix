{
  description = "Nixy Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    packages = forAllSystems (system: let
      pkgs = import nixpkgs { inherit system; };
    in {
      nixy-plymouth-theme = pkgs.stdenv.mkDerivation {
        pname = "nixy-plymouth-theme";
        version = "1.0";

        src = self;

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/share/plymouth/themes/nixy

          # Copy the theme files from the 'nixy' folder at repo root
          cp -r nixy/* $out/share/plymouth/themes/nixy/

          # Make the .plymouth file writable and patch any /usr/ paths
          chmod +w $out/share/plymouth/themes/nixy/nixy.plymouth
          sed -i "s|/usr/|$out/|g" $out/share/plymouth/themes/nixy/nixy.plymouth
        '';
      };

      default = self.packages.${system}.nixy-plymouth-theme;
    });

    overlays.default = final: prev: {
      nixy-plymouth-theme = self.packages.${prev.system}.nixy-plymouth-theme;
    };
  };
}