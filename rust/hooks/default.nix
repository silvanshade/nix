{ bridgeDescription
, bridgeVersion
, callPackage
, cargo-deny
, coreutils
, gnused
, makeSetupHook
, nix-rust-bridge
, toolchain-stable
, toolchain-nightly
, writeShellScriptBin
, ...
}:

{
  cargoClippyHook = callPackage
    ({}:
      let name = "cargo-clippy-hook.sh"; in makeSetupHook
        {
          inherit name;
          propagatedBuildInputs = [
            toolchain-stable.default
            toolchain-stable.clippy
          ];
        } ./${name})
    { };

  cargoFmtCheckHook = callPackage
    ({}:
      let
        name = "cargo-fmt-check-hook.sh";
        cargo-fmt-nightly = writeShellScriptBin "cargo-fmt-nightly" ''
          export RUSTFMT="${toolchain-nightly.rustfmt}/bin/rustfmt"
          exec "${toolchain-stable.default}/bin/cargo-fmt" "$@"
        '';
      in makeSetupHook
        {
          inherit name;
          propagatedBuildInputs = [
            toolchain-stable.default
            toolchain-nightly.rustfmt
            cargo-fmt-nightly
          ];
        } ./${name})
    { };

  cargoEditMetadataHook = callPackage
    ({}:
      let name = "cargo-edit-metadata-hook.sh"; in makeSetupHook
        {
          inherit name;
          propagatedBuildInputs = [
            gnused
            toolchain-stable.cargo
          ];
          substitutions = {
            inherit bridgeDescription bridgeVersion;
          };
        } ./${name})
    { };

  cxxCopyTargetBridgesHook = callPackage
    ({}:
      let name = "cxx-copy-target-bridges-hook.sh"; in makeSetupHook
        {
          inherit name;
          propagatedBuildInputs = [
            coreutils
          ];
          substitutions = {
            inherit (nix-rust-bridge) pname;
          };
        } ./${name})
    { };
}
