{
    description = "The Sans Undertale boss fight for the TI-84+ CE";
    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        toolchain = {
            url = "github:the-pink-hacker/ce-toolchain-nix";
            inputs = {
                nixpkgs.follows = "nixpkgs";
            };
        };
        rust-overlay = {
            url = "github:oxalica/rust-overlay";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        tice-rust = {
            url = "github:the-pink-hacker/tice-rust";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                rust-overlay.follows = "rust-overlay";
                flake-utils.follows = "flake-utils";
                toolchain.follows = "toolchain";
            };
        };
    };
    outputs = {
        self,
        nixpkgs,
        toolchain,
        rust-overlay,
        tice-rust,
        flake-utils,
        ...
    }:
        flake-utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {
                inherit system;
                overlays = [
                    (import rust-overlay)
                    tice-rust.overlays.${system}.default
                ];
                config.allowUnfree = true;
            };
            pkgsSelf = self.packages.${system};
        in {
            formatter = pkgs.alejandra;
            packages = {
                sans-ti = toolchain.packages.x86_64-linux.mkDerivation {
                    pname = "sans-ti";
                    version = "0.0.1";
                    src = self;
                    nativeBuildInputs = with pkgs; [
                        ti-asset-builder
                    ];
                };
                default = pkgsSelf.sans-ti;
            };
            devShells.default = pkgs.mkShell {
                inputsFrom = [pkgsSelf.default];
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
            overlays.default = final: prev: {
                inherit (self.packages.${prev.system}) sans-ti;
            };
        });
}
