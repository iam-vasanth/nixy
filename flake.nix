{
  description = "Nixy Plymouth Theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "plymouth-theme-nixy";
            version = "1.0.0";

            src = ./.;

            dontBuild = true;

            installPhase = ''
              mkdir -p $out/share/plymouth/themes/nixy
              cp -r nixy/* $out/share/plymouth/themes/nixy/
            '';

            meta = with pkgs.lib; {
              description = "Nixy Plymouth Theme";
              platforms = platforms.linux;
            };
          };
        });
    };
}