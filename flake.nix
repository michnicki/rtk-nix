{
  description = "Rust Token Killer - CLI proxy to minimize LLM token consumption";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      rtkPackage = pkgs: pkgs.rustPlatform.buildRustPackage {
        pname = "rtk";
        version = "0.37.2";

        src = pkgs.fetchFromGitHub {
          owner = "rtk-ai";
          repo = "rtk";
          rev = "v0.37.2";
          hash = "sha256-rNuu8B5TnKZHrbVSV8HkcTeTdcol26259GGJEPEMPZY=";
        };

        cargoLock = {
          lockFile = ./Cargo.lock;
        };

        meta = with pkgs.lib; {
          description = "High-performance CLI proxy to minimize LLM token consumption";
          homepage = "https://www.rtk-ai.app";
          license = licenses.mit;
          mainProgram = "rtk";
          platforms = platforms.linux;
        };
      };
    in
    {
      packages = forAllSystems (system: {
        rtk = rtkPackage nixpkgs.legacyPackages.${system};
        default = rtkPackage nixpkgs.legacyPackages.${system};
      });

      overlays.default = final: _prev: {
        rtk = rtkPackage final;
      };
    };
}
