# Nix Rust Core Documentation

This directory contains the Rust crates which interface with `nix`, for the following scenarios:

- (Rust -> C++) Rust functionality for use in the C++ libraries (e.g., BLAKE3, rayon, tokio)
- (C++ -> Rust) Rust bindings for the existing C++ libraries for other rust apps (not included yet)

## Structure

```
rust                -- workspace for the Rust crates
├── hooks           -- nix setup hooks for the nix-rust-bridge package
└── crates          -- individual Rust crates mirroring the structure of the C++ libs
    ├── bridge      -- cxx bridge crate which produces the `libnix_rust_bridge` library
    ├── ...         -- ...
    ├── libutil     -- support functionality for the C++ libutil library
    ├── ...         -- ...
```

The single bridging point between the C++ and Rust code is through the `bridge` crate.

This crate does not implement any interesting specific functionality of its own, but is instead used
to drive the `cxx` procedural macro which builds the crate into a library and generates the C++ and
Rust glue code for the binding declarations it contains.

## Hacking

Executing `nix develop` as described in the [Hacking
guide](https://nixos.org/manual/nix/unstable/contributing/hacking.html#building-nix-with-flakes) is
sufficient to set up all the necessary pre-requisites for building the Rust core.

### Building Separately

Within the nix shell, the crates can be built separately with `cargo build` in the `./rust` dir.

### Building for Linking into `nix`

The Rust core is built as part of the `nix-rust-bridge` package which is defined in the project
flake. The dependencies are packaged with `rustPlatform.fetchCargoTarball` and the bridge library is
built with `rustPlatform.buildRustPackage`.

See the [Rust](https://nixos.org/manual/nixpkgs/unstable/#rust) section in the [Nixpkgs Reference
Manual](https://nixos.org/manual/nixpkgs/unstable) for more details.

## Design Notes

For a detailed technical discussion of the design decisions see [DESIGN.md](DESIGN.md)
