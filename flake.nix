{
  description = "Dev shell for the TI-84 Plus CE port of the Sans Undertale boss fight.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    inherit (nixpkgs) lib;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        localSystem.system = system;
        overlays = [(import rust-overlay)];
      });
  in {
    formatter = lib.mapAttrs (_: pkgs: pkgs.alejandra) pkgsFor;
    devShells =
      lib.mapAttrs (system: pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            fasmg
            cargo-make
            (rust-bin.stable.latest.default.override {
              extensions = [
                "rust-analyzer"
                "rust-src"
              ];
            })
          ];
        };
      })
      pkgsFor;
  };
}
