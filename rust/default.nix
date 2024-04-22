{ callPackage
, fetchFromGitHub
, fileset
, makeRustPlatform
, nix
, rust-bin
, ...
}:

let
  toolchain-stable = rust-bin.stable.latest;
  toolchain-nightly = rust-bin.nightly."2024-04-27";

  hooks = callPackage ./hooks {
    inherit nix-rust-bridge toolchain-stable toolchain-nightly;
    bridgeDescription = nix-rust-bridge.meta.description;
    bridgeVersion = nix-rust-bridge.version;
  };

  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.default;
    rustc = rust-bin.stable.latest.default;
  };

  nix-rust-bridge = rustPlatform.buildRustPackage rec {
    pname = "nix-rust-bridge";
    version = nix.version;

    setupHook = ./hooks/setup-hook.sh;

    nativeBuildInputs = [
      hooks.cargoClippyHook
      hooks.cargoEditMetadataHook
      hooks.cargoFmtCheckHook
      hooks.cxxCopyTargetBridgesHook
    ];

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    src = fileset.toSource {
      root = ./.;
      fileset = fileset.unions ([
        ./Cargo.lock
        ./Cargo.toml
        ./crates
        ./deny.toml
        ./rustfmt.toml
      ]);
    };
    buildAndTestSubdir = "crates/bridge";

    preBuild = ''
      cargoEditMetadataHook
      cargoFmtCheckHook
      cargoClippyHook
    '';

    postInstall = ''
      cxxCopyTargetBridgesHook $out
    '';

    meta = {
      inherit (nix.meta) platforms;
      description = "The Nix Rust cxx Bridge";
      maintainers = [
        { # TODO: add to nixpkgs
          email = "silvanshade@users.noreply.github.com";
          github = "silvanshade";
          githubId = "11022302";
          name = "silvanshade";
        }
      ];
    };
  };
in
nix-rust-bridge
