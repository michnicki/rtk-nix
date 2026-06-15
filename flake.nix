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
        version = "0.42.4";

        src = pkgs.fetchFromGitHub {
          owner = "rtk-ai";
          repo = "rtk";
          rev = "v0.42.4";
          hash = "sha256-8nLJ5PVefXmoXQyw6HERfCP06C+l4I+7XLwKFNVNpew=";
        };

        cargoLock = {
          lockFile = ./Cargo.lock;
        };

        # Tests require filesystem access to ~/.config/rtk which is
        # not available in the Nix sandbox.
        doCheck = false;

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
      packages = forAllSystems (system:
        let pkg = rtkPackage nixpkgs.legacyPackages.${system};
        in { rtk = pkg; default = pkg; });

      overlays.default = final: _prev: {
        rtk = rtkPackage final;
      };
    };
}
