{
  description = "Nixy - Plymouth Theme";

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
              INSTALL_PATH="$out/share/plymouth/themes/nixy"
              mkdir -p $INSTALL_PATH        
              cp -v nixy/nixy.plymouth $INSTALL_PATH/
              cp -v nixy/nixy.script $INSTALL_PATH/
              cp -v nixy/logo.png $INSTALL_PATH/
              sed -i "s@/usr/share@$out/share@g" $INSTALL_PATH/nixy.plymouth
              sed -i "s@/share@$out/share@g" $INSTALL_PATH/nixy.plymouth
            '';
          };
        });
    };
}