{
    description = "The Sans Undertale boss fight for the TI-84+ CE";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        toolchain = {
            url = "github:myclevorname/flake";
            inputs = {
                nixpkgs.follows = "nixpkgs";
            };
        };
        rust-overlay = {
            url = "github:oxalica/rust-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = {
        self,
        nixpkgs,
        toolchain,
        rust-overlay,
        ...
    }: let
      inherit (nixpkgs) lib;
      systems = [
          "x86_64-linux"
          "x86_64-darwin"
      ];
      pkgsFor = lib.genAttrs systems (system:
          import nixpkgs {
              localSystem.system = system;
              overlays = [(import rust-overlay)];
              config.allowUnfree = true;
          });
    in {
        packages = lib.mapAttrs (system: pkgs: {
            default = toolchain.packages.x86_64-linux.mkDerivation {
                pname = "sans-ti";
                version = "0.0.1";
                src = self;
            };
        })
        pkgsFor;
        devShells = lib.mapAttrs (system: pkgs: {
            default = pkgs.mkShell {
                inputsFrom = [self.packages.${system}.default];
                packages = with pkgs; [
                    (rust-bin.selectLatestNightlyWith (toolchain:
                        toolchain.default.override {
                            extensions = [
                                "rust-analyzer"
                                "rust-src"
                            ];
                        }))
                ];
            };
        })
        pkgsFor;
    };
}
