{
    inputs.toolchain.url = "github:myclevorname/flake";

    outputs = { self, toolchain }: {
        packages.x86_64-linux.default = toolchain.packages.x86_64-linux.mkDerivation {
            pname = "sans-ti";
            version = "0.0.1";
            src = self;
        };
    };
}
