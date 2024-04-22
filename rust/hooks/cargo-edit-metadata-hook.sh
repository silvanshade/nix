# shellcheck shell=bash

# Edit the `Cargo.toml` metadata:
# 1. Use the `version` from the `nix` app package (with some modifications to make it Cargo-legal)
# 2. Use the `description` from the `nix-rust-bridge` package
cargoEditMetadataHook() {
  local bridgeDescription="@bridgeDescription@"
  local bridgeVersion="@bridgeVersion@"

  # Rewrite "<major>.<minor>.<patch>(preYYYYMMDD-dirty)?" as "<major>.<minor>.<patch>(-preYYYYMMDD.dirty)?"
  # shellcheck disable=SC2001
  bridgeVersion="$(echo ${bridgeVersion} | sed 's/^\([[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\)\(.*\)$/\1-\2/g' | sed 's/_dirty$/.dirty/g')"

  pushd crates/bridge || return 1
    # Edit the `Cargo.toml`
    sed -i "s/^version\s*=\s*\".*\"\$/version = \"${bridgeVersion}\"/g" Cargo.toml
    sed -i "s/^description\s*=\s*\".*\"\$/description = \"${bridgeDescription}\"/g" Cargo.toml

    # Propagate the edits to `Cargo.lock`
    cargo update --offline
  popd || return 1
}
