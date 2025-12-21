{
  description = "Nixy Plymouth Theme";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.stdenvNoCC.mkDerivation {
            pname = "plymouth-nixy";
            version = "1.0.0";
            src = ./.;
            installPhase = ''
              mkdir -p $out/share/plymouth/themes/nixy
              cp nixy/* $out/share/plymouth/themes/nixy/
              sed -i "s|/share|$out/share|g" $out/share/plymouth/themes/nixy/nixy.plymouth
            '';
          };
        });
    };
}