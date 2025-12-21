{
  description = "Nixy Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgsForSystem = system: import nixpkgs { inherit system; };
  in {
    packages = forAllSystems (system: let
      pkgs = pkgsForSystem system;
    in {
      nixy-plymouth-theme = pkgs.stdenv.mkDerivation {
        pname = "nixy-plymouth-theme";
        version = "1.0";
        src = self;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out/share/plymouth/themes/nixy

          # Copy the actual theme files from the nested directory
          cp -r nixy/nixy/* $out/share/plymouth/themes/nixy/

          # Patch any /usr/ paths in the .plymouth file to point to $out
          sed -i "s@/usr/@$out/@g" $out/share/plymouth/themes/nixy/nixy.plymouth
        '';
      };

      default = self.packages.${system}.nixy-plymouth-theme;
    });

    # Expose as overlay for easier use in other configs
    overlays.default = final: prev: {
      nixy-plymouth-theme = self.packages.${prev.system}.nixy-plymouth-theme;
    };
  };
}