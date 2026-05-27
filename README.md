# rtk-nix

Nix flake for [rtk](https://github.com/rtk-ai/rtk) — Rust Token Killer, a high-performance CLI proxy that minimizes LLM token consumption.

## Usage

### Run without installing

```shell
nix run git+https://github.com/michnicki/rtk-nix -- --version
```

### Install to your profile

```shell
nix profile install git+https://github.com/michnicki/rtk-nix
```

### NixOS / nix-darwin flake

```nix
{
  inputs.rtk-nix.url = "git+https://github.com/michnicki/rtk-nix";

  outputs = { nixpkgs, rtk-nix, ... }: {
    nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        environment.systemPackages = [ rtk-nix.packages.x86_64-linux.default ];
      }];
    };
  };
}
```

### With overlay

```nix
{
  inputs.rtk-nix.url = "git+https://github.com/michnicki/rtk-nix";

  outputs = { nixpkgs, rtk-nix, ... }: {
    nixosConfigurations.mymachine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        nixpkgs.overlays = [ rtk-nix.overlays.default ];
        environment.systemPackages = [ pkgs.rtk ];
      }];
    };
  };
}
```

## Updating

1. Update `rev` and `hash` in `flake.nix` to the new tag.
2. Replace `Cargo.lock` with the one from the new release.
3. Run `nix build` — if the src hash is wrong, copy the correct hash from the error and update it.
4. Commit both files.
